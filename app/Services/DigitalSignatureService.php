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

            // Add centered logo
            $logoPath = public_path('assets/img/logo/logo.png');
            if (file_exists($logoPath)) {
                // width 28mm, centered (A4 width 210mm)
                $logoWidth = 28;
                $centerX = (210 - $logoWidth) / 2;
                $pdf->Image($logoPath, $centerX, 12, $logoWidth, 0, '', '', '', false, 300, '', false, false, 0);
                // Adjust cursor below logo
                $pdf->SetY(28);
            }

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
            // Sử dụng TCPDF để tạo PDF tiếng Việt (same as leaves)
            $pdf = new \TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

            // Set document information
            $pdf->SetCreator('Hệ thống HRMS');
            $pdf->SetAuthor('HRMS');
            $pdf->SetTitle('Đăng ký xe công - ' . $registration->id);
            $pdf->SetSubject('Đăng ký xe công');

            // Set margins
            $pdf->SetMargins(20, 20, 20);
            $pdf->SetAutoPageBreak(TRUE, 25);

            // Add a page
            $pdf->AddPage();

            // Add centered logo
            $logoPath = public_path('assets/img/logo/logo.png');
            if (file_exists($logoPath)) {
                $logoWidth = 28;
                $centerX = (210 - $logoWidth) / 2;
                $pdf->Image($logoPath, $centerX, 12, $logoWidth, 0, '', '', '', false, 300, '', false, false, 0);
                $pdf->SetY(28);
            }

            // Set font for Vietnamese
            $pdf->SetFont('dejavusans', '', 12);

            // Add content
            $html = $this->generateVehicleRegistrationHTMLContent($registration);
            $pdf->writeHTML($html, true, false, true, false, '');
            
            // Add visual signatures if available
            $this->addVehicleSignaturesToPDF($pdf, $registration);

            // Export unsigned PDF to memory
            $unsignedPdfContent = $pdf->Output('', 'S');

            // Attempt to sign with PKI (A1) if certificate configured
            $certPathEnv = env('A1_CERT_PATH');
            $certPassEnv = env('A1_CERT_PASSWORD');

            if (!empty($certPathEnv) && !empty($certPassEnv)) {
                // Resolve certificate absolute path
                $certAbsolutePath = str_starts_with($certPathEnv, DIRECTORY_SEPARATOR)
                    ? $certPathEnv
                    : base_path($certPathEnv);

                if (file_exists($certAbsolutePath)) {
                    // Write unsigned PDF to a temp file
                    $unsignedPath = storage_path('app/temp/vehicle_' . $registration->id . '_unsigned.pdf');
                    Storage::disk('local')->put('temp/vehicle_' . $registration->id . '_unsigned.pdf', $unsignedPdfContent);

                    // Define signed output path
                    $signedPath = storage_path('app/temp/vehicle_' . $registration->id . '_signed.pdf');

                    try {
                        $signer = new ManageCert($certAbsolutePath, $certPassEnv);
                        $signer->setFile($unsignedPath)->sign($signedPath);

                        // Read signed PDF bytes
                        $signedPdfContent = file_get_contents($signedPath);

                        // Cleanup temp files
                        Storage::disk('local')->delete([
                            'temp/vehicle_' . $registration->id . '_unsigned.pdf',
                            'temp/vehicle_' . $registration->id . '_signed.pdf',
                        ]);

                        return $signedPdfContent;
                    } catch (\Exception $e) {
                        Log::error('Vehicle PDF signing failed: ' . $e->getMessage());
                        // Fallback to unsigned content on failure
                        return $unsignedPdfContent;
                    }
                } else {
                    Log::warning('A1 certificate file not found at path: ' . $certAbsolutePath);
                }
            }

            // If no certificate configured, return unsigned PDF
            return $unsignedPdfContent;

        } catch (\Exception $e) {
            Log::error('Error generating vehicle registration PDF: ' . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Tạo nội dung HTML cho PDF đăng ký xe
     */
    private function generateVehicleRegistrationHTMLContent($registration)
    {
        $user = $registration->user;
        $vehicle = $registration->vehicle;

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
            .footer {
                margin-top: 40px;
                padding-top: 20px;
                border-top: 1px solid #dee2e6;
            }
        </style>

        <div class="header">
            <div class="company-name">NHÀ MÁY A31 - QUÂN CHỦNG PK-KQ</div>
            <div class="document-title">ĐƠN ĐĂNG KÝ SỬ DỤNG XE</div>
        </div>

        <table class="info-table">
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Người đăng ký:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($user->name ?? 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Đơn vị:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;Phòng Kế hoạch&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Xe đăng ký:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($vehicle->full_name ?? 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Lái xe:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($registration->driver_name ?? 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Thời gian sử dụng:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;
                    Từ ngày: ' . \Carbon\Carbon::parse($registration->departure_date)->format('d/m/Y') . '<br>&nbsp;&nbsp;
                    Đến ngày: ' . \Carbon\Carbon::parse($registration->return_date)->format('d/m/Y') . '&nbsp;&nbsp;<br>&nbsp;
                </td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Tuyến đường:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($registration->route ?? 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Mục đích sử dụng:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . ($registration->purpose ?? 'N/A') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
            <tr>
                <td class="label"><br>&nbsp;&nbsp;Ngày tạo đơn:&nbsp;&nbsp;<br>&nbsp;</td>
                <td class="value"><br>&nbsp;&nbsp;' . \Carbon\Carbon::parse($registration->created_at)->format('d/m/Y H:i') . '&nbsp;&nbsp;<br>&nbsp;</td>
            </tr>
        </table>';

        return $html;
    }

    /**
     * Thêm chữ ký vào PDF đăng ký xe (both dept and director signatures)
     */
    private function addVehicleSignaturesToPDF($pdf, $registration)
    {
        // Place signatures just below the table content, but not above a minimum baseline
        $yPosition = max($pdf->GetY() + 12, 160);

        // If too close to the bottom, start a new page
        if ($yPosition > 240) {
            $pdf->AddPage();
            $yPosition = 40;
        }

        // Department signature (left side)
        if ($registration->digital_signature_dept) {
            $deptSignature = json_decode($registration->digital_signature_dept, true);

            // Add department title
            $pdf->SetXY(30, $yPosition);
            $pdf->SetFont('dejavusans', 'B', 10);
            $pdf->Cell(60, 10, 'Trưởng phòng Kế hoạch', 0, 1, 'C');

            if (isset($deptSignature['signature_path']) && !empty($deptSignature['signature_path'])) {
                $signaturePath = storage_path('app/public/' . $deptSignature['signature_path']);
                if (file_exists($signaturePath)) {
                    // Add signature image
                    $pdf->Image($signaturePath, 40, $yPosition + 15, 40, 20, '', '', '', false, 300, '', false, false, 0);
                }
            }

            // Add approval date (above) and approver name (below)
            $pdf->SetXY(30, $yPosition + 40);
            $pdf->SetFont('dejavusans', '', 9);
            $deptApprovedAt = isset($deptSignature['approved_at']) && !empty($deptSignature['approved_at'])
                ? \Carbon\Carbon::parse($deptSignature['approved_at'])->format('d/m/Y')
                : 'N/A';
            $pdf->Cell(60, 6, $deptApprovedAt, 0, 1, 'C');
            $pdf->SetXY(30, $yPosition + 47);
            $pdf->SetFont('dejavusans', '', 9);
            $pdf->Cell(60, 6, $deptSignature['approved_by'] ?? 'N/A', 0, 1, 'C');
        }

        // Director signature (right side)
        if ($registration->digital_signature_director) {
            $directorSignature = json_decode($registration->digital_signature_director, true);

            // Add director title
            $pdf->SetXY(120, $yPosition);
            $pdf->SetFont('dejavusans', 'B', 10);
            $pdf->Cell(60, 10, 'Ban Giám đốc', 0, 1, 'C');

            if (isset($directorSignature['signature_path']) && !empty($directorSignature['signature_path'])) {
                $signaturePath = storage_path('app/public/' . $directorSignature['signature_path']);
                if (file_exists($signaturePath)) {
                    // Add signature image
                    $pdf->Image($signaturePath, 130, $yPosition + 15, 40, 20, '', '', '', false, 300, '', false, false, 0);
                }
            }

            // Add approval date (above) and approver name (below)
            $pdf->SetXY(120, $yPosition + 40);
            $pdf->SetFont('dejavusans', '', 9);
            $dirApprovedAt = isset($directorSignature['approved_at']) && !empty($directorSignature['approved_at'])
                ? \Carbon\Carbon::parse($directorSignature['approved_at'])->format('d/m/Y')
                : 'N/A';
            $pdf->Cell(60, 6, $dirApprovedAt, 0, 1, 'C');
            $pdf->SetXY(120, $yPosition + 47);
            $pdf->SetFont('dejavusans', '', 9);
            $pdf->Cell(60, 6, $directorSignature['approved_by'] ?? 'N/A', 0, 1, 'C');
        }
    }

    /**
     * Thêm một chữ ký vào vị trí cụ thể trong PDF
     */
    private function addSignatureToVehiclePDF($pdf, $signatureData, $x, $y, $title)
    {
        // Add signature title with UTF-8 encoding
        $pdf->SetXY($x, $y);
        $pdf->SetFont('dejavusans', 'B', 12);
        $pdf->Cell(0, 10, mb_convert_encoding($title, 'UTF-8', 'UTF-8'), 0, 1, 'C');

        // Add signature image if available
        if (isset($signatureData['signature_path']) && !empty($signatureData['signature_path'])) {
            $signaturePath = storage_path('app/public/' . $signatureData['signature_path']);

            if (file_exists($signaturePath)) {
                $pdf->Image($signaturePath, $x + 10, $y + 15, 40, 20);
            }
        }

        // Add approval info with proper encoding
        $approvedBy = htmlspecialchars($signatureData['approved_by'] ?? 'N/A', ENT_QUOTES, 'UTF-8');
        $approvedAt = htmlspecialchars($signatureData['approved_at'] ?? 'N/A', ENT_QUOTES, 'UTF-8');

        $pdf->SetXY($x, $y + 40);
        $pdf->SetFont('dejavusans', '', 10);
        $pdf->Cell(0, 5, 'Người phê duyệt: ' . $approvedBy, 0, 1, 'C');
        $pdf->SetXY($x, $y + 45);
        $pdf->Cell(0, 5, 'Thời gian: ' . $approvedAt, 0, 1, 'C');
    }

    /**
     * Tạo nội dung text fallback cho đăng ký xe
     */
    private function generateVehicleRegistrationTextContent($registration)
    {
        $user = $registration->user;
        $vehicle = $registration->vehicle;

        $content = "=== ĐƠN ĐĂNG KÝ SỬ DỤNG XE ===\n\n" .
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

        // Clean content to avoid UTF-8 encoding issues (same as leaves module)
        $content = mb_convert_encoding($content, 'UTF-8', 'UTF-8');

        return $content;
    }
}
