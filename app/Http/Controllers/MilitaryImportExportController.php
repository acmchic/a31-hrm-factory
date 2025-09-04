<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\Department;
use App\Models\Employee;
use App\Models\User;
use App\Models\Position;
use App\Models\Center;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\EmployeesExport;
use App\Imports\EmployeesImport;

class MilitaryImportExportController extends Controller
{
    /**
     * Import dữ liệu từ file Excel
     */
    public function importExcel(Request $request)
    {
        $request->validate([
            'file' => 'required|mimes:xlsx,xls',
        ]);

        try {
            DB::beginTransaction();

            Excel::import(new EmployeesImport, $request->file('file'));

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Import dữ liệu quân nhân thành công!'
            ]);

        } catch (\Exception $e) {
            DB::rollback();
            
            return response()->json([
                'success' => false,
                'message' => 'Lỗi import: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Import dữ liệu từ file JSON quân số
     */
    public function importFromJson(Request $request)
    {
        try {
            DB::beginTransaction();

            // Đọc file JSON
            $jsonPath = storage_path('app/public/troops/quanso.json');
            if (!file_exists($jsonPath)) {
                throw new Exception('Không tìm thấy file quanso.json');
            }

            $jsonData = file_get_contents($jsonPath);
            $data = json_decode($jsonData, true);
            
            if (!$data) {
                throw new Exception('Không thể đọc file JSON');
            }
            
            // Xóa dữ liệu cũ
            DB::table('employees')->delete();
            DB::table('departments')->delete();
            DB::table('positions')->delete();
            DB::table('users')->delete();
            
            // Tạo Center mặc định
            $center = Center::firstOrCreate(
                ['name' => 'Trung tâm Quân sự'],
                ['code' => 'TC', 'description' => 'Trung tâm Quân sự chính']
            );
            
            $importedCount = 0;
            
            // Import departments và employees
            foreach ($data['departments'] as $deptData) {
                // Tạo department
                $department = Department::create([
                    'name' => $deptData['name'],
                    'code' => $deptData['code'],
                    'center_id' => $center->id,
                    'description' => 'Phòng ban từ dữ liệu quân số'
                ]);
                
                // Xử lý members trực tiếp trong department
                if (isset($deptData['members'])) {
                    foreach ($deptData['members'] as $member) {
                        $this->createEmployee($member, $department->id, $center->id);
                        $importedCount++;
                    }
                }
                
                // Xử lý teams trong department
                if (isset($deptData['teams'])) {
                    foreach ($deptData['teams'] as $team) {
                        foreach ($team['members'] as $member) {
                            $this->createEmployee($member, $department->id, $center->id);
                            $importedCount++;
                        }
                    }
                }
            }
            
            DB::commit();

            return response()->json([
                'success' => true,
                'message' => "Import thành công {$importedCount} quân nhân!",
                'count' => $importedCount
            ]);

        } catch (\Exception $e) {
            DB::rollback();
            
            return response()->json([
                'success' => false,
                'message' => 'Lỗi import: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Export dữ liệu ra Excel
     */
    public function exportExcel()
    {
        return Excel::download(new EmployeesExport, 'quan-nhan-' . date('Y-m-d') . '.xlsx');
    }

    /**
     * Tạo employee từ dữ liệu JSON
     */
    private function createEmployee($memberData, $departmentId, $centerId)
    {
        // Tạo position nếu chưa có
        $position = Position::firstOrCreate(
            ['name' => $memberData['position']],
            ['code' => substr($memberData['position'], 0, 10), 'description' => $memberData['position']]
        );
        
        // Tạo user với password mặc định
        $user = User::create([
            'name' => $memberData['full_name'],
            'email' => $memberData['username'] . '@quandoi.local',
            'username' => $memberData['username'],
            'password' => Hash::make('123456'),
            'email_verified_at' => now()
        ]);
        
        // Tạo employee
        $employee = Employee::create([
            'user_id' => $user->id,
            'first_name' => explode(' ', $memberData['full_name'])[0],
            'last_name' => implode(' ', array_slice(explode(' ', $memberData['full_name']), 1)),
            'full_name' => $memberData['full_name'],
            'date_of_birth' => $this->parseDate($memberData['dob']),
            'enlist_date' => $this->parseDate($memberData['enlist_td']),
            'rank_code' => $memberData['rank_code'],
            'position_id' => $position->id,
            'department_id' => $departmentId,
            'center_id' => $centerId,
            'is_active' => true,
            'national_number' => $memberData['username'],
            'mobile' => '0' . rand(100000000, 999999999),
            'address' => 'Địa chỉ quân đội',
            'gender' => 'male',
            'contract_id' => 'CT-' . $memberData['username'],
            'start_date' => $this->parseDate($memberData['enlist_td']) ?? now(),
            'quit_date' => null
        ]);
        
        // Gán role dựa trên position
        $this->assignRole($user, $memberData['position']);
        
        return $employee;
    }

    /**
     * Gán role cho user dựa trên chức vụ
     */
    private function assignRole($user, $position)
    {
        $position = strtolower($position);
        
        if (strpos($position, 'giám đốc') !== false || strpos($position, 'chính uỷ') !== false) {
            $user->assignRole('Admin');
        } elseif (strpos($position, 'trưởng') !== false || strpos($position, 'đội trưởng') !== false) {
            $user->assignRole('HR');
        } else {
            $user->assignRole('AM');
        }
    }

    /**
     * Parse ngày từ string
     */
    private function parseDate($dateString)
    {
        if (!$dateString) return null;
        
        if (strpos($dateString, '/') !== false) {
            $parts = explode('/', $dateString);
            if (count($parts) == 2) {
                $month = $parts[0];
                $year = '19' . $parts[1];
                return "{$year}-{$month}-01";
            } elseif (count($parts) == 3) {
                $day = $parts[0];
                $month = $parts[1];
                $year = strlen($parts[2]) == 2 ? '19' . $parts[2] : $parts[2];
                return "{$year}-{$month}-{$day}";
            }
        }
        
        return null;
    }

    /**
     * Lấy danh sách quân nhân
     */
    public function index()
    {
        $employees = Employee::with(['user', 'position', 'department', 'center'])
            ->orderBy('full_name')
            ->paginate(20);

        return view('military.employees.index', compact('employees'));
    }
}
