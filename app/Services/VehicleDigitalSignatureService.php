<?php

namespace App\Services;

use App\Models\User;
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

        $tableData = [
            ['label' => 'Người đăng ký', 'value' => $user->name ?? 'N/A'],
            ['label' => 'Đơn vị', 'value' => 'Phòng Kế hoạch'],
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
        $chosenUser = null;
        $displayName = null;

        if (!empty($registration->digital_signature_dept)) {
            $deptSig = json_decode($registration->digital_signature_dept, true);
            if (is_array($deptSig)) {
                $displayName = $deptSig['approved_by'] ?? $displayName;
                if (!empty($deptSig['approved_by'])) {
                    $chosenUser = User::where('name', $deptSig['approved_by'])->first();
                }
            }
        }

        if (!$chosenUser && !empty($registration->digital_signature_director)) {
            $dirSig = json_decode($registration->digital_signature_director, true);
            if (is_array($dirSig)) {
                if (!$displayName) {
                    $displayName = $dirSig['approved_by'] ?? $displayName;
                }
                if (!empty($dirSig['approved_by'])) {
                    $chosenUser = User::where('name', $dirSig['approved_by'])->first();
                }
            }
        }

        if ($chosenUser) {
            $this->addVisualSignature($pdf, $chosenUser, now());
        }
    }

    protected function getSignatureReason(): string
    {
        return 'Ký số tài liệu đăng ký xe công';
    }
}
