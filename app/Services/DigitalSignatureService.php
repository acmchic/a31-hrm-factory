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
    protected function generateLeaveRequestPDF(EmployeeLeave $leaveRequest)
    {
        try {
            // Sử dụng TCPDF để tạo PDF
            $pdf = new \TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);
            
            // Set document information (avoid Vietnamese characters)
            $pdf->SetCreator('HRMS System');
            $pdf->SetAuthor('HRMS');
            $pdf->SetTitle('Leave Request - ' . $leaveRequest->id);
            $pdf->SetSubject('Leave Request');
            
            // Set margins
            $pdf->SetMargins(15, 15, 15);
            $pdf->SetHeaderMargin(5);
            $pdf->SetFooterMargin(10);
            
            // Add a page
            $pdf->AddPage();
            
            // Set font with UTF-8 support
            $pdf->SetFont('dejavusans', '', 12);
            
            // Add content
            $html = $this->generateLeaveRequestHTML($leaveRequest);
            $pdf->writeHTML($html, true, false, true, false, '');
            
            return $pdf->Output('', 'S');
            
        } catch (\Exception $e) {
            Log::error('Error generating PDF: ' . $e->getMessage());
            
            // Return simple text response if PDF fails
            $user = \App\Models\User::find($leaveRequest->employee_id);
            $content = "LEAVE REQUEST #" . $leaveRequest->id . "\n\n";
            $content .= "Employee: " . ($user->name ?? 'N/A') . "\n";
            $content .= "Username: " . ($user->username ?? 'N/A') . "\n";
            $content .= "Leave Type: " . ($leaveRequest->leave->name ?? 'N/A') . "\n";
            $content .= "From: " . ($leaveRequest->from_date ? $leaveRequest->from_date->format('d/m/Y') : 'N/A') . "\n";
            $content .= "To: " . ($leaveRequest->to_date ? $leaveRequest->to_date->format('d/m/Y') : 'N/A') . "\n";
            $content .= "Note: " . ($leaveRequest->note ?: 'N/A') . "\n";
            $content .= "Status: " . ($leaveRequest->status ?? 'pending') . "\n";
            $content .= "Created: " . ($leaveRequest->created_at ? $leaveRequest->created_at->format('d/m/Y H:i') : 'N/A') . "\n";
            
            return $content;
        }
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
