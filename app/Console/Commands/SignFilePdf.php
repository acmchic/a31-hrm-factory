<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\DigitalSignatureService;

class SignFilePdf extends Command
{
    protected $signature = 'a1:sign-file {input} {--out=}';
    protected $description = 'Sign an existing PDF file';

    public function handle()
    {
        $inputFile = $this->argument('input');
        $outputFile = $this->option('out');

        if (!file_exists($inputFile)) {
            $this->error("File không tồn tại: {$inputFile}");
            return 1;
        }

        if (!$outputFile) {
            $pathInfo = pathinfo($inputFile);
            $outputFile = $pathInfo['dirname'] . '/' . $pathInfo['filename'] . '_signed.' . $pathInfo['extension'];
        }

        $this->info("Đang ký file: {$inputFile}");
        $this->info("Output: {$outputFile}");

        try {
            $service = new DigitalSignatureService();
            
            // Read input PDF
            $pdfContent = file_get_contents($inputFile);
            
            // Sign the PDF
            $signedPdf = $service->signPdfBinary($pdfContent);

            // Save signed PDF
            file_put_contents($outputFile, $signedPdf);

            $this->info("✓ Đã ký thành công: {$outputFile}");
            $this->info("Mở file bằng Adobe Acrobat/Reader để kiểm tra signature panel");

        } catch (\Exception $e) {
            $this->error("Lỗi: " . $e->getMessage());
            return 1;
        }

        return 0;
    }
}
