<?php

namespace App\Services;

use App\Models\User;
use App\Models\Employee;
use Illuminate\Support\Facades\Log;

class VehicleDigitalSignatureService extends BaseDigitalSignatureService
{
    public function generateVehicleRegistrationPDF($registration)
    {
        try {
            $pdf = $this->createBasePDF(
                'Đăng ký xe công - ' . $registration->id,
                'Đăng ký xe công'
            );

            $html = $this->generateVehicleRegistrationHTML($registration);
            $pdf->writeHTML($html, true, false, true, false, '');

            $this->addVehicleVisualSignature($pdf, $registration);

            return $pdf->Output('', 'S');

        } catch (\Exception $e) {
            Log::error('Error generating vehicle registration PDF: ' . $e->getMessage());
            throw $e;
        }
    }

    private function generateVehicleRegistrationHTML($registration)
    {
        $user = $registration->user;
        $vehicle = $registration->vehicle;
        
        // Lấy thông tin employee để có phòng ban, chức vụ, cấp bậc
        $employee = Employee::where('user_id', $user->id)->first();
        if (!$employee && $user->name) {
            $employee = Employee::where('name', $user->name)->first();
        }

        $tableData = [
            ['label' => 'Người đăng ký', 'value' => $user->name ?? 'N/A'],
            ['label' => 'Username', 'value' => $user->username ?? 'N/A'],
            ['label' => 'Phòng ban', 'value' => $employee?->department?->name ?? 'N/A'],
            ['label' => 'Chức vụ', 'value' => $employee?->position?->name ?? 'N/A'],
            ['label' => 'Cấp bậc', 'value' => $employee?->rank_code ?? 'N/A'],
            ['label' => 'Xe đăng ký', 'value' => $vehicle->full_name ?? 'N/A'],
            ['label' => 'Lái xe', 'value' => $registration->driver_name ?? 'N/A'],
            ['label' => 'Thời gian sử dụng', 'value' => 'Từ ngày: ' . \Carbon\Carbon::parse($registration->departure_date)->format('d/m/Y') . '<br>Đến ngày: ' . \Carbon\Carbon::parse($registration->return_date)->format('d/m/Y')],
            ['label' => 'Tuyến đường', 'value' => $registration->route ?? 'N/A'],
            ['label' => 'Mục đích sử dụng', 'value' => $registration->purpose ?? 'N/A'],
            ['label' => 'Ngày tạo đơn', 'value' => \Carbon\Carbon::parse($registration->created_at)->format('d/m/Y H:i')]
        ];

        return $this->generateDocumentHTML(
            'NHÀ MÁY A31 - QUÂN CHỦNG PK-KQ',
            'ĐƠN ĐĂNG KÝ SỬ DỤNG XE',
            $tableData
        );
    }

    private function addVehicleVisualSignature($pdf, $registration)
    {
        $signatures = [];

        // Thu thập chữ ký Trưởng phòng
        if (!empty($registration->digital_signature_dept)) {
            $deptSig = json_decode($registration->digital_signature_dept, true);
            if (is_array($deptSig) && !empty($deptSig['approved_by'])) {
                $deptUser = User::where('name', $deptSig['approved_by'])->first();
                // Thêm signature ngay cả khi chưa có signature_path
                if ($deptUser) {
                    $signatures[] = [
                        'user' => $deptUser,
                        'position' => 'Trưởng phòng Kế hoạch',
                        'approved_at' => \Carbon\Carbon::parse($deptSig['approved_at']),
                        'type' => 'dept',
                        'has_image' => !empty($deptUser->signature_path)
                    ];
                }
            }
        }

        // Thu thập chữ ký Thủ trưởng
        if (!empty($registration->digital_signature_director)) {
            $dirSig = json_decode($registration->digital_signature_director, true);
            if (is_array($dirSig) && !empty($dirSig['approved_by'])) {
                $dirUser = User::where('name', $dirSig['approved_by'])->first();
                // Thêm signature ngay cả khi chưa có signature_path (sẽ hiển thị text thay vì ảnh)
                if ($dirUser) {
                    $signatures[] = [
                        'user' => $dirUser,
                        'position' => 'Ban Giám đốc', 
                        'approved_at' => \Carbon\Carbon::parse($dirSig['approved_at']),
                        'type' => 'director',
                        'has_image' => !empty($dirUser->signature_path)
                    ];
                }
            }
        }

        // Hiển thị tất cả chữ ký
        $this->addMultipleSignaturesToPDF($pdf, $signatures);
    }

    private function addMultipleSignaturesToPDF($pdf, $signatures)
    {
        if (empty($signatures)) {
            return;
        }

        $pageWidth = 210;
        $signatureWidth = 42;
        $signatureHeight = 20;
        $spacing = 8;

        // Tính toán vị trí cho các chữ ký
        if (count($signatures) == 1) {
            // 1 chữ ký: góc phải dưới
            $positions = [
                ['x' => $pageWidth - 20 - $signatureWidth, 'y' => 200]
            ];
        } else {
            // 2 chữ ký: cạnh nhau ở dưới
            $totalWidth = (2 * $signatureWidth) + $spacing;
            $startX = $pageWidth - 20 - $totalWidth;
            $positions = [
                ['x' => $startX, 'y' => 200], // Trưởng phòng (trái)
                ['x' => $startX + $signatureWidth + $spacing, 'y' => 200] // Thủ trưởng (phải)
            ];
        }

        // Vẽ từng chữ ký
        foreach ($signatures as $index => $sig) {
            if (isset($positions[$index])) {
                $this->drawSingleSignature(
                    $pdf, 
                    $sig['user'], 
                    $sig['approved_at'], 
                    $sig['position'],
                    $positions[$index]['x'], 
                    $positions[$index]['y'],
                    $signatureWidth,
                    $signatureHeight
                );
            }
        }
    }

    private function drawSingleSignature($pdf, $user, $approvedAt, $position, $x, $y, $width, $height)
    {
        // 1. Chức vụ (ở trên cùng)
        $pdf->SetFont('dejavusans', 'B', 7);
        $pdf->SetTextColor(0, 0, 0);
        $pdf->SetXY($x - 2, $y - 8);
        $pdf->Cell($width + 4, 5, $position, 0, 0, 'C');

        // 2. Ảnh chữ ký hoặc placeholder (ở giữa)
        if ($user->signature_path) {
            $signaturePath = storage_path('app/public/' . $user->signature_path);
            if (file_exists($signaturePath)) {
                $pdf->Image($signaturePath, $x, $y, $width, $height, '', '', '', false, 300, '', false, false, 0);
            } else {
                // Vẽ khung placeholder nếu file không tồn tại
                $this->drawSignaturePlaceholder($pdf, $x, $y, $width, $height);
            }
        } else {
            // Vẽ khung placeholder nếu chưa upload chữ ký
            $this->drawSignaturePlaceholder($pdf, $x, $y, $width, $height);
        }

        // 3. Họ và tên (dưới ảnh)
        $pdf->SetFont('dejavusans', 'B', 7);
        $pdf->SetTextColor(0, 0, 0);
        $pdf->SetXY($x - 2, $y + $height + 2);
        $pdf->Cell($width + 4, 5, $user->name, 0, 0, 'C');
    }

    private function drawSignaturePlaceholder($pdf, $x, $y, $width, $height)
    {
        // Vẽ khung đứt nét
        $pdf->SetDrawColor(150, 150, 150);
        $pdf->SetLineWidth(0.3);
        $pdf->Rect($x, $y, $width, $height, 'D');
        
        // Text "Đã duyệt"
        $pdf->SetFont('dejavusans', 'I', 8);
        $pdf->SetTextColor(100, 100, 100);
        $pdf->SetXY($x, $y + ($height/2) - 2);
        $pdf->Cell($width, 4, 'Đã duyệt', 0, 0, 'C');
    }

    protected function getSignatureReason(): string
    {
        return 'Ký số tài liệu đăng ký xe công';
    }
}
