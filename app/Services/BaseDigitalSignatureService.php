<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use LSNepomuceno\LaravelA1PdfSign\Sign\ManageCert;
use TCPDF;

abstract class BaseDigitalSignatureService
{
    public function __construct()
    {
        //
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

    protected function createBasePDF(string $title, string $subject): TCPDF
    {
        $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

        $pdf->SetCreator('Hệ thống A31');
        $pdf->SetAuthor('A31');
        $pdf->SetTitle($title);
        $pdf->SetSubject($subject);

        $pdf->SetMargins(20, 20, 20);
        $pdf->SetAutoPageBreak(TRUE, 25);

        $pdf->AddPage();

        $logoPath = public_path('assets/img/logo/logo.png');
        if (file_exists($logoPath)) {
            $logoWidth = 18;
            $centerX = (210 - $logoWidth) / 2;
            $pdf->Image($logoPath, $centerX, 16, $logoWidth, 0, '', '', '', false, 300, '', false, false, 0);
            $pdf->SetY(32);
        }

        $pdf->SetFont('dejavusans', '', 12);

        return $pdf;
    }

    protected function addVisualSignature(TCPDF $pdf, User $approver, \DateTime $approvedAt)
    {
        if (!$approver || !$approver->signature_path) {
            return;
        }

        $signaturePath = storage_path('app/public/' . $approver->signature_path);
        if (!file_exists($signaturePath)) {
            return;
        }

        $pageWidth = 210;
        $rightMargin = 20;
        $imageWidth = 40;
        $imageHeight = 20;
        $x = $pageWidth - $rightMargin - $imageWidth;
        $y = 200;

        $pdf->SetDrawColor(200, 200, 200);
        $pdf->SetLineWidth(0.3);
        $pdf->Rect($x - 2, $y - 2, $imageWidth + 4, $imageHeight + 15, 'D');

        $pdf->Image($signaturePath, $x, $y, $imageWidth, $imageHeight, '', '', '', false, 300, '', false, false, 0);

        $pdf->SetFont('dejavusans', 'B', 8);
        $pdf->SetTextColor(0, 0, 0);
        $pdf->SetXY($x - 2, $y + $imageHeight + 2);
        $pdf->Cell($imageWidth + 4, 5, $approver->name, 0, 0, 'C');

        $pdf->SetFont('dejavusans', '', 7);
        $pdf->SetXY($x - 2, $y + $imageHeight + 7);
        $pdf->Cell($imageWidth + 4, 4, $approvedAt->format('d/m/Y'), 0, 0, 'C');
    }

    protected function getBaseCSS(): string
{
    return '
    <style>
        body {
            font-family: dejavusans, sans-serif;
            font-size: 11pt;
            color: #333;
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }

        .header {
            text-align: center;
            margin-bottom: 25px;
        }

        .company-name {
            font-size: 14pt;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .document-title {
            font-size: 18pt;
            font-weight: bold;
            color: #0056b3;
            margin-top: 5px;
            border-bottom: 2px solid #0056b3;
            display: inline-block;
            padding-bottom: 3px;
        }

        .info-section {
            background: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 15px 20px;
            margin-bottom: 25px;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 10.5pt;
        }

        .info-table tr {
            border-bottom: 1px solid #f1f3f4;
        }

        .info-table tr:last-child {
            border-bottom: none;
        }

        .info-table td {
            padding: 14px 18px;
            vertical-align: top;
        }

        .label {
            font-weight: bold;
            background-color: #f8f9fa;
            color: #495057;
            width: 30%;
            border-right: 1px solid #dee2e6;
        }

        .value {
            background-color: #ffffff;
            color: #212529;
            width: 70%;
        }
    </style>';
}


    protected function generateDocumentHTML(string $companyName, string $documentTitle, array $tableData): string
    {
        $html = $this->getBaseCSS();

        $html .= '
        <div class="header">
            <div class="company-name">' . $companyName . '</div>
            <div class="document-title">' . $documentTitle . '</div>
        </div>

        <div class="info-section">
            <table class="info-table">';

        foreach ($tableData as $row) {
            $html .= '
                <tr>
                    <td class="label">' . $row['label'] . '</td>
                    <td class="value">' . $row['value'] . '</td>
                </tr>';
        }

        $html .= '
            </table>
        </div>';


        return $html;
    }

    abstract protected function getSignatureReason(): string;
}
