<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\DigitalSignatureService;

class CheckA1Setup extends Command
{
    protected $signature = 'a1:check';
    protected $description = 'Check A1 PDF signing setup';

    public function handle()
    {
        $this->info('Kiểm tra cấu hình A1 PDF Signing...');

        // Check environment variables
        $certPath = env('PDF_CERT_PATH');
        $certPass = env('PDF_CERT_PASS');

        if (!$certPath) {
            $this->error('PDF_CERT_PATH không được cấu hình trong .env');
            return 1;
        }

        if (!$certPass) {
            $this->error('PDF_CERT_PASS không được cấu hình trong .env');
            return 1;
        }

        $this->info("✓ PDF_CERT_PATH: {$certPath}");
        $this->info("✓ PDF_CERT_PASS: " . str_repeat('*', strlen($certPass)));

        // Check certificate file
        if (!file_exists($certPath)) {
            $this->error("✗ Certificate file không tồn tại: {$certPath}");
            $this->info("Chạy: php artisan a1:make-pfx để tạo certificate");
            return 1;
        }

        $this->info("✓ Certificate file tồn tại");

        // Test certificate reading
        try {
            $service = new DigitalSignatureService();
            $cert = $service->readCertificateFromFile();
            $this->info("✓ Certificate đọc thành công");
        } catch (\Exception $e) {
            $this->error("✗ Lỗi đọc certificate: " . $e->getMessage());
            return 1;
        }

        $this->info("✓ A1 setup hoàn tất!");
        return 0;
    }
}
