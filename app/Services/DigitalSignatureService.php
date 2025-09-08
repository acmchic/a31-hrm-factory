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

    }


    public function readCertificateFromFile(?string $absolutePath = null, ?string $passphrase = null)
    {
        $path = $absolutePath ?: env('PDF_CERT_PATH');
        $pwd = $passphrase ?? env('PDF_CERT_PASS');

        if (!$path || !is_string($path)) {
            throw new \InvalidArgumentException('Certificate path is not configured (PDF_CERT_PATH).');
        }


        if (!file_exists($path)) {
            $resolvedPath = base_path($path);
            if (file_exists($resolvedPath)) {
                $path = $resolvedPath;
            } else {

                Log::info('Certificate not found, attempting to create automatically...');
                $this->ensurePfxExists();


                if (file_exists($path)) {
                    $path = $path;
                } elseif (file_exists($resolvedPath)) {
                    $path = $resolvedPath;
                } else {
                    throw new \InvalidArgumentException('Certificate file not found and could not be created. Tried: ' . $path . ', ' . $resolvedPath);
                }
            }
        }

        if ($pwd === null || $pwd === '') {
            throw new \InvalidArgumentException('Certificate passphrase is not configured (PDF_CERT_PASS).');
        }

        $manager = new ManageCert();

        if (method_exists($manager, 'fromPfx')) {
            return $manager->fromPfx($path, $pwd);
        }

        if (method_exists($manager, 'fromP12')) {
            return $manager->fromP12($path, $pwd);
        }

        if (method_exists($manager, 'fromFile')) {
            return $manager->fromFile($path, $pwd);
        }

        throw new \RuntimeException('ManageCert does not support loading certificate from file in this version.');
    }


    public function signPdfBinary(string $pdfBinary)
    {
        try {
            $cert = $this->readCertificateFromFile();


            $tempPdfPath = tempnam(sys_get_temp_dir(), 'pdf_') . '.pdf';
            file_put_contents($tempPdfPath, $pdfBinary);

            $signaturePdf = new \LSNepomuceno\LaravelA1PdfSign\Sign\SignaturePdf($tempPdfPath, $cert);

            $signedPdf = $signaturePdf->signature();


            unlink($tempPdfPath);

            return $signedPdf;

        } catch (\Exception $e) {
            Log::error('Error signing PDF: ' . $e->getMessage());
            throw $e;
        }
    }


    public function storeSignedPdf(string $signedBinary, string $relativePath)
    {
        $fullPath = storage_path('app/' . $relativePath);
        $dir = dirname($fullPath);

        if (!is_dir($dir)) {
            mkdir($dir, 0755, true);
        }

        file_put_contents($fullPath, $signedBinary);
        return $relativePath;
    }


    public function ensurePfxExists()
    {
        $certPath = env('PDF_CERT_PATH', 'storage/certs/a31.pfx');
        $certPass = env('PDF_CERT_PASS', 'A31_CertSign');


        $fullPath = file_exists($certPath) ? $certPath : base_path($certPath);

        if (!file_exists($fullPath)) {
            Log::info('PFX certificate not found, creating automatically...');
            $this->generatePfxCertificate($fullPath, $certPass);
        }
    }


    private function generatePfxCertificate(string $outputPath, string $passphrase)
    {

        $dir = dirname($outputPath);
        if (!is_dir($dir)) {
            mkdir($dir, 0755, true);
        }


        $keyFile = tempnam(sys_get_temp_dir(), 'key_');
        $certFile = tempnam(sys_get_temp_dir(), 'cert_');
        $pfxFile = tempnam(sys_get_temp_dir(), 'pfx_');

        try {

            $keyCmd = "openssl genrsa -out {$keyFile} 2048 2>/dev/null";
            exec($keyCmd, $output, $returnCode);

            if ($returnCode !== 0) {
                throw new \Exception('Failed to generate private key');
            }


            $certCmd = "openssl req -new -x509 -key {$keyFile} -out {$certFile} -days 3650 " .
                      "-subj '/C=VN/ST=HCM/L=HCM/O=A31 Factory/OU=IT/CN=A31 Factory Digital Signing/emailAddress=admin@a31.com' 2>/dev/null";
            exec($certCmd, $output, $returnCode);

            if ($returnCode !== 0) {
                throw new \Exception('Failed to generate certificate');
            }


            $pfxCmd = "openssl pkcs12 -export -out {$pfxFile} -inkey {$keyFile} -in {$certFile} -passout pass:{$passphrase} 2>/dev/null";
            exec($pfxCmd, $output, $returnCode);

            if ($returnCode !== 0) {
                throw new \Exception('Failed to create PFX');
            }


            if (!copy($pfxFile, $outputPath)) {
                throw new \Exception('Failed to save PFX to final location');
            }

            Log::info("PFX certificate created successfully: {$outputPath}");

        } finally {

            @unlink($keyFile);
            @unlink($certFile);
            @unlink($pfxFile);
        }
    }


    public function createLeaveRequestTemplate(EmployeeLeave $leaveRequest)
    {
        try {
            $pdfBinary = $this->generateLeaveRequestPDF($leaveRequest);
            $templatePath = $this->storeSignedPdf($pdfBinary, 'templates/leaves/leave_' . $leaveRequest->id . '_template.pdf');

            $leaveRequest->update([
                'template_pdf_path' => $templatePath
            ]);

            return $templatePath;
        } catch (\Exception $e) {
            Log::error('Error creating leave request template: ' . $e->getMessage());
            throw $e;
        }
    }

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

            // Tạo lại PDF với ảnh chữ ký sau khi đã approve
            $pdfBinaryWithSignature = $this->generateLeaveRequestPDF($leaveRequest->fresh());
            $signedPdfBinaryWithSignature = $this->signPdfBinary($pdfBinaryWithSignature);
            $signedPdfPathWithSignature = $this->storeSignedPdf($signedPdfBinaryWithSignature, 'signed/leaves/leave_' . $leaveRequest->id . '_signed.pdf');

            // Cập nhật lại với PDF có ảnh chữ ký
            $leaveRequest->update([
                'signed_pdf_path' => $signedPdfPathWithSignature,
                'digital_signature' => json_encode([
                    'signed_at' => now()->toISOString(),
                    'signed_by' => $signer->id,
                    'signed_by_name' => $signer->name,
                    'certificate_used' => 'a31.pfx',
                    'signature_hash' => hash('sha256', $signedPdfBinaryWithSignature),
                    'file_size' => strlen($signedPdfBinaryWithSignature)
                ])
            ]);


            $this->updateEmployeeLeaveBalance($leaveRequest);

            return true;

        } catch (\Exception $e) {
            Log::error('Error signing leave request: ' . $e->getMessage());
            throw $e;
        }
    }


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


    public function generateLeaveRequestPDF(EmployeeLeave $leaveRequest)
    {
        try {

            $pdf = new \TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);


            $pdf->SetCreator('Hệ thống A31');
            $pdf->SetAuthor('A31');
            $pdf->SetTitle('Đơn xin nghỉ phép - ' . $leaveRequest->id);
            $pdf->SetSubject('Đơn xin nghỉ phép');


            $pdf->SetMargins(20, 20, 20);
            $pdf->SetAutoPageBreak(TRUE, 25);


            $pdf->AddPage();


        $logoPath = public_path('assets/img/logo/logo.png');
        if (file_exists($logoPath)) {
            // Thu nhỏ logo và đặt ở vị trí phù hợp
            $logoWidth = 20; // Giảm từ 28 xuống 20
            $centerX = (210 - $logoWidth) / 2;
            $pdf->Image($logoPath, $centerX, 8, $logoWidth, 0, '', '', '', false, 300, '', false, false, 0);

            $pdf->SetY(22); // Giảm từ 28 xuống 22
        }


            $pdf->SetFont('dejavusans', '', 12);


            $html = $this->generateProfessionalLeavePDF($leaveRequest);
            $pdf->writeHTML($html, true, false, true, false, '');

            // Thêm chữ ký trực quan góc phải trên cùng (nếu có) và tên Trưởng phòng bên dưới
            $this->addVisualSignatureToLeavePDF($pdf, $leaveRequest);

            return $pdf->Output('', 'S');

        } catch (\Exception $e) {
            Log::error('Error generating PDF: ' . $e->getMessage());
            throw $e;
        }
    }


    protected function addVisualSignatureToPDF(\TCPDF $pdf, EmployeeLeave $leaveRequest)
    {
        if (!$leaveRequest->approved_at || !$leaveRequest->approved_by) {
            return;
        }

        $approver = \App\Models\User::find($leaveRequest->approved_by);
        if (!$approver || !$approver->signature_path) {
            return;
        }

        $signaturePath = storage_path('app/public/' . $approver->signature_path);
        if (!file_exists($signaturePath)) {
            return;
        }

        // Thêm trang mới cho chữ ký
        $pdf->AddPage();

        // Tiêu đề
        $pdf->SetFont('dejavusans', 'B', 16);
        $pdf->Cell(0, 10, 'CHỮ KÝ PHÊ DUYỆT', 0, 1, 'C');
        $pdf->Ln(10);

        // Thông tin người phê duyệt
        $pdf->SetFont('dejavusans', '', 12);
        $pdf->Cell(0, 8, 'Người phê duyệt: ' . $approver->name, 0, 1, 'L');
        $pdf->Cell(0, 8, 'Ngày ký: ' . $leaveRequest->approved_at->format('d/m/Y H:i'), 0, 1, 'L');
        $pdf->Ln(10);

        // Thêm ảnh chữ ký
        $pdf->Image($signaturePath, 50, $pdf->GetY(), 100, 0, '', '', '', false, 300, '', false, false, 0);

        // Thêm chữ ký số info
        $pdf->SetY($pdf->GetY() + 50);
        $pdf->SetFont('dejavusans', 'I', 10);
        $pdf->Cell(0, 8, 'Chữ ký số: A31 Factory Digital Signing', 0, 1, 'C');
        $pdf->Cell(0, 8, 'Certificate: a31.pfx', 0, 1, 'C');
    }

    protected function addSignatureToPDF(\TCPDF $pdf, EmployeeLeave $leaveRequest)
    {
        if ($leaveRequest->approved_by) {
            $approver = User::find($leaveRequest->approved_by);


            $signaturePath = $approver->signature_path;

            if ($approver && $signaturePath) {
                $fullSignaturePath = storage_path('app/public/' . $signaturePath);

                if (file_exists($fullSignaturePath)) {

                    $pdf->SetXY(120, 160);
                    $pdf->SetFont('dejavusans', 'B', 10);
                    $pdf->Cell(60, 10, 'Người phê duyệt', 0, 1, 'C');


                    $pdf->SetXY(130, 170);
                    $pdf->Image($fullSignaturePath, '', '', 40, 20, '', '', '', false, 300, '', false, false, 0);


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
     * Thêm chữ ký trực quan vào PDF nghỉ phép ở góc phải trên
     */
    private function addVisualSignatureToLeavePDF(\TCPDF $pdf, EmployeeLeave $leaveRequest)
    {
        if (!$leaveRequest->approved_at || !$leaveRequest->approved_by) {
            return;
        }

        $approver = User::find($leaveRequest->approved_by);
        if (!$approver || !$approver->signature_path) {
            return;
        }

        $signaturePath = storage_path('app/public/' . $approver->signature_path);
        if (!file_exists($signaturePath)) {
            return;
        }

        // Vị trí góc phải dưới - không che khuất nội dung
        $pageWidth = 210; // mm
        $rightMargin = 20; // mm
        $imageWidth = 40; // mm - giảm kích thước
        $imageHeight = 20; // mm - giảm chiều cao
        $x = $pageWidth - $rightMargin - $imageWidth; // ~150mm từ lề trái
        $y = 200; // Dịch xuống dưới, gần cuối trang

        // Vẽ khung viền cho chữ ký
        $pdf->SetDrawColor(200, 200, 200); // Màu xám nhạt
        $pdf->SetLineWidth(0.3);
        $pdf->Rect($x - 2, $y - 2, $imageWidth + 4, $imageHeight + 15, 'D');

        // Vẽ ảnh chữ ký
        $pdf->Image($signaturePath, $x, $y, $imageWidth, $imageHeight, '', '', '', false, 300, '', false, false, 0);

        // Ghi tên Trưởng phòng bên dưới ảnh chữ ký
        $pdf->SetFont('dejavusans', 'B', 8);
        $pdf->SetTextColor(0, 0, 0);
        $pdf->SetXY($x - 2, $y + $imageHeight + 2);
        $pdf->Cell($imageWidth + 4, 5, $approver->name, 0, 0, 'C');

        // Thêm ngày ký
        $pdf->SetFont('dejavusans', '', 7);
        $pdf->SetXY($x - 2, $y + $imageHeight + 7);
        $pdf->Cell($imageWidth + 4, 4, $leaveRequest->approved_at->format('d/m/Y'), 0, 0, 'C');
    }








    protected function generateProfessionalLeavePDF(EmployeeLeave $leaveRequest)
    {
        $user = \App\Models\User::find($leaveRequest->employee_id);
        $leave = $leaveRequest->leave;

        $html = '
        <style>
            body {
                font-family: dejavusans, sans-serif;
                font-size: 11pt;
                color: #333;
                line-height: 1.4;
                margin: 0;
                padding: 0;
            }

            .header {
                text-align: center;
                margin-bottom: 25px;
                padding: 15px 0;
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 8px;
                border: 1px solid #dee2e6;
            }

            .company-name {
                font-size: 14pt;
                font-weight: bold;
                color: #2c3e50;
                margin-bottom: 5px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .document-title {
                font-size: 18pt;
                font-weight: bold;
                color: #0056b3;
                margin-top: 5px;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
            }

            .info-section {
                background: #ffffff;
                border: 1px solid #dee2e6;
                border-radius: 6px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .info-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 10pt;
            }

            .info-table tr {
                border-bottom: 1px solid #f1f3f4;
            }

            .info-table tr:last-child {
                border-bottom: none;
            }

            .info-table td {
                padding: 12px 15px;
                vertical-align: top;
            }

            .label {
                font-weight: bold;
                background-color: #f8f9fa;
                color: #495057;
                width: 35%;
                border-right: 2px solid #dee2e6;
                position: relative;
            }

            .label:after {
                content: ":";
                position: absolute;
                right: 10px;
            }

            .value {
                background-color: #ffffff;
                color: #212529;
                width: 65%;
                font-weight: 500;
            }

            .status-approved {
                color: #28a745;
                font-weight: bold;
                background-color: #d4edda;
                padding: 4px 8px;
                border-radius: 4px;
                display: inline-block;
            }
            .status-pending {
                color: #856404;
                font-weight: bold;
                background-color: #fff3cd;
                padding: 4px 8px;
                border-radius: 4px;
                display: inline-block;
            }
            .status-rejected {
                color: #721c24;
                font-weight: bold;
                background-color: #f8d7da;
                padding: 4px 8px;
                border-radius: 4px;
                display: inline-block;
            }

            .approval-section {
                background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
                border: 1px solid #bbdefb;
                border-radius: 6px;
                padding: 20px;
                margin-top: 20px;
            }

            .approval-title {
                font-size: 12pt;
                font-weight: bold;
                color: #1976d2;
                text-align: center;
                margin-bottom: 15px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .approval-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: white;
                padding: 15px;
                border-radius: 4px;
                border: 1px solid #e1f5fe;
            }

            .approver-info {
                flex: 1;
            }

            .approver-name {
                font-weight: bold;
                color: #2c3e50;
                font-size: 11pt;
                margin-bottom: 5px;
            }

            .approval-date {
                color: #666;
                font-size: 9pt;
            }

            .signature-line {
                flex: 1;
                text-align: center;
                border-bottom: 2px solid #333;
                margin: 0 20px;
                padding-bottom: 5px;
                font-weight: bold;
                color: #555;
            }

            .footer {
                margin-top: 25px;
                padding: 15px;
                background-color: #f8f9fa;
                border-top: 2px solid #0056b3;
                font-size: 9pt;
                color: #666;
                text-align: center;
                border-radius: 0 0 6px 6px;
            }
        </style>

        <div class="header">
            <div class="company-name">NHÀ MÁY A31 - QUÂN CHỦNG PK-KQ</div>
            <div class="document-title">ĐƠN XIN NGHỈ PHÉP</div>
        </div>

        <div class="info-section">
            <table class="info-table">
                <tr>
                    <td class="label">Họ và tên nhân viên</td>
                    <td class="value">' . ($user->name ?? 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">Username</td>
                    <td class="value">' . ($user->username ?? 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">Loại nghỉ phép</td>
                    <td class="value">' . ($leave->name ?? 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">Thời gian nghỉ</td>
                    <td class="value">
                        Từ: ' . ($leaveRequest->from_date ? $leaveRequest->from_date->format('d/m/Y') : 'N/A') . ' |
                        Đến: ' . ($leaveRequest->to_date ? $leaveRequest->to_date->format('d/m/Y') : 'N/A') . '
                    </td>
                </tr>
                <tr>
                    <td class="label">Lý do nghỉ phép</td>
                    <td class="value">' . ($leaveRequest->note ?: 'Không có ghi chú') . '</td>
                </tr>
                <tr>
                    <td class="label">Ngày tạo đơn</td>
                    <td class="value">' . ($leaveRequest->created_at ? $leaveRequest->created_at->format('d/m/Y H:i') : 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">Trạng thái</td>
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
            $approver = \App\Models\User::find($leaveRequest->approved_by);
            $html .= '
                <tr>
                    <td class="label">Ngày phê duyệt</td>
                    <td class="value">' . $leaveRequest->approved_at->format('d/m/Y H:i') . '</td>
                </tr>
                <tr>
                    <td class="label">Người phê duyệt</td>
                    <td class="value">' . ($approver->name ?? 'N/A') . '</td>
                </tr>';
        }

        if ($leaveRequest->rejection_reason) {
            $html .= '
                <tr>
                    <td class="label">Lý do từ chối</td>
                    <td class="value" style="color: #dc3545;">' . $leaveRequest->rejection_reason . '</td>
                </tr>';
        }

        $html .= '
            </table>
        </div>';

        return $html;
    }

    public function generateApprovalSignatureSection(EmployeeLeave $leaveRequest)
    {
        if (!$leaveRequest->approved_at || !$leaveRequest->approved_by) {
            return '';
        }

        $approver = \App\Models\User::find($leaveRequest->approved_by);
        if (!$approver) {
            return '';
        }

        $signatureHtml = '
        <div style="margin-top: 40px; border-top: 2px solid #333; padding-top: 20px;">
            <h3 style="text-align: center; margin-bottom: 20px; color: #333;">CHỮ KÝ PHÊ DUYỆT</h3>
            <table style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td style="width: 50%; padding: 20px; text-align: center; vertical-align: top;">
                        <div style="border: 1px solid #ddd; padding: 20px; background-color: #f8f9fa;">
                            <p style="margin: 0 0 10px 0; font-weight: bold; color: #333;">Người phê duyệt:</p>
                            <p style="margin: 0 0 15px 0; font-size: 16px; color: #555;">' . htmlspecialchars($approver->name ?? 'N/A', ENT_QUOTES, 'UTF-8') . '</p>
                            <p style="margin: 0; font-size: 12px; color: #666;">Ngày ký: ' . $leaveRequest->approved_at->format('d/m/Y H:i') . '</p>
                        </div>
                    </td>
                    <td style="width: 50%; padding: 20px; text-align: center; vertical-align: top;">';

        // Hiển thị ảnh chữ ký nếu có
        if ($approver->signature_path && file_exists(storage_path('app/public/' . $approver->signature_path))) {
            $signaturePath = storage_path('app/public/' . $approver->signature_path);
            $signatureHtml .= '
                        <div style="border: 2px solid #ddd; padding: 15px; background-color: #fff; display: inline-block;">
                            <img src="' . $signaturePath . '"
                                 style="max-width: 200px; max-height: 100px; object-fit: contain; display: block;"
                                 alt="Chữ ký của ' . htmlspecialchars($approver->name, ENT_QUOTES, 'UTF-8') . '">
                        </div>';
        } else {
            $signatureHtml .= '
                        <div style="border: 2px solid #ddd; padding: 20px; min-height: 100px; background-color: #fff; display: flex; align-items: center; justify-content: center;">
                            <p style="color: #666; font-style: italic; margin: 0;">Chưa có chữ ký</p>
                        </div>';
        }

        $signatureHtml .= '
                    </td>
                </tr>
            </table>
        </div>';

        return $signatureHtml;
    }

    protected function getDefaultCertificatePath(User $signer)
    {


        return storage_path('app/certificates/default.p12');
    }


    public function exportSignedPDF(EmployeeLeave $leaveRequest)
    {
        if (!$leaveRequest->digital_signature) {
            throw new \Exception('Don nghi phep chua duoc ky');
        }


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


        $content = mb_convert_encoding($content, 'UTF-8', 'UTF-8');

        return response($content)
            ->header('Content-Type', 'text/plain; charset=utf-8')
            ->header('Content-Disposition', 'attachment; filename="leave_request_' . $leaveRequest->id . '_signed.txt"');
    }


    public function verifySignature(EmployeeLeave $leaveRequest)
    {
        if (!$leaveRequest->digital_signature) {
            return false;
        }

        try {
            $pdfContent = base64_decode($leaveRequest->digital_signature);


            $tempPath = storage_path('app/temp/verify_' . $leaveRequest->id . '.pdf');
            Storage::disk('local')->put('temp/verify_' . $leaveRequest->id . '.pdf', $pdfContent);


            $isValid = $this->pdfSigner->verifyPdf($tempPath);


            Storage::disk('local')->delete('temp/verify_' . $leaveRequest->id . '.pdf');

            return $isValid;

        } catch (\Exception $e) {
            Log::error('Error verifying signature: ' . $e->getMessage());
            return false;
        }
    }


    public function generateVehicleRegistrationPDF($registration)
    {
        try {

            $pdf = new \TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);


            $pdf->SetCreator('Hệ thống A31');
            $pdf->SetAuthor('A31');
            $pdf->SetTitle('Đăng ký xe công - ' . $registration->id);
            $pdf->SetSubject('Đăng ký xe công');


            $pdf->SetMargins(20, 20, 20);
            $pdf->SetAutoPageBreak(TRUE, 25);


            $pdf->AddPage();


            // Bỏ logo lớn để tránh layout xấu


            $pdf->SetFont('dejavusans', '', 12);


            $html = $this->generateVehicleRegistrationHTMLContent($registration);
            $pdf->writeHTML($html, true, false, true, false, '');

            // Thêm chữ ký trực quan góc phải trên cùng (ưu tiên Trưởng phòng)
            $this->addVisualSignatureToVehiclePDF($pdf, $registration);

            return $pdf->Output('', 'S');

        } catch (\Exception $e) {
            Log::error('Error generating vehicle registration PDF: ' . $e->getMessage());
            throw $e;
        }
    }


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


    private function addVehicleSignaturesToPDF($pdf, $registration)
    {

        $yPosition = max($pdf->GetY() + 12, 160);


        if ($yPosition > 240) {
            $pdf->AddPage();
            $yPosition = 40;
        }


        if ($registration->digital_signature_dept) {
            $deptSignature = json_decode($registration->digital_signature_dept, true);


            $pdf->SetXY(30, $yPosition);
            $pdf->SetFont('dejavusans', 'B', 10);
            $pdf->Cell(60, 10, 'Trưởng phòng Kế hoạch', 0, 1, 'C');

            if (isset($deptSignature['signature_path']) && !empty($deptSignature['signature_path'])) {
                $signaturePath = storage_path('app/public/' . $deptSignature['signature_path']);
                if (file_exists($signaturePath)) {

                    $pdf->Image($signaturePath, 40, $yPosition + 15, 40, 20, '', '', '', false, 300, '', false, false, 0);
                } else {

                    $approver = \App\Models\User::where('name', $deptSignature['approved_by'])->first();
                    if ($approver && $approver->signature_path) {
                        $userSignaturePath = storage_path('app/public/' . $approver->signature_path);
                        if (file_exists($userSignaturePath)) {
                            $pdf->Image($userSignaturePath, 40, $yPosition + 15, 40, 20, '', '', '', false, 300, '', false, false, 0);
                        }
                    }
                }
            } else {

                $approver = \App\Models\User::where('name', $deptSignature['approved_by'])->first();
                if ($approver && $approver->signature_path) {
                    $userSignaturePath = storage_path('app/public/' . $approver->signature_path);
                    if (file_exists($userSignaturePath)) {
                        $pdf->Image($userSignaturePath, 40, $yPosition + 15, 40, 20, '', '', '', false, 300, '', false, false, 0);
                    }
                }
            }


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


        if ($registration->digital_signature_director) {
            $directorSignature = json_decode($registration->digital_signature_director, true);


            $pdf->SetXY(120, $yPosition);
            $pdf->SetFont('dejavusans', 'B', 10);
            $pdf->Cell(60, 10, 'Ban Giám đốc', 0, 1, 'C');

            if (isset($directorSignature['signature_path']) && !empty($directorSignature['signature_path'])) {
                $signaturePath = storage_path('app/public/' . $directorSignature['signature_path']);
                if (file_exists($signaturePath)) {

                    $pdf->Image($signaturePath, 130, $yPosition + 15, 40, 20, '', '', '', false, 300, '', false, false, 0);
                } else {

                    $approver = \App\Models\User::where('name', $directorSignature['approved_by'])->first();
                    if ($approver && $approver->signature_path) {
                        $userSignaturePath = storage_path('app/public/' . $approver->signature_path);
                        if (file_exists($userSignaturePath)) {
                            $pdf->Image($userSignaturePath, 130, $yPosition + 15, 40, 20, '', '', '', false, 300, '', false, false, 0);
                        }
                    }
                }
            } else {

                $approver = \App\Models\User::where('name', $directorSignature['approved_by'])->first();
                if ($approver && $approver->signature_path) {
                    $userSignaturePath = storage_path('app/public/' . $approver->signature_path);
                    if (file_exists($userSignaturePath)) {
                        $pdf->Image($userSignaturePath, 130, $yPosition + 15, 40, 20, '', '', '', false, 300, '', false, false, 0);
                    }
                }
            }


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
     * Thêm chữ ký trực quan vào PDF đăng ký xe ở góc phải trên
     * Ưu tiên chữ ký Trưởng phòng nếu có, hiển thị tên Trưởng phòng bên dưới.
     */
    private function addVisualSignatureToVehiclePDF($pdf, $registration)
    {
        $chosenImagePath = null;
        $displayName = null;

        // Ưu tiên chữ ký Trưởng phòng
        if (!empty($registration->digital_signature_dept)) {
            $deptSig = json_decode($registration->digital_signature_dept, true);
            if (is_array($deptSig)) {
                $displayName = $deptSig['approved_by'] ?? $displayName;
                if (!empty($deptSig['signature_path'])) {
                    $path = storage_path('app/public/' . $deptSig['signature_path']);
                    if (file_exists($path)) {
                        $chosenImagePath = $path;
                    }
                }
                if (!$chosenImagePath && !empty($deptSig['approved_by'])) {
                    $approver = \App\Models\User::where('name', $deptSig['approved_by'])->first();
                    if ($approver && $approver->signature_path) {
                        $path = storage_path('app/public/' . $approver->signature_path);
                        if (file_exists($path)) {
                            $chosenImagePath = $path;
                        }
                    }
                }
            }
        }

        // Nếu không có, lấy chữ ký Ban giám đốc
        if (!$chosenImagePath && !empty($registration->digital_signature_director)) {
            $dirSig = json_decode($registration->digital_signature_director, true);
            if (is_array($dirSig)) {
                // Vẫn hiển thị tên Trưởng phòng nếu có, nếu không có thì dùng tên BGĐ
                if (!$displayName) {
                    $displayName = $dirSig['approved_by'] ?? $displayName;
                }
                if (!empty($dirSig['signature_path'])) {
                    $path = storage_path('app/public/' . $dirSig['signature_path']);
                    if (file_exists($path)) {
                        $chosenImagePath = $path;
                    }
                }
                if (!$chosenImagePath && !empty($dirSig['approved_by'])) {
                    $approver = \App\Models\User::where('name', $dirSig['approved_by'])->first();
                    if ($approver && $approver->signature_path) {
                        $path = storage_path('app/public/' . $approver->signature_path);
                        if (file_exists($path)) {
                            $chosenImagePath = $path;
                        }
                    }
                }
            }
        }

        if (!$chosenImagePath) {
            return;
        }

        // Vị trí góc phải dưới - giống như leave PDF
        $pageWidth = 210; // mm
        $rightMargin = 20; // mm
        $imageWidth = 40; // mm
        $imageHeight = 20; // mm
        $x = $pageWidth - $rightMargin - $imageWidth;
        $y = 200; // Dịch xuống dưới

        // Vẽ khung viền cho chữ ký
        $pdf->SetDrawColor(200, 200, 200); // Màu xám nhạt
        $pdf->SetLineWidth(0.3);
        $pdf->Rect($x - 2, $y - 2, $imageWidth + 4, $imageHeight + 15, 'D');

        // Vẽ ảnh chữ ký
        $pdf->Image($chosenImagePath, $x, $y, $imageWidth, $imageHeight, '', '', '', false, 300, '', false, false, 0);

        // Tên hiển thị dưới chữ ký (ưu tiên Trưởng phòng)
        if ($displayName) {
            $pdf->SetFont('dejavusans', 'B', 8);
            $pdf->SetTextColor(0, 0, 0);
            $pdf->SetXY($x - 2, $y + $imageHeight + 2);
            $pdf->Cell($imageWidth + 4, 5, $displayName, 0, 0, 'C');

            // Thêm ngày ký nếu có
            $pdf->SetFont('dejavusans', '', 7);
            $pdf->SetXY($x - 2, $y + $imageHeight + 7);
            $pdf->Cell($imageWidth + 4, 4, now()->format('d/m/Y'), 0, 0, 'C');
        }
    }


    private function addSignatureToVehiclePDF($pdf, $signatureData, $x, $y, $title)
    {

        $pdf->SetXY($x, $y);
        $pdf->SetFont('dejavusans', 'B', 12);
        $pdf->Cell(0, 10, mb_convert_encoding($title, 'UTF-8', 'UTF-8'), 0, 1, 'C');


        if (isset($signatureData['signature_path']) && !empty($signatureData['signature_path'])) {
            $signaturePath = storage_path('app/public/' . $signatureData['signature_path']);

            if (file_exists($signaturePath)) {
                $pdf->Image($signaturePath, $x + 10, $y + 15, 40, 20);
            }
        }


        $approvedBy = htmlspecialchars($signatureData['approved_by'] ?? 'N/A', ENT_QUOTES, 'UTF-8');
        $approvedAt = htmlspecialchars($signatureData['approved_at'] ?? 'N/A', ENT_QUOTES, 'UTF-8');

        $pdf->SetXY($x, $y + 40);
        $pdf->SetFont('dejavusans', '', 10);
        $pdf->Cell(0, 5, 'Người phê duyệt: ' . $approvedBy, 0, 1, 'C');
        $pdf->SetXY($x, $y + 45);
        $pdf->Cell(0, 5, 'Thời gian: ' . $approvedAt, 0, 1, 'C');
    }


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


        $content = mb_convert_encoding($content, 'UTF-8', 'UTF-8');

        return $content;
    }
}
