<?php

namespace App\Exports;

use App\Models\Employee;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;

class EmployeesExport implements FromCollection, WithHeadings, WithMapping
{
    /**
     * @return \Illuminate\Support\Collection
     */
    public function collection()
    {
        return Employee::with(['user', 'position', 'department', 'center'])->get();
    }

    /**
     * @return array
     */
    public function headings(): array
    {
        return [
            'Mã số',
            'Họ và tên',
            'Cấp bậc',
            'Chức vụ',
            'Đơn vị',
            'Trung tâm',
            'Ngày sinh',
            'Ngày nhập ngũ',
            'Số CCCD',
            'Số điện thoại',
            'Giới tính',
            'Địa chỉ',
            'Trạng thái',
            'Ngày bắt đầu',
            'Ngày kết thúc'
        ];
    }

    /**
     * @param mixed $employee
     * @return array
     */
    public function map($employee): array
    {
        return [
            $employee->id,
            $employee->name,
            $employee->rank_code,
            $employee->position ? $employee->position->name : '-',
            $employee->department ? $employee->department->name : '-',
            $employee->center ? $employee->center->name : '-',
            $employee->date_of_birth ? $employee->date_of_birth->format('d/m/Y') : '-',
            $employee->enlist_date ? $employee->enlist_date->format('d/m/Y') : '-',
            $employee->CCCD ?: '-',
            $employee->phone ?: '-',
            $employee->gender == 1 ? 'Nam' : 'Nữ',
            $employee->address ?: '-',
            $employee->is_active ? 'Hoạt động' : 'Không hoạt động',
            $employee->start_date ? $employee->start_date->format('d/m/Y') : '-',
            $employee->quit_date ? $employee->quit_date->format('d/m/Y') : '-',
        ];
    }
}
