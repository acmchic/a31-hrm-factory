<?php

namespace App\Http\Controllers;

use App\Models\EmployeeLeave;
use App\Models\User;
use App\Services\LeaveDigitalSignatureService;
use App\Services\VehicleDigitalSignatureService;
use Illuminate\Http\Request;

class PdfDownloadController extends Controller
{
    private $leaveService;
    private $vehicleService;

    public function __construct(LeaveDigitalSignatureService $leaveService, VehicleDigitalSignatureService $vehicleService)
    {
        $this->leaveService = $leaveService;
        $this->vehicleService = $vehicleService;
    }

    public function downloadLeave($id)
    {
        $employeeLeave = EmployeeLeave::findOrFail($id);

        if (!$employeeLeave->signed_pdf_path && !$employeeLeave->digital_signature && !$employeeLeave->template_pdf_path) {
            abort(404, 'Tài liệu không tồn tại');
        }

        try {
            // Always generate fresh PDF with new template
            $pdfBinary = $this->leaveService->generateLeaveRequestPDF($employeeLeave);
            $signedPdfBinary = $this->leaveService->signPdfBinary($pdfBinary);
            $signedPdfPath = $this->leaveService->storeSignedPdf($signedPdfBinary, 'signed/leaves/leave_' . $employeeLeave->id . '_signed.pdf');
            
            // Update the record with signed PDF path
            $employeeLeave->update(['signed_pdf_path' => $signedPdfPath]);

            $user = User::find($employeeLeave->employee_id);
            $filename = 'Đơn xin nghỉ phép - ' . ($user->name ?? 'Unknown') . '_signed.pdf';

            return response($signedPdfBinary)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="' . $filename . '"')
                ->header('Content-Security-Policy', 'default-src \'self\' \'unsafe-inline\' data:')
                ->header('X-Content-Type-Options', 'nosniff');

        } catch (\Exception $e) {
            abort(500, 'Lỗi tạo PDF: ' . $e->getMessage());
        }
    }

    public function downloadVehicle($id)
    {
        $registration = \App\Models\VehicleRegistration::with(['vehicle', 'user'])->find($id);
        
        if (!$registration) {
            abort(404, 'Không tìm thấy đăng ký xe.');
        }

        try {
            $vehicleService = new \App\Services\VehicleDigitalSignatureService();
            $pdfBinary = $vehicleService->generateVehicleRegistrationPDF($registration);
            $signedPdfBinary = $vehicleService->signPdfBinary($pdfBinary);
            
            $filename = 'Đăng ký xe - ' . ($registration->user->name ?? 'Unknown') . '_signed.pdf';

            return response($signedPdfBinary)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'inline; filename="' . $filename . '"')
                ->header('Content-Security-Policy', 'default-src \'self\' \'unsafe-inline\' data:')
                ->header('X-Content-Type-Options', 'nosniff');

        } catch (\Exception $e) {
            abort(500, 'Lỗi tạo PDF: ' . $e->getMessage());
        }
    }

    public function downloadTempFile(Request $request)
    {
        $filename = $request->query('filename');
        
        if (!$filename) {
            abort(404, 'File not found');
        }

        $filePath = storage_path('app/temp/' . $filename);
        
        if (!file_exists($filePath)) {
            abort(404, 'File not found');
        }

        return response()->download($filePath, $filename)->deleteFileAfterSend(true);
    }
}
