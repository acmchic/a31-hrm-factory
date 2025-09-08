<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\VehicleRegistration;
use App\Services\DigitalSignatureService;

class TestVehiclePdf extends Command
{
    protected $signature = 'test:vehicle-pdf {id?}';
    protected $description = 'Test vehicle registration PDF generation with digital signature';

    public function handle()
    {
        $registrationId = $this->argument('id') ?: 1;
        
        $this->info("Testing vehicle registration PDF for ID: {$registrationId}");

        try {
            $registration = VehicleRegistration::with(['vehicle', 'user'])->find($registrationId);
            
            if (!$registration) {
                $this->error("Vehicle registration not found with ID: {$registrationId}");
                return 1;
            }

            $this->info("Found registration:");
            $this->line("- ID: {$registration->id}");
            $this->line("- User: {$registration->user->name}");
            $this->line("- Vehicle: {$registration->vehicle->full_name}");
            $this->line("- Status: {$registration->workflow_status}");

            $service = new DigitalSignatureService();
            
            // Generate unsigned PDF
            $this->info("Generating PDF...");
            $pdfContent = $service->generateVehicleRegistrationPDF($registration, true);
            
            // Sign the PDF
            $this->info("Signing PDF...");
            $signedPdf = $service->signPdfBinary($pdfContent);
            
            // Save signed PDF
            $outputPath = 'signed/vehicles/test_vehicle_' . $registrationId . '_signed.pdf';
            $service->storeSignedPdf($signedPdf, $outputPath);
            
            $this->info("✓ PDF generated and signed successfully!");
            $this->info("File saved: storage/app/{$outputPath}");
            $this->info("Open with Adobe Acrobat/Reader to check signature panel");

        } catch (\Exception $e) {
            $this->error("Error: " . $e->getMessage());
            return 1;
        }

        return 0;
    }
}
