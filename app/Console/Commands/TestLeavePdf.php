<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\EmployeeLeave;
use App\Services\DigitalSignatureService;

class TestLeavePdf extends Command
{
    protected $signature = 'test:leave-pdf {id?}';
    protected $description = 'Test leave request PDF generation and signing';

    public function handle()
    {
        $leaveId = $this->argument('id') ?: 1;
        
        $this->info("Testing leave request PDF for ID: {$leaveId}");

        try {
            $leaveRequest = EmployeeLeave::with(['leave', 'employee'])->find($leaveId);
            
            if (!$leaveRequest) {
                $this->error("Leave request not found with ID: {$leaveId}");
                return 1;
            }

            $this->info("Found leave request:");
            $this->line("- ID: {$leaveRequest->id}");
            $this->line("- Employee: " . ($leaveRequest->employee->name ?? 'N/A'));
            $this->line("- Leave type: " . ($leaveRequest->leave->name ?? 'N/A'));
            $this->line("- Status: {$leaveRequest->status}");
            $this->line("- From: {$leaveRequest->from_date}");
            $this->line("- To: {$leaveRequest->to_date}");

            $digitalSignatureService = new DigitalSignatureService();
            
            $this->info("Generating PDF...");
            $pdfBinary = $digitalSignatureService->generateLeaveRequestPDF($leaveRequest);
            
            $this->info("Signing PDF...");
            $signedPdfBinary = $digitalSignatureService->signPdfBinary($pdfBinary);
            
            $this->info("Storing signed PDF...");
            $signedPdfPath = $digitalSignatureService->storeSignedPdf($signedPdfBinary, 'signed/leaves/test_leave_' . $leaveId . '_signed.pdf');
            
            $this->info("✓ PDF generated and signed successfully!");
            $this->line("File saved: storage/app/{$signedPdfPath}");
            $this->line("Open with Adobe Acrobat/Reader to check signature panel");

        } catch (\Exception $e) {
            $this->error("Error: " . $e->getMessage());
            return 1;
        }

        return 0;
    }
}
