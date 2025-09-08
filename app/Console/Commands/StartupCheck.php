<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\DigitalSignatureService;

class StartupCheck extends Command
{
    protected $signature = 'app:startup-check';
    protected $description = 'Check system startup requirements and fix issues';

    public function handle()
    {
        $this->info('🔍 Checking system startup requirements...');
        
        $allGood = true;

        // Check PFX certificate
        $this->info('1. Checking PFX certificate...');
        try {
            $service = new DigitalSignatureService();
            $service->ensurePfxExists();
            
            $certPath = env('PDF_CERT_PATH', 'storage/certs/a31.pfx');
            $fullPath = file_exists($certPath) ? $certPath : base_path($certPath);
            
            if (file_exists($fullPath)) {
                $this->info("   ✓ PFX certificate exists: {$fullPath}");
            } else {
                $this->error("   ✗ PFX certificate not found");
                $allGood = false;
            }
        } catch (\Exception $e) {
            $this->error("   ✗ PFX certificate error: " . $e->getMessage());
            $allGood = false;
        }

        // Check storage directories
        $this->info('2. Checking storage directories...');
        $dirs = [
            'storage/app/signed',
            'storage/app/signed/leaves',
            'storage/app/signed/vehicles',
            'storage/certs',
            'storage/app/temp'
        ];
        
        foreach ($dirs as $dir) {
            $fullPath = storage_path($dir);
            if (!is_dir($fullPath)) {
                mkdir($fullPath, 0755, true);
                $this->info("   ✓ Created directory: {$dir}");
            } else {
                $this->info("   ✓ Directory exists: {$dir}");
            }
        }

        // Check storage link
        $this->info('3. Checking storage link...');
        if (!file_exists(public_path('storage'))) {
            $this->call('storage:link');
            $this->info("   ✓ Created storage link");
        } else {
            $this->info("   ✓ Storage link exists");
        }

        // Test digital signature
        $this->info('4. Testing digital signature...');
        try {
            $service = new DigitalSignatureService();
            // Create a simple test PDF
            $pdf = new \TCPDF();
            $pdf->AddPage();
            $pdf->writeHTML('<h1>Test PDF</h1>');
            $testPdfContent = $pdf->Output('', 'S');
            
            $testPdf = $service->signPdfBinary($testPdfContent);
            $this->info("   ✓ Digital signature test passed");
        } catch (\Exception $e) {
            $this->error("   ✗ Digital signature test failed: " . $e->getMessage());
            $allGood = false;
        }

        if ($allGood) {
            $this->info('🎉 All startup checks passed! System is ready.');
            return 0;
        } else {
            $this->error('❌ Some startup checks failed. Please fix the issues above.');
            return 1;
        }
    }
}
