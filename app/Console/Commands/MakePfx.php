<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;

class MakePfx extends Command
{
    protected $signature = 'a1:make-pfx 
                            {--out=storage/certs/a31.pfx : Output path for PFX file}
                            {--pass=A31_CertSign : Passphrase for PFX}
                            {--days=3650 : Certificate validity in days}';

    protected $description = 'Generate self-signed PFX certificate for A1 digital signing';

    public function handle()
    {
        $outputPath = $this->option('out');
        $passphrase = $this->option('pass');
        $days = (int) $this->option('days');

        // Ensure directory exists
        $dir = dirname($outputPath);
        if (!is_dir($dir)) {
            mkdir($dir, 0755, true);
        }

        $this->info('Đang tạo khóa và chứng chỉ tự ký...');

        // Generate private key and certificate
        $keyFile = tempnam(sys_get_temp_dir(), 'key_');
        $certFile = tempnam(sys_get_temp_dir(), 'cert_');
        $pfxFile = tempnam(sys_get_temp_dir(), 'pfx_');

        try {
            // Generate private key
            $keyCmd = "openssl genrsa -out {$keyFile} 2048 2>/dev/null";
            exec($keyCmd, $output, $returnCode);
            
            if ($returnCode !== 0) {
                throw new \Exception('Failed to generate private key');
            }

            // Generate self-signed certificate
            $certCmd = "openssl req -new -x509 -key {$keyFile} -out {$certFile} -days {$days} " .
                      "-subj '/C=VN/ST=HCM/L=HCM/O=A31 Factory/OU=IT/CN=A31 Factory Digital Signing/emailAddress=admin@a31.com' 2>/dev/null";
            exec($certCmd, $output, $returnCode);
            
            if ($returnCode !== 0) {
                throw new \Exception('Failed to generate certificate');
            }

            // Convert to PFX
            $pfxCmd = "openssl pkcs12 -export -out {$pfxFile} -inkey {$keyFile} -in {$certFile} -passout pass:{$passphrase} 2>/dev/null";
            exec($pfxCmd, $output, $returnCode);
            
            if ($returnCode !== 0) {
                throw new \Exception('Failed to create PFX');
            }

            // Copy to final location
            if (!copy($pfxFile, $outputPath)) {
                throw new \Exception('Failed to save PFX to final location');
            }

            $this->info("Đã tạo file PFX: " . realpath($outputPath));
            $this->info("Hoàn tất. Cập nhật .env nếu cần:");
            $this->line("PDF_CERT_PATH={$outputPath}");
            $this->line("PDF_CERT_PASS=\"{$passphrase}\"");

        } finally {
            // Cleanup temp files
            @unlink($keyFile);
            @unlink($certFile);
            @unlink($pfxFile);
        }
    }
}
