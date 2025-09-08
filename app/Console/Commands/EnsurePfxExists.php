<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\DigitalSignatureService;

class EnsurePfxExists extends Command
{
    protected $signature = 'a1:ensure-pfx';
    protected $description = 'Ensure PFX certificate exists, create if not';

    public function handle()
    {
        $this->info('Checking PFX certificate...');

        try {
            $service = new DigitalSignatureService();
            $service->ensurePfxExists();
            
            $certPath = env('PDF_CERT_PATH', 'storage/certs/a31.pfx');
            $fullPath = file_exists($certPath) ? $certPath : base_path($certPath);
            
            if (file_exists($fullPath)) {
                $this->info("✓ PFX certificate exists: {$fullPath}");
                $this->info("✓ File size: " . number_format(filesize($fullPath)) . " bytes");
            } else {
                $this->error("✗ PFX certificate still not found after creation attempt");
                return 1;
            }

        } catch (\Exception $e) {
            $this->error("Error: " . $e->getMessage());
            return 1;
        }

        return 0;
    }
}
