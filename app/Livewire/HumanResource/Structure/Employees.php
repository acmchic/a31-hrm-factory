<?php

namespace App\Livewire\HumanResource\Structure;

use App\Models\Contract;
use App\Models\Employee;
use App\Models\Department;
use App\Models\Position;
use App\Models\Center;
use App\Models\User;
use Livewire\Component;
use Livewire\WithPagination;
use Livewire\WithFileUploads;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\EmployeesExport;

class Employees extends Component
{
    use WithPagination, WithFileUploads;

    // 👉 Variables
    public $searchTerm = null;

    public $contracts;
    public $departments;
    public $positions;
    public $centers;

    public $employee;

    public $employeeInfo = [];

    public $isEdit = false;

    public $confirmedId;

    // Import/Export
    public $importFile;
    public $showImportModal = false;

    // 👉 Mount
    public function mount()
    {
        $this->contracts = Contract::all();
        $this->departments = Department::all();
        $this->positions = Position::all();
        $this->centers = Center::all();
    }

    // 👉 Render
    public function render()
    {
        $employees = Employee::with(['position', 'department', 'center'])
            ->where(function($query) {
                $query->where('id', 'like', '%'.$this->searchTerm.'%')
                    ->orWhere('name', 'like', '%'.$this->searchTerm.'%')
                    ->orWhere('rank_code', 'like', '%'.$this->searchTerm.'%')
                    ->orWhereHas('department', function($q) {
                        $q->where('name', 'like', '%'.$this->searchTerm.'%');
                    })
                    ->orWhereHas('position', function($q) {
                        $q->where('name', 'like', '%'.$this->searchTerm.'%');
                    });
            })
            ->paginate(20);

        return view('livewire.human-resource.structure.employees', [
            'employees' => $employees,
        ]);
    }

    // 👉 Submit employee
    public function submitEmployee()
    {
        $this->validate([
            'employeeInfo.name' => 'required',
            'employeeInfo.rankCode' => 'required',
            'employeeInfo.positionId' => 'required',
            'employeeInfo.departmentId' => 'required',
            'employeeInfo.centerId' => 'required',
            'employeeInfo.dateOfBirth' => 'required|date',
            'employeeInfo.enlistDate' => 'nullable|date',
            'employeeInfo.CCCD' => 'required',
            'employeeInfo.phone' => 'required',
            'employeeInfo.gender' => 'required',
            'employeeInfo.address' => 'required',
        ]);

        $this->isEdit ? $this->editEmployee() : $this->addEmployee();
    }

    // 👉 Store employee
    public function showCreateEmployeeModal()
    {
        $this->reset('isEdit', 'employeeInfo');
    }

    public function addEmployee()
    {
        $createdEmployee = Employee::create([
            'name' => $this->employeeInfo['name'],
            'rank_code' => $this->employeeInfo['rankCode'],
            'position_id' => $this->employeeInfo['positionId'],
            'department_id' => $this->employeeInfo['departmentId'],
            'center_id' => $this->employeeInfo['centerId'],
            'date_of_birth' => $this->employeeInfo['dateOfBirth'],
            'enlist_date' => $this->employeeInfo['enlistDate'],
            'CCCD' => $this->employeeInfo['CCCD'],
            'phone' => $this->employeeInfo['phone'],
            'gender' => $this->employeeInfo['gender'],
            'address' => $this->employeeInfo['address'],
            'is_active' => true,
            'contract_id' => $this->employeeInfo['contractId'] ?? Contract::first()->id,
        ]);

        $this->dispatch('closeModal', elementId: '#employeeModal');
        $this->dispatch('toastr', type: 'success', message: __('Quân nhân đã được tạo thành công!'));

        return redirect()->route('structure-employees-info', ['id' => $createdEmployee->id]);
    }

    // 👉 Update employee
    public function showEditEmployeeModal(Employee $employee)
    {
        $this->isEdit = true;

        $this->employee = $employee;

        $this->employeeInfo['name'] = $employee->name;
        $this->employeeInfo['rankCode'] = $employee->rank_code;
        $this->employeeInfo['positionId'] = $employee->position_id;
        $this->employeeInfo['departmentId'] = $employee->department_id;
        $this->employeeInfo['centerId'] = $employee->center_id;
        $this->employeeInfo['dateOfBirth'] = $employee->date_of_birth;
        $this->employeeInfo['enlistDate'] = $employee->enlist_date;
        $this->employeeInfo['CCCD'] = $employee->CCCD;
        $this->employeeInfo['phone'] = $employee->phone;
        $this->employeeInfo['gender'] = $employee->gender;
        $this->employeeInfo['address'] = $employee->address;
    }

    public function editEmployee()
    {
        $this->employee->update([
            'name' => $this->employeeInfo['name'],
            'rank_code' => $this->employeeInfo['rankCode'],
            'position_id' => $this->employeeInfo['positionId'],
            'department_id' => $this->employeeInfo['departmentId'],
            'center_id' => $this->employeeInfo['centerId'],
            'date_of_birth' => $this->employeeInfo['dateOfBirth'],
            'enlist_date' => $this->employeeInfo['enlistDate'],
            'CCCD' => $this->employeeInfo['CCCD'],
            'phone' => $this->employeeInfo['phone'],
            'gender' => $this->employeeInfo['gender'],
            'address' => $this->employeeInfo['address'],
        ]);

        $this->dispatch('closeModal', elementId: '#employeeModal');
        $this->dispatch('toastr', type: 'success', message: __('Quân nhân đã được cập nhật thành công!'));
    }

    // 👉 Delete employee
    public function confirmDeleteEmployee($id)
    {
        $this->confirmedId = $id;
    }

    public function deleteEmployee(Employee $employee)
    {
        $employee->delete();
        $this->dispatch('toastr', type: 'success', message: __('Quân nhân đã được xóa thành công!'));
    }

    // 👉 Import/Export methods
    public function importFromJson()
    {
        try {
            // Đọc file JSON
            $jsonPath = storage_path('app/public/troops/quanso.json');
            if (!file_exists($jsonPath)) {
                $this->dispatch('toastr', type: 'error', message: 'Không tìm thấy file quanso.json');
                $this->showImportModal = false;
                $this->dispatch('closeModal', elementId: '#importModal');
                \Log::error('Import error: File quanso.json not found at ' . $jsonPath);
                return;
            }

            $jsonData = file_get_contents($jsonPath);
            $data = json_decode($jsonData, true);
            
            if (!$data) {
                $this->dispatch('toastr', type: 'error', message: 'Không thể đọc file JSON');
                $this->showImportModal = false;
                \Log::error('Import error: Cannot read JSON file at ' . $jsonPath);
                return;
            }
            
            DB::beginTransaction();
            
            // Xóa dữ liệu cũ (chỉ xóa employees và users, giữ lại departments, positions, centers)
            DB::table('employees')->delete();
            DB::table('users')->delete();
            
            // Tạo Center mặc định
            $center = Center::firstOrCreate(
                ['name' => 'Trung tâm Quân sự'],
                [
                    'code' => 'TC', 
                    'description' => 'Trung tâm Quân sự chính',
                    'start_work_hour' => '08:00:00',
                    'end_work_hour' => '17:00:00',
                    'weekends' => ['Thứ 7', 'Chủ nhật'],
                    'is_active' => true,
                    'created_by' => 'System',
                    'updated_by' => 'System'
                ]
            );
            
            // Tạo Contract mặc định nếu chưa có
            $contract = Contract::firstOrCreate(
                ['name' => 'Hợp đồng quân đội'],
                [
                    'description' => 'Hợp đồng mặc định cho quân nhân',
                    'work_rate' => 100,
                    'created_by' => 'System',
                    'updated_by' => 'System'
                ]
            );
            
            // LUÔN LUÔN tạo superadmin trước khi import
            $superAdmin = User::updateOrCreate(
                ['email' => 'admin@demo.com'],
                [
                    'name' => 'Super Admin',
                    'password' => Hash::make('123456'),
                    'email_verified_at' => now(),
                    'created_by' => 'System',
                    'updated_by' => 'System'
                ]
            );
            
            // Gán role Admin cho superadmin
            if (!$superAdmin->hasRole('Admin')) {
                $adminRole = \Spatie\Permission\Models\Role::firstOrCreate(['name' => 'Admin']);
                $superAdmin->assignRole('Admin');
            }
            
            $importedCount = 0;
            
            // Import departments và employees
            foreach ($data['departments'] as $deptData) {
                // Tạo hoặc cập nhật department
                $department = Department::updateOrCreate(
                    ['code' => $deptData['code']],
                    [
                        'name' => $deptData['name'],
                        'center_id' => $center->id,
                        'description' => 'Phòng ban từ dữ liệu quân số',
                        'created_by' => 'System',
                        'updated_by' => 'System'
                    ]
                );
                
                // Xử lý members trực tiếp trong department
                if (isset($deptData['members'])) {
                    foreach ($deptData['members'] as $member) {
                        $this->createEmployeeFromJson($member, $department->id, $center->id, $contract->id);
                        $importedCount++;
                    }
                }
                
                // Xử lý teams trong department
                if (isset($deptData['teams'])) {
                    foreach ($deptData['teams'] as $team) {
                        foreach ($team['members'] as $member) {
                            $this->createEmployeeFromJson($member, $department->id, $center->id, $contract->id);
                            $importedCount++;
                        }
                    }
                }
            }
            
            DB::commit();
            
            $this->dispatch('toastr', type: 'success', message: "Import thành công {$importedCount} quân nhân! Vui lòng refresh trang để xem dữ liệu mới.");
            $this->showImportModal = false;
            $this->dispatch('refresh-page');
            $this->dispatch('closeModal', elementId: '#importModal');
            
        } catch (\Exception $e) {
            DB::rollback();
            $this->dispatch('toastr', type: 'error', message: 'Lỗi import: ' . $e->getMessage());
            $this->showImportModal = false;
            $this->dispatch('closeModal', elementId: '#importModal');
            \Log::error('Import error: ' . $e->getMessage());
            \Log::error('Import error stack trace: ' . $e->getTraceAsString());
        }
    }

    private function createEmployeeFromJson($memberData, $departmentId, $centerId, $contractId)
    {
        // Tạo hoặc cập nhật position
        $position = Position::updateOrCreate(
            ['name' => $memberData['position']],
            [
                'code' => substr($memberData['position'], 0, 10), 
                'description' => $memberData['position'],
                'vacancies_count' => 1,
                'created_by' => 'System',
                'updated_by' => 'System'
            ]
        );
        
        // Tạo hoặc cập nhật user với password mặc định
        $email = $memberData['username'] . '@quandoi.local';
        $counter = 1;
        while (User::where('email', $email)->exists()) {
            $email = $memberData['username'] . '_' . $counter . '@quandoi.local';
            $counter++;
        }
        
        $user = User::updateOrCreate(
            ['email' => $email],
            [
                'name' => $memberData['full_name'],
                'password' => Hash::make('123456'),
                'email_verified_at' => now(),
                'created_by' => 'System',
                'updated_by' => 'System'
            ]
        );
        
        // Tạo hoặc cập nhật employee với cấu trúc mới
        $employee = Employee::updateOrCreate(
            ['user_id' => $user->id],
            [
                'user_id' => $user->id,
                'name' => $memberData['full_name'],
                'date_of_birth' => $this->parseDate($memberData['dob']),
                'enlist_date' => $this->parseDate($memberData['enlist_td']),
                'rank_code' => $memberData['rank_code'],
                'position_id' => $position->id,
                'department_id' => $departmentId,
                'center_id' => $centerId,
                'is_active' => true,
                'CCCD' => $memberData['username'] ?? '', // Sử dụng username hoặc để trống nếu không có
                'phone' => '0' . rand(100000000, 999999999),
                'address' => 'Địa chỉ quân đội',
                'gender' => 1, // 1 = Nam
                'contract_id' => $contractId,
                'start_date' => $this->parseDate($memberData['enlist_td']) ?? now(),
                'quit_date' => null,
                'max_leave_allowed' => 0,
                'delay_counter' => '00:00:00',
                'hourly_counter' => '00:00:00',
                'profile_photo_path' => '',
                'created_by' => 'System',
                'updated_by' => 'System'
            ]
        );
        
        // Gán role dựa trên position (chỉ gán nếu user chưa có role)
        if (!$user->hasRole(['Admin', 'HR', 'AM'])) {
            $this->assignRole($user, $memberData['position']);
        }
        
        return $employee;
    }

    private function assignRole($user, $position)
    {
        $position = strtolower($position);
        
        // Tạo các role cần thiết nếu chưa có
        $adminRole = \Spatie\Permission\Models\Role::firstOrCreate(['name' => 'Admin']);
        $hrRole = \Spatie\Permission\Models\Role::firstOrCreate(['name' => 'HR']);
        $amRole = \Spatie\Permission\Models\Role::firstOrCreate(['name' => 'AM']);
        
        if (strpos($position, 'giám đốc') !== false || strpos($position, 'chính uỷ') !== false) {
            $user->assignRole('Admin');
        } elseif (strpos($position, 'trưởng') !== false || strpos($position, 'đội trưởng') !== false) {
            $user->assignRole('HR');
        } else {
            $user->assignRole('AM');
        }
    }

    private function parseDate($dateString)
    {
        if (!$dateString) return null;
        
        if (strpos($dateString, '/') !== false) {
            $parts = explode('/', $dateString);
            if (count($parts) == 2) {
                $month = str_pad($parts[0], 2, '0', STR_PAD_LEFT);
                $year = '19' . $parts[1];
                return "{$year}-{$month}-01";
            } elseif (count($parts) == 3) {
                $day = str_pad($parts[0], 2, '0', STR_PAD_LEFT);
                $month = str_pad($parts[1], 2, '0', STR_PAD_LEFT);
                $year = strlen($parts[2]) == 2 ? '19' . $parts[2] : $parts[2];
                
                if (checkdate((int)$month, (int)$day, (int)$year)) {
                    return "{$year}-{$month}-{$day}";
                }
            }
        }
        
        return null;
    }

    public function exportToExcel()
    {
        return Excel::download(new EmployeesExport, 'quan-nhan-' . date('Y-m-d') . '.xlsx');
    }
}
