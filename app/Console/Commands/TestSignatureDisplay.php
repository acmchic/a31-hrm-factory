<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\VehicleRegistration;
use App\Models\User;
use App\Services\DigitalSignatureService;

class TestSignatureDisplay extends Command
{
    protected $signature = 'test:signature-display {id?}';
    protected $description = 'Test signature display in PDF';

    public function handle()
    {
        $registrationId = $this->argument('id') ?: 5;
        
        $this->info("Testing signature display for vehicle registration ID: {$registrationId}");

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

            // Check department signature
            if ($registration->digital_signature_dept) {
                $deptSignature = json_decode($registration->digital_signature_dept, true);
                $this->info("Department signature data:");
                $this->line("- Approved by: " . ($deptSignature['approved_by'] ?? 'N/A'));
                $this->line("- Signature path: " . ($deptSignature['signature_path'] ?? 'NULL'));
                
                // Check if signature file exists
                if (isset($deptSignature['signature_path']) && !empty($deptSignature['signature_path'])) {
                    $signaturePath = storage_path('app/public/' . $deptSignature['signature_path']);
                    $this->line("- File exists: " . (file_exists($signaturePath) ? 'YES' : 'NO'));
                }
                
                // Check user signature
                $approver = User::where('name', $deptSignature['approved_by'])->first();
                if ($approver) {
                    $this->line("- User ID: {$approver->id}");
                    $this->line("- User signature path: " . ($approver->signature_path ?? 'NULL'));
                    if ($approver->signature_path) {
                        $userSignaturePath = storage_path('app/public/' . $approver->signature_path);
                        $this->line("- User signature file exists: " . (file_exists($userSignaturePath) ? 'YES' : 'NO'));
                    }
                }
            } else {
                $this->warn("No department signature data found");
            }

            // Check director signature
            if ($registration->digital_signature_director) {
                $directorSignature = json_decode($registration->digital_signature_director, true);
                $this->info("Director signature data:");
                $this->line("- Approved by: " . ($directorSignature['approved_by'] ?? 'N/A'));
                $this->line("- Signature path: " . ($directorSignature['signature_path'] ?? 'NULL'));
                
                // Check user signature
                $approver = User::where('name', $directorSignature['approved_by'])->first();
                if ($approver) {
                    $this->line("- User ID: {$approver->id}");
                    $this->line("- User signature path: " . ($approver->signature_path ?? 'NULL'));
                    if ($approver->signature_path) {
                        $userSignaturePath = storage_path('app/public/' . $approver->signature_path);
                        $this->line("- User signature file exists: " . (file_exists($userSignaturePath) ? 'YES' : 'NO'));
                    }
                }
            } else {
                $this->warn("No director signature data found");
            }

            $this->info("✓ Signature display test completed");

        } catch (\Exception $e) {
            $this->error("Error: " . $e->getMessage());
            return 1;
        }

        return 0;
    }
}
