<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\DigitalSignatureService;
use Illuminate\Support\Facades\Storage;

class SignDemoPdf extends Command
{
    protected $signature = 'a1:sign-demo';
    protected $description = 'Sign a demo PDF to test A1 setup';

    public function handle()
    {
        $this->info('Tạo và ký PDF mẫu...');

        try {
            $service = new DigitalSignatureService();
            
            // Create demo content
            $demoContent = "
                <h1>Demo PDF - A1 Digital Signature Test</h1>
                <p>Ngày tạo: " . now()->format('d/m/Y H:i:s') . "</p>
                <p>Đây là file PDF mẫu để test chữ ký số A1.</p>
                <p>Nếu bạn thấy signature panel trong Adobe Acrobat/Reader, setup đã thành công!</p>
            ";

            // Generate unsigned PDF
            $pdf = new \TCPDF();
            $pdf->SetCreator('A31 Factory HRMS');
            $pdf->SetAuthor('A31 Factory');
            $pdf->SetTitle('Demo PDF - A1 Signature Test');
            $pdf->SetSubject('Digital Signature Test');
            $pdf->SetKeywords('A1, Digital Signature, Test');
            
            $pdf->AddPage();
            $pdf->writeHTML($demoContent, true, false, true, false, '');
            
            $unsignedPdf = $pdf->Output('', 'S');

            // Sign the PDF
            $signedPdf = $service->signPdfBinary($unsignedPdf);

            // Save signed PDF
            $outputPath = 'signed/demo_signed.pdf';
            $service->storeSignedPdf($signedPdf, $outputPath);

            $this->info("Đã ký số PDF mẫu: storage/app/{$outputPath}");
            $this->info("Mở file bằng Adobe Acrobat/Reader để kiểm tra signature panel");

        } catch (\Exception $e) {
            $this->error("Lỗi: " . $e->getMessage());
            return 1;
        }

        return 0;
    }
}
