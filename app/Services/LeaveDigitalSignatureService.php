<?php

namespace App\Services;

use App\Models\EmployeeLeave;
use App\Models\Employee;
use App\Models\User;
use Illuminate\Support\Facades\Log;

class LeaveDigitalSignatureService extends BaseDigitalSignatureService
{
    public function signLeaveRequest(EmployeeLeave $leaveRequest, User $signer, $certificatePath = null)
    {
        try {
            $pdfBinary = $this->generateLeaveRequestPDF($leaveRequest);
            $signedPdfBinary = $this->signPdfBinary($pdfBinary);
            $signedPdfPath = $this->storeSignedPdf($signedPdfBinary, 'signed/leaves/leave_' . $leaveRequest->id . '_signed.pdf');

            $leaveRequest->update([
                'status' => 'approved',
                'workflow_status' => 'approved',
                'approved_by' => $signer->id,
                'approved_at' => now(),
                'digital_signature' => json_encode([
                    'signed_at' => now()->toISOString(),
                    'signed_by' => $signer->id,
                    'signed_by_name' => $signer->name,
                    'certificate_used' => 'a31.pfx',
                    'signature_hash' => hash('sha256', $signedPdfBinary),
                    'file_size' => strlen($signedPdfBinary)
                ]),
                'signed_pdf_path' => $signedPdfPath,
            ]);

            $this->updateEmployeeLeaveBalance($leaveRequest);

            return true;

        } catch (\Exception $e) {
            Log::error('Error signing leave request: ' . $e->getMessage());
            throw $e;
        }
    }

    public function generateLeaveRequestPDF(EmployeeLeave $leaveRequest)
    {
        try {
            $pdf = $this->createBasePDF(
                'Đơn xin nghỉ phép - ' . $leaveRequest->id,
                'Đơn xin nghỉ phép'
            );

            $html = $this->generateLeaveRequestHTML($leaveRequest);
            $pdf->writeHTML($html, true, false, true, false, '');

            if ($leaveRequest->approved_at && $leaveRequest->approved_by) {
                $approver = User::find($leaveRequest->approved_by);
                if ($approver) {
                    $this->addVisualSignature($pdf, $approver, $leaveRequest->approved_at);
                }
            }

            return $pdf->Output('', 'S');

        } catch (\Exception $e) {
            Log::error('Error generating leave request PDF: ' . $e->getMessage());
            throw $e;
        }
    }

    private function generateLeaveRequestHTML(EmployeeLeave $leaveRequest)
    {
        $user = User::find($leaveRequest->employee_id);
        $leave = $leaveRequest->leave;
        
        // Lấy thông tin employee để có phòng ban, chức vụ, cấp bậc
        $employee = Employee::where('user_id', $user->id)->first();
        if (!$employee && $user->name) {
            $employee = Employee::where('name', $user->name)->first();
        }

        $tableData = [
            ['label' => 'Họ và tên nhân viên', 'value' => $user->name ?? 'N/A'],
            ['label' => 'Username', 'value' => $user->username ?? 'N/A'],
            ['label' => 'Phòng ban', 'value' => $employee?->department?->name ?? 'N/A'],
            ['label' => 'Chức vụ', 'value' => $employee?->position?->name ?? 'N/A'],
            ['label' => 'Cấp bậc', 'value' => $employee?->rank_code ?? 'N/A'],
            ['label' => 'Loại nghỉ phép', 'value' => $leave->name ?? 'N/A'],
            ['label' => 'Thời gian nghỉ', 'value' => 'Từ: ' . ($leaveRequest->from_date ? $leaveRequest->from_date->format('d/m/Y') : 'N/A') . ' | Đến: ' . ($leaveRequest->to_date ? $leaveRequest->to_date->format('d/m/Y') : 'N/A')],
            ['label' => 'Lý do nghỉ phép', 'value' => $leaveRequest->note ?: 'Không có ghi chú'],
            ['label' => 'Ngày tạo đơn', 'value' => $leaveRequest->created_at ? $leaveRequest->created_at->format('d/m/Y H:i') : 'N/A'],
            ['label' => 'Trạng thái', 'value' => '<span class="status-' . ($leaveRequest->status ?? 'pending') . '">' . match($leaveRequest->status ?? 'pending') {
                'pending' => 'CHỜ PHÊ DUYỆT',
                'approved' => 'ĐÃ PHÊ DUYỆT', 
                'rejected' => 'BỊ TỪ CHỐI',
                default => 'KHÔNG XÁC ĐỊNH'
            } . '</span>']
        ];

        if ($leaveRequest->approved_at) {
            $approver = User::find($leaveRequest->approved_by);
            $tableData[] = ['label' => 'Ngày phê duyệt', 'value' => $leaveRequest->approved_at->format('d/m/Y H:i')];
            $tableData[] = ['label' => 'Người phê duyệt', 'value' => $approver->name ?? 'N/A'];
        }

        if ($leaveRequest->rejection_reason) {
            $tableData[] = ['label' => 'Lý do từ chối', 'value' => '<span style="color: #dc3545;">' . $leaveRequest->rejection_reason . '</span>'];
        }

        return $this->generateDocumentHTML(
            'NHÀ MÁY A31 - QUÂN CHỦNG PK-KQ',
            'ĐƠN XIN NGHỈ PHÉP',
            $tableData
        );
    }

    private function updateEmployeeLeaveBalance(EmployeeLeave $leaveRequest)
    {
        $employee = \App\Models\Employee::find($leaveRequest->employee_id);
        if ($employee) {
            $leaveDays = \Carbon\Carbon::parse($leaveRequest->from_date)->diffInDays(\Carbon\Carbon::parse($leaveRequest->to_date)) + 1;
            $newUsed = $employee->annual_leave_used + $leaveDays;
            $newBalance = max(0, $employee->annual_leave_total - $newUsed);

            $employee->update([
                'annual_leave_used' => $newUsed,
                'annual_leave_balance' => $newBalance
            ]);
        }
    }

    protected function getSignatureReason(): string
    {
        return 'Ký số tài liệu đơn nghỉ phép';
    }
}