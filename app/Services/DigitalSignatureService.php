<?php

namespace App\Services;

use App\Models\EmployeeLeave;
use App\Models\User;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use LSNepomuceno\LaravelA1PdfSign\Sign\ManageCert;

class DigitalSignatureService
{
    public function __construct()
    {
        // No need for constructor with new package version
    }

    /**
     * Tạo chữ ký số cho đơn nghỉ phép
     */
    public function signLeaveRequest(EmployeeLeave $leaveRequest, User $signer, $certificatePath = null)
    {
        try {
            // For now, just approve without digital signature until package is properly configured
            $leaveRequest->update([
                'status' => 'approved',
                'workflow_status' => 'approved',
                'approved_by' => $signer->id,
                'approved_at' => now(),
                'digital_signature' => 'approved_by_' . $signer->name . '_at_' . now()->format('Y-m-d_H-i-s'),
            ]);

            return true;

        } catch (\Exception $e) {
            Log::error('Error approving leave request: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Tạo PDF từ đơn nghỉ phép
     */
    public function generateLeaveRequestPDF(EmployeeLeave $leaveRequest)
    {
        try {
            // Sử dụng TCPDF để tạo PDF tiếng Việt
            $pdf = new \TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);
            
            // Set document information
            $pdf->SetCreator('Hệ thống HRMS');
            $pdf->SetAuthor('HRMS');
            $pdf->SetTitle('Đơn xin nghỉ phép - ' . $leaveRequest->id);
            $pdf->SetSubject('Đơn xin nghỉ phép');
            
            // Set margins
            $pdf->SetMargins(20, 20, 20);
            $pdf->SetAutoPageBreak(TRUE, 25);
            
            // Add a page
            $pdf->AddPage();
            
            // Set font for Vietnamese
            $pdf->SetFont('dejavusans', '', 12);
            
            // Add content
            $html = $this->generateVietnamesePDFContent($leaveRequest);
            $pdf->writeHTML($html, true, false, true, false, '');
            
            // Add signature if available
            $this->addSignatureToPDF($pdf, $leaveRequest);
            
            return $pdf->Output('', 'S');
            
        } catch (\Exception $e) {
            Log::error('Error generating PDF: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Thêm chữ ký vào PDF
     */
    protected function addSignatureToPDF(\TCPDF $pdf, EmployeeLeave $leaveRequest)
    {
        if ($leaveRequest->approved_by) {
            $approver = User::find($leaveRequest->approved_by);
            
            // Get signature path from database or session
            $signaturePath = null;
            try {
                $signaturePath = $approver->signature_path ?? session('user_signature_path_' . $approver->id);
            } catch (\Exception $e) {
                $signaturePath = session('user_signature_path_' . $approver->id);
            }
            
            if ($approver && $signaturePath) {
                $fullSignaturePath = storage_path('app/public/' . $signaturePath);
                
                if (file_exists($fullSignaturePath)) {
                    // Position signature at bottom right
                    $pdf->SetXY(120, 250); // Adjust position as needed
                    
                    // Add signature image
                    $pdf->Image($fullSignaturePath, '', '', 60, 30, '', '', '', false, 300, '', false, false, 0);
                    
                    // Add approval text below signature
                    $pdf->SetXY(120, 280);
                    $pdf->SetFont('dejavusans', 'B', 10);
                    $pdf->Cell(60, 10, 'Người phê duyệt', 0, 1, 'C');
                    $pdf->SetXY(120, 285);
                    $pdf->SetFont('dejavusans', '', 9);
                    $pdf->Cell(60, 10, $approver->name, 0, 1, 'C');
                    $pdf->SetXY(120, 290);
                    $pdf->Cell(60, 10, $leaveRequest->approved_at->format('d/m/Y H:i'), 0, 1, 'C');
                }
            }
        }
    }

    /**
     * Tạo nội dung PDF tiếng Việt đẹp
     */
    protected function generateVietnamesePDFContent(EmployeeLeave $leaveRequest)
    {
        $user = User::find($leaveRequest->employee_id);
        $leave = $leaveRequest->leave;
        
        $html = '
        <style>
            .header {
                text-align: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 3px solid #667eea;
            }
            .company-name {
                font-size: 16px;
                font-weight: bold;
                color: #333;
                margin-bottom: 5px;
            }
            .document-title {
                font-size: 20px;
                font-weight: bold;
                color: #667eea;
                margin-top: 10px;
            }
            .info-table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
            }
            .info-table td {
                padding: 12px;
                border: 1px solid #dee2e6;
                vertical-align: top;
            }
            .label {
                font-weight: bold;
                background-color: #f8f9fa;
                width: 35%;
                color: #495057;
            }
            .value {
                background-color: white;
                color: #212529;
            }
            .status-approved {
                color: #28a745;
                font-weight: bold;
            }
            .status-pending {
                color: #ffc107;
                font-weight: bold;
            }
            .footer {
                margin-top: 40px;
                padding-top: 20px;
                border-top: 1px solid #dee2e6;
            }
        </style>
        
        <div class="header">
            <div class="company-name">HỆ THỐNG QUẢN LÝ NHÂN SỰ - HRMS</div>
            <div class="document-title">ĐƠN XIN NGHỈ PHÉP</div>
            <div style="font-size: 12px; color: #6c757d; margin-top: 10px;">
                Số: ' . str_pad($leaveRequest->id, 4, '0', STR_PAD_LEFT) . '/' . date('Y') . '/NP-HRMS
            </div>
        </div>
        
        <table class="info-table">
            <tr>
                <td class="label">Họ và tên nhân viên:</td>
                <td class="value">' . ($user->name ?? 'N/A') . '</td>
            </tr>
            <tr>
                <td class="label">Mã nhân viên:</td>
                <td class="value">' . ($user->username ?? 'N/A') . '</td>
            </tr>
            <tr>
                <td class="label">Loại nghỉ phép:</td>
                <td class="value">' . ($leave->name ?? 'N/A') . '</td>
            </tr>
            <tr>
                <td class="label">Thời gian nghỉ:</td>
                <td class="value">
                    Từ ngày: ' . ($leaveRequest->from_date ? $leaveRequest->from_date->format('d/m/Y') : 'N/A') . '<br>
                    Đến ngày: ' . ($leaveRequest->to_date ? $leaveRequest->to_date->format('d/m/Y') : 'N/A') . '
                </td>
            </tr>
            <tr>
                <td class="label">Lý do nghỉ phép:</td>
                <td class="value">' . ($leaveRequest->note ?: 'Không có ghi chú cụ thể') . '</td>
            </tr>
            <tr>
                <td class="label">Ngày tạo đơn:</td>
                <td class="value">' . ($leaveRequest->created_at ? $leaveRequest->created_at->format('d/m/Y H:i') : 'N/A') . '</td>
            </tr>
            <tr>
                <td class="label">Trạng thái:</td>
                <td class="value">
                    <span class="status-' . ($leaveRequest->status ?? 'pending') . '">
                        ' . match($leaveRequest->status ?? 'pending') {
                            'pending' => 'CHỜ PHÊ DUYỆT',
                            'approved' => 'ĐÃ PHÊ DUYỆT', 
                            'rejected' => 'BỊ TỪ CHỐI',
                            default => 'KHÔNG XÁC ĐỊNH'
                        } . '
                    </span>
                </td>
            </tr>';
        
        if ($leaveRequest->approved_at) {
            $approver = User::find($leaveRequest->approved_by);
            $html .= '
            <tr>
                <td class="label">Ngày phê duyệt:</td>
                <td class="value">' . $leaveRequest->approved_at->format('d/m/Y H:i') . '</td>
            </tr>
            <tr>
                <td class="label">Người phê duyệt:</td>
                <td class="value">' . ($approver->name ?? 'N/A') . '</td>
            </tr>';
        }
        
        if ($leaveRequest->rejection_reason) {
            $html .= '
            <tr>
                <td class="label">Lý do từ chối:</td>
                <td class="value" style="color: #dc3545;">' . $leaveRequest->rejection_reason . '</td>
            </tr>';
        }
        
        $html .= '</table>';
        
        // Add footer
        $html .= '
        <div class="footer">
            <p style="font-size: 10px; color: #6c757d; text-align: center;">
                Đơn này được tạo tự động bởi Hệ thống HRMS vào ngày ' . now()->format('d/m/Y H:i') . '
            </p>
        </div>';
        
        return $html;
    }

    /**
     * Tạo HTML cho đơn nghỉ phép
     */
    protected function generateLeaveRequestHTML(EmployeeLeave $leaveRequest)
    {
        $user = \App\Models\User::find($leaveRequest->employee_id);
        $leave = $leaveRequest->leave;
        
        // Use safe encoding for Vietnamese characters
        $employeeName = htmlspecialchars($user->name ?? 'N/A', ENT_QUOTES, 'UTF-8');
        $username = htmlspecialchars($user->username ?? 'N/A', ENT_QUOTES, 'UTF-8');
        $leaveTypeName = htmlspecialchars($leave->name ?? 'N/A', ENT_QUOTES, 'UTF-8');
        $note = htmlspecialchars($leaveRequest->note ?: 'N/A', ENT_QUOTES, 'UTF-8');
        $status = htmlspecialchars($leaveRequest->status ?? 'pending', ENT_QUOTES, 'UTF-8');
        
        return "
        <div style='text-align: center; margin-bottom: 20px;'>
            <h2>DON XIN NGHI PHEP</h2>
        </div>
        
        <table style='width: 100%; border-collapse: collapse; margin-bottom: 20px;'>
            <tr>
                <td style='width: 30%; padding: 8px; border: 1px solid #ddd;'><strong>Ho va ten:</strong></td>
                <td style='width: 70%; padding: 8px; border: 1px solid #ddd;'>{$employeeName}</td>
            </tr>
            <tr>
                <td style='padding: 8px; border: 1px solid #ddd;'><strong>Username:</strong></td>
                <td style='padding: 8px; border: 1px solid #ddd;'>{$username}</td>
            </tr>
            <tr>
                <td style='padding: 8px; border: 1px solid #ddd;'><strong>Loai nghi phep:</strong></td>
                <td style='padding: 8px; border: 1px solid #ddd;'>{$leaveTypeName}</td>
            </tr>
            <tr>
                <td style='padding: 8px; border: 1px solid #ddd;'><strong>Tu ngay:</strong></td>
                <td style='padding: 8px; border: 1px solid #ddd;'>" . ($leaveRequest->from_date ? $leaveRequest->from_date->format('d/m/Y') : 'N/A') . "</td>
            </tr>
            <tr>
                <td style='padding: 8px; border: 1px solid #ddd;'><strong>Den ngay:</strong></td>
                <td style='padding: 8px; border: 1px solid #ddd;'>" . ($leaveRequest->to_date ? $leaveRequest->to_date->format('d/m/Y') : 'N/A') . "</td>
            </tr>
            <tr>
                <td style='padding: 8px; border: 1px solid #ddd;'><strong>Ly do:</strong></td>
                <td style='padding: 8px; border: 1px solid #ddd;'>{$note}</td>
            </tr>
        </table>
        
        <div style='margin-top: 30px;'>
            <p><strong>Trang thai:</strong> {$status}</p>
            <p><strong>Ngay phe duyet:</strong> " . ($leaveRequest->approved_at ? $leaveRequest->approved_at->format('d/m/Y H:i') : 'Chua phe duyet') . "</p>
        </div>
        ";
    }

    /**
     * Lấy đường dẫn certificate mặc định
     */
    protected function getDefaultCertificatePath(User $signer)
    {
        // Trong thực tế, bạn sẽ lưu certificate của từng user
        // Ở đây tôi sử dụng certificate mẫu
        return storage_path('app/certificates/default.p12');
    }

    /**
     * Export PDF đã ký
     */
    public function exportSignedPDF(EmployeeLeave $leaveRequest)
    {
        if (!$leaveRequest->digital_signature) {
            throw new \Exception('Don nghi phep chua duoc ky');
        }

        // Export as simple text file to avoid UTF-8 issues
        $user = \App\Models\User::find($leaveRequest->employee_id);
        
        $content = "DON XIN NGHI PHEP #" . $leaveRequest->id . "\n";
        $content .= "================================\n\n";
        $content .= "Ho va ten: " . ($user->name ?? 'N/A') . "\n";
        $content .= "Username: " . ($user->username ?? 'N/A') . "\n";
        $content .= "Loai nghi phep: " . ($leaveRequest->leave->name ?? 'N/A') . "\n";
        $content .= "Tu ngay: " . ($leaveRequest->from_date ? $leaveRequest->from_date->format('d/m/Y') : 'N/A') . "\n";
        $content .= "Den ngay: " . ($leaveRequest->to_date ? $leaveRequest->to_date->format('d/m/Y') : 'N/A') . "\n";
        $content .= "Ly do: " . ($leaveRequest->note ?: 'Khong co') . "\n\n";
        $content .= "TRANG THAI: " . strtoupper($leaveRequest->status ?? 'pending') . "\n";
        $content .= "Ngay tao: " . ($leaveRequest->created_at ? $leaveRequest->created_at->format('d/m/Y H:i') : 'N/A') . "\n";
        $content .= "Ngay phe duyet: " . ($leaveRequest->approved_at ? $leaveRequest->approved_at->format('d/m/Y H:i') : 'Chua phe duyet') . "\n\n";
        $content .= "CHU KY SO: " . $leaveRequest->digital_signature . "\n";
        
        // Clean content to avoid encoding issues
        $content = mb_convert_encoding($content, 'UTF-8', 'UTF-8');
        
        return response($content)
            ->header('Content-Type', 'text/plain; charset=utf-8')
            ->header('Content-Disposition', 'attachment; filename="leave_request_' . $leaveRequest->id . '_signed.txt"');
    }

    /**
     * Xác thực chữ ký số
     */
    public function verifySignature(EmployeeLeave $leaveRequest)
    {
        if (!$leaveRequest->digital_signature) {
            return false;
        }

        try {
            $pdfContent = base64_decode($leaveRequest->digital_signature);
            
            // Lưu tạm để verify
            $tempPath = storage_path('app/temp/verify_' . $leaveRequest->id . '.pdf');
            Storage::disk('local')->put('temp/verify_' . $leaveRequest->id . '.pdf', $pdfContent);
            
            // Verify signature
            $isValid = $this->pdfSigner->verifyPdf($tempPath);
            
            // Xóa file tạm
            Storage::disk('local')->delete('temp/verify_' . $leaveRequest->id . '.pdf');
            
            return $isValid;
            
        } catch (\Exception $e) {
            Log::error('Error verifying signature: ' . $e->getMessage());
            return false;
        }
    }
}
