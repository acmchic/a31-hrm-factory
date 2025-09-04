<?php

namespace App\Imports;

use App\Models\Vehicle;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class VehiclesImport implements ToCollection, WithHeadingRow
{
    /**
    * @param Collection $collection
    */
    public function collection(Collection $collection)
    {
        foreach ($collection as $row) {
            // Skip empty rows
            if (empty($row['ten_xe']) && empty($row['name'])) {
                continue;
            }

            Vehicle::create([
                'name' => $row['ten_xe'] ?? $row['name'] ?? '',
                'category' => $row['danh_muc'] ?? $row['category'] ?? 'Xe công',
                'license_plate' => $row['bien_so'] ?? $row['license_plate'] ?? '',
                'brand' => $row['hang_xe'] ?? $row['brand'] ?? '',
                'model' => $row['dong_xe'] ?? $row['model'] ?? '',
                'year' => $row['nam_san_xuat'] ?? $row['year'] ?? null,
                'color' => $row['mau_sac'] ?? $row['color'] ?? '',
                'fuel_type' => $row['loai_nhien_lieu'] ?? $row['fuel_type'] ?? 'Xăng',
                'capacity' => $row['so_cho_ngoi'] ?? $row['capacity'] ?? 5,
                'status' => 'available',
                'description' => $row['mo_ta'] ?? $row['description'] ?? '',
                'is_active' => true,
                'created_by' => 'System Import',
            ]);
        }
    }
}
