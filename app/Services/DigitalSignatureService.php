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

            // Update employee leave balance
            $this->updateEmployeeLeaveBalance($leaveRequest);

            return true;

        } catch (\Exception $e) {
            Log::error('Error approving leave request: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Update employee leave balance after approval
     */
    public function updateEmployeeLeaveBalance(EmployeeLeave $leaveRequest)
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
            
            // Get signature path from database
            $signaturePath = $approver->signature_path;
            
            if ($approver && $signaturePath) {
                $fullSignaturePath = storage_path('app/public/' . $signaturePath);
                
                if (file_exists($fullSignaturePath)) {
                    // Add approval text above signature
                    $pdf->SetXY(120, 160);
                    $pdf->SetFont('dejavusans', 'B', 10);
                    $pdf->Cell(60, 10, 'Người phê duyệt', 0, 1, 'C');
                    
                    // Add signature image
                    $pdf->SetXY(130, 170);
                    $pdf->Image($fullSignaturePath, '', '', 40, 20, '', '', '', false, 300, '', false, false, 0);
                    
                    // Add approver name below signature
                    $pdf->SetXY(120, 195);
                    $pdf->SetFont('dejavusans', '', 9);
                    $pdf->Cell(60, 10, $approver->name, 0, 1, 'C');
                    $pdf->SetXY(120, 200);
                    $pdf->SetFont('dejavusans', '', 8);
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
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 2px solid #667eea;
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
                border-spacing: 0;
            }
            .info-table td {
                padding: 10px 12px;
                border: 1px solid #dee2e6;
                vertical-align: top;
                font-size: 12px;
                line-height: 1.5;
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
            <div class="company-name">NHÀ MÁY A31 - QUÂN CHỦNG PK-KQ</div>
            <div class="document-title">ĐƠN XIN NGHỈ PHÉP</div>
        </div>
        
        <table class="info-table">
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Họ và tên nhân viên:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($user->name ?? 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Mã nhân viên:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($user->username ?? 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Loại nghỉ phép:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($leave->name ?? 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Thời gian nghỉ:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;
                    Từ ngày: ' . ($leaveRequest->from_date ? $leaveRequest->from_date->format('d/m/Y') : 'N/A') . '<br>&nbsp;&nbsp;
                    Đến ngày: ' . ($leaveRequest->to_date ? $leaveRequest->to_date->format('d/m/Y') : 'N/A') . '&nbsp;&nbsp;<br>&nbsp;
                </td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Lý do nghỉ phép:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($leaveRequest->note ?: 'Không có ghi chú cụ thể') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Ngày tạo đơn:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($leaveRequest->created_at ? $leaveRequest->created_at->format('d/m/Y H:i') : 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Trạng thái:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;
                    <span class="status-' . ($leaveRequest->status ?? 'pending') . '">
                        ' . match($leaveRequest->status ?? 'pending') {
                            'pending' => 'CHỜ PHÊ DUYỆT',
                            'approved' => 'ĐÃ PHÊ DUYỆT', 
                            'rejected' => 'BỊ TỪ CHỐI',
                            default => 'KHÔNG XÁC ĐỊNH'
                        } . '
                    </span>&nbsp;&nbsp;<br>&nbsp;
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
        
        // No footer needed
        
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

    /**
     * Tạo PDF đăng ký xe với chữ ký số
     */
    public function generateVehicleRegistrationPDF($registration)
    {
        try {
            // Sử dụng TCPDF để tạo PDF tiếng Việt
            $pdf = new \TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);
            
            // Set document information
            $pdf->SetCreator('HRMS - Hệ thống quản lý nhân sự');
            $pdf->SetAuthor('Quân đội nhân dân Việt Nam');
            $pdf->SetTitle('Đăng ký xe công - ' . $registration->id);
            $pdf->SetSubject('Đăng ký sử dụng xe công');
            
            // Remove default header/footer
            $pdf->setPrintHeader(false);
            $pdf->setPrintFooter(false);
            
            // Set margins
            $pdf->SetMargins(20, 20, 20);
            $pdf->SetAutoPageBreak(true, 25);
            
            // Add a page
            $pdf->AddPage();
            
            // Generate HTML content
            $htmlContent = $this->generateVehicleRegistrationHTMLContent($registration);
            
            // Write HTML content
            $pdf->writeHTML($htmlContent, true, false, true, false, '');
            
            // Add signatures if available
            $this->addVehicleSignaturesToPDF($pdf, $registration);
            
            return $pdf->Output('', 'S'); // Return as string
            
        } catch (\Exception $e) {
            Log::error('Error generating vehicle registration PDF: ' . $e->getMessage());
            
            // Fallback: return plain text file
            $content = $this->generateVehicleRegistrationTextContent($registration);
            return $content;
        }
    }

    /**
     * Tạo nội dung HTML cho PDF đăng ký xe
     */
    private function generateVehicleRegistrationHTMLContent($registration)
    {
        $user = $registration->user;
        $vehicle = $registration->vehicle;
        
        return '
        <div style="text-align: center; margin-bottom: 30px;">
            <h2 style="color: #2c5aa0; font-weight: bold; margin-bottom: 10px;">QUÂN ĐỘI NHÂN DÂN VIỆT NAM</h2>
            <h3 style="color: #2c5aa0; font-weight: bold; margin-bottom: 20px;">ĐƠN ĐĂNG KÝ SỬ DỤNG XE CÔNG</h3>
            <p style="margin-bottom: 30px;"><strong>Số:</strong> ' . str_pad($registration->id, 4, '0', STR_PAD_LEFT) . '/ĐKXC</p>
        </div>

        <div style="margin-bottom: 20px;">
            <table style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td style="width: 30%; padding: 8px 0; font-weight: bold;">Người đăng ký:</td>
                    <td style="width: 70%; padding: 8px 0;">' . htmlspecialchars($user->name ?? 'N/A', ENT_QUOTES, 'UTF-8') . '</td>
                </tr>
                <tr>
                    <td style="padding: 8px 0; font-weight: bold;">Đơn vị:</td>
                    <td style="padding: 8px 0;">Phòng Kế hoạch</td>
                </tr>
                <tr>
                    <td style="padding: 8px 0; font-weight: bold;">Xe đăng ký:</td>
                    <td style="padding: 8px 0;">' . htmlspecialchars($vehicle->full_name ?? 'N/A', ENT_QUOTES, 'UTF-8') . '</td>
                </tr>
                <tr>
                    <td style="padding: 8px 0; font-weight: bold;">Lái xe:</td>
                    <td style="padding: 8px 0;">' . htmlspecialchars($registration->driver_name ?? 'N/A', ENT_QUOTES, 'UTF-8') . '</td>
                </tr>
                <tr>
                    <td style="padding: 8px 0; font-weight: bold;">Ngày đi:</td>
                    <td style="padding: 8px 0;">' . \Carbon\Carbon::parse($registration->departure_date)->format('d/m/Y') . '</td>
                </tr>
                <tr>
                    <td style="padding: 8px 0; font-weight: bold;">Ngày về:</td>
                    <td style="padding: 8px 0;">' . \Carbon\Carbon::parse($registration->return_date)->format('d/m/Y') . '</td>
                </tr>
                <tr>
                    <td style="padding: 8px 0; font-weight: bold;">Tuyến đường:</td>
                    <td style="padding: 8px 0;">' . htmlspecialchars($registration->route ?? 'N/A', ENT_QUOTES, 'UTF-8') . '</td>
                </tr>
                <tr>
                    <td style="padding: 8px 0; font-weight: bold;">Lý do sử dụng:</td>
                    <td style="padding: 8px 0;">' . htmlspecialchars($registration->purpose ?? 'N/A', ENT_QUOTES, 'UTF-8') . '</td>
                </tr>
                <tr>
                    <td style="padding: 8px 0; font-weight: bold;">Ngày tạo đơn:</td>
                    <td style="padding: 8px 0;">' . \Carbon\Carbon::parse($registration->created_at)->format('d/m/Y H:i') . '</td>
                </tr>
            </table>
        </div>

        <div style="margin-top: 40px;">
            <p style="text-align: center; font-style: italic;">Kính đề nghị lãnh đạo xem xét và phê duyệt.</p>
        </div>';
    }

    /**
     * Thêm chữ ký vào PDF đăng ký xe
     */
    private function addVehicleSignaturesToPDF($pdf, $registration)
    {
        $yPosition = 200; // Starting Y position for signatures
        
        // Department signature
        if ($registration->digital_signature_dept) {
            $deptSignature = json_decode($registration->digital_signature_dept, true);
            $this->addSignatureToVehiclePDF($pdf, $deptSignature, 30, $yPosition, 'Trưởng phòng Kế hoạch');
        }
        
        // Director signature
        if ($registration->digital_signature_director) {
            $directorSignature = json_decode($registration->digital_signature_director, true);
            $this->addSignatureToVehiclePDF($pdf, $directorSignature, 120, $yPosition, 'Ban Giám đốc');
        }
    }

    /**
     * Thêm một chữ ký vào vị trí cụ thể trong PDF
     */
    private function addSignatureToVehiclePDF($pdf, $signatureData, $x, $y, $title)
    {
        // Add signature title
        $pdf->SetXY($x, $y);
        $pdf->SetFont('dejavusans', 'B', 12);
        $pdf->Cell(0, 10, $title, 0, 1, 'C');
        
        // Add signature image if available
        if (isset($signatureData['signature_path']) && !empty($signatureData['signature_path'])) {
            $signaturePath = storage_path('app/public/' . $signatureData['signature_path']);
            
            if (file_exists($signaturePath)) {
                $pdf->Image($signaturePath, $x + 10, $y + 15, 40, 20);
            }
        }
        
        // Add approval info
        $pdf->SetXY($x, $y + 40);
        $pdf->SetFont('dejavusans', '', 10);
        $pdf->Cell(0, 5, 'Người phê duyệt: ' . ($signatureData['approved_by'] ?? 'N/A'), 0, 1, 'C');
        $pdf->SetXY($x, $y + 45);
        $pdf->Cell(0, 5, 'Thời gian: ' . ($signatureData['approved_at'] ?? 'N/A'), 0, 1, 'C');
    }

    /**
     * Tạo nội dung text fallback cho đăng ký xe
     */
    private function generateVehicleRegistrationTextContent($registration)
    {
        $user = $registration->user;
        $vehicle = $registration->vehicle;
        
        return "=== ĐƠN ĐĂNG KÝ SỬ DỤNG XE CÔNG ===\n\n" .
               "Số: " . str_pad($registration->id, 4, '0', STR_PAD_LEFT) . "/ĐKXC\n\n" .
               "Người đăng ký: " . ($user->name ?? 'N/A') . "\n" .
               "Đơn vị: Phòng Kế hoạch\n" .
               "Xe đăng ký: " . ($vehicle->full_name ?? 'N/A') . "\n" .
               "Lái xe: " . ($registration->driver_name ?? 'N/A') . "\n" .
               "Ngày đi: " . \Carbon\Carbon::parse($registration->departure_date)->format('d/m/Y') . "\n" .
               "Ngày về: " . \Carbon\Carbon::parse($registration->return_date)->format('d/m/Y') . "\n" .
               "Tuyến đường: " . ($registration->route ?? 'N/A') . "\n" .
               "Lý do sử dụng: " . ($registration->purpose ?? 'N/A') . "\n" .
               "Ngày tạo đơn: " . \Carbon\Carbon::parse($registration->created_at)->format('d/m/Y H:i') . "\n\n" .
               "=== CHỮ KÝ PHÊ DUYỆT ===\n";
    }
}
