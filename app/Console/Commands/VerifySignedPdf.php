<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class VerifySignedPdf extends Command
{
    protected $signature = 'a1:verify {file}';
    protected $description = 'Verify digital signature in PDF file';

    public function handle()
    {
        $file = $this->argument('file');

        if (!file_exists($file)) {
            $this->error("File không tồn tại: {$file}");
            return 1;
        }

        $this->info("Kiểm tra chữ ký số trong file: {$file}");

        try {
            // Use OpenSSL to verify signature
            $cmd = "openssl smime -verify -in {$file} -inform DER -noverify 2>&1";
            exec($cmd, $output, $returnCode);

            if ($returnCode === 0) {
                $this->info("✓ Chữ ký số hợp lệ");
                $this->info("Thông tin chữ ký:");
                foreach ($output as $line) {
                    if (trim($line)) {
                        $this->line("  " . $line);
                    }
                }
            } else {
                $this->warn("⚠ Không thể xác thực chữ ký bằng OpenSSL");
                $this->info("Lý do có thể:");
                $this->line("  - File không có chữ ký số");
                $this->line("  - Chữ ký không hợp lệ");
                $this->line("  - Certificate không được tin tưởng");
                $this->info("");
                $this->info("Khuyến nghị: Mở file bằng Adobe Acrobat/Reader để kiểm tra chính xác");
            }

        } catch (\Exception $e) {
            $this->error("Lỗi xác thực: " . $e->getMessage());
            return 1;
        }

        return 0;
    }
}
