<?php

namespace App\Livewire;

use App\Models\Vehicle;
use App\Models\VehicleRegistration as VehicleRegistrationModel;
use App\Models\User;
use App\Imports\VehiclesImport;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Livewire\Component;
use Livewire\WithPagination;
use Livewire\WithFileUploads;
use Maatwebsite\Excel\Facades\Excel;

class VehicleRegistration extends Component
{
    use WithPagination, WithFileUploads;
    
    protected $listeners = ['refreshComponent' => '$refresh'];

    // Workflow status constants
    const STATUS_SUBMITTED = 'submitted';
    const STATUS_DEPT_REVIEW = 'dept_review';
    const STATUS_DIRECTOR_REVIEW = 'director_review';
    const STATUS_APPROVED = 'approved';
    const STATUS_REJECTED = 'rejected';

    // Vietnamese status labels
    const STATUS_LABELS = [
        self::STATUS_SUBMITTED => 'Chờ Trưởng phòng duyệt',
        self::STATUS_DEPT_REVIEW => 'Chờ Thủ trưởng duyệt',
        self::STATUS_DIRECTOR_REVIEW => 'Chờ Thủ trưởng duyệt',
        self::STATUS_APPROVED => 'Đã phê duyệt',
        self::STATUS_REJECTED => 'Bị từ chối',
    ];

    // Registration form properties
    public $vehicle_id = '';
    public $departure_date = '';
    public $return_date = '';
    public $departure_time = '';
    public $return_time = '';
    public $route = '';
    public $purpose = '';
    public $driver_id = '';

    // Filter properties
    public $statusFilter = '';
    public $categoryFilter = '';
    public $dateFilter = '';
    
    // Selected registration for detail view
    public $selectedRegistration;

    // Modal states
    public $isCreating = false;
    public $isImporting = false;
    public $importFile;

    // Other
    public $selectedCategory = '';
    public $availableVehicles = [];
    public $vehicleCategories = [];
    public $availableDrivers = [];
    public $dateRange = '';
    public $isEdit = false;
    public $editingRegistrationId = null;

    protected $rules = [
        'vehicle_id' => 'required|exists:vehicles,id',
        'departure_date' => 'required|date|after_or_equal:today',
        'return_date' => 'required|date|after_or_equal:departure_date',
        'route' => 'required|min:2',
        'purpose' => 'required|min:2',
        'driver_id' => 'required|exists:employees,id',
    ];

    protected $messages = [
        'vehicle_id.required' => 'Vui lòng chọn xe',
        'departure_date.required' => 'Vui lòng chọn ngày đi',
        'departure_date.after_or_equal' => 'Ngày đi không được trong quá khứ',
        'return_date.required' => 'Vui lòng chọn ngày về',
        'return_date.after_or_equal' => 'Ngày về phải sau hoặc bằng ngày đi',
        'route.required' => 'Vui lòng nhập tuyến đường',
        'route.min' => 'Tuyến đường phải có ít nhất 2 ký tự',
        'purpose.required' => 'Vui lòng nhập lý do xin xe',
        'purpose.min' => 'Lý do xin xe phải có ít nhất 2 ký tự',
        'driver_id.required' => 'Vui lòng chọn lái xe',
        'driver_id.exists' => 'Lái xe không tồn tại',
    ];

    public function mount()
    {
        $this->ensureTablesExist();
        $this->loadVehicleData();
        $this->driver_name = Auth::user()->name; // Default to current user
        
        // Ensure all required roles exist
        $this->ensureRolesExist();
        
        // Assign roles for testing
        $this->assignTestRoles();
    }
    
    private function ensureRolesExist()
    {
        try {
            $roles = ['Admin', 'HR', 'CC', 'AM'];
            foreach ($roles as $roleName) {
                \Spatie\Permission\Models\Role::firstOrCreate(['name' => $roleName, 'guard_name' => 'web']);
            }
        } catch (\Exception $e) {
            // If database connection fails, log the error but continue
            Log::warning('Could not create roles: ' . $e->getMessage());
        }
    }
    
    private function assignTestRoles()
    {
        try {
            $currentUser = Auth::user();
            
            // Ensure ndsu user has HR role for testing (Trưởng phòng)
            if ($currentUser->username === 'ndsu' && !$currentUser->hasRole('HR')) {
                $currentUser->assignRole('HR');
            }
            
            // Ensure director user has CC role for testing (Giám đốc)
            if (in_array($currentUser->username, ['director', 'ndlinh']) && !$currentUser->hasRole('CC')) {
                $currentUser->assignRole('CC');
            }
            
            // Ensure regular users have AM role
            if (!$currentUser->hasAnyRole(['Admin', 'HR', 'CC']) && !$currentUser->hasRole('AM')) {
                $currentUser->assignRole('AM');
            }
        } catch (\Exception $e) {
            // If role assignment fails, log the error but continue
            Log::warning('Could not assign roles: ' . $e->getMessage());
        }
    }

    public function render()
    {
        // Check if user is from Planning Department or higher
        try {
            $canAccess = Auth::user()->hasAnyRole(['Admin', 'HR', 'CC']) ||
                         $this->isFromPlanningDepartment();
        } catch (\Exception $e) {
            // If role check fails, allow access for now
            Log::warning('Role check failed: ' . $e->getMessage());
            $canAccess = true;
        }

        if (!$canAccess) {
            abort(403, 'Bạn không có quyền truy cập module đăng ký xe.');
        }

        $query = VehicleRegistrationModel::with(['vehicle', 'user', 'departmentApprover', 'directorApprover']);
        
        // If user is regular employee, only show their own registrations
        // If user is manager/admin, show all registrations for approval
        try {
            if (!Auth::user()->hasAnyRole(['Admin', 'HR', 'CC'])) {
                $query->where('user_id', Auth::user()->id);
            }
        } catch (\Exception $e) {
            // If role check fails, show only own registrations
            $query->where('user_id', Auth::user()->id);
        }

        // Apply filters
        if ($this->statusFilter) {
            $query->where('status', $this->statusFilter);
        }

        if ($this->dateFilter) {
            $query->whereDate('departure_date', $this->dateFilter);
        }

        $registrations = $query->orderBy('created_at', 'desc')->paginate(10);

        // Get statistics - for managers show all, for employees show own
        $statsQuery = VehicleRegistrationModel::query();
        
        try {
            if (!Auth::user()->hasAnyRole(['Admin', 'HR', 'CC'])) {
                $statsQuery->where('user_id', Auth::user()->id);
            }
        } catch (\Exception $e) {
            $statsQuery->where('user_id', Auth::user()->id);
        }
        
        $stats = [
            'total' => $statsQuery->count(),
            'pending' => $statsQuery->where('workflow_status', 'submitted')->count(),
            'approved' => $statsQuery->where('workflow_status', 'approved')->count(),
            'rejected' => $statsQuery->where('workflow_status', 'rejected')->count(),
        ];

        return view('livewire.vehicle-registration', [
            'registrations' => $registrations,
            'stats' => $stats,
            'vehicles' => $this->availableVehicles,
            'categories' => $this->vehicleCategories,
        ]);
    }

    public function updatedSelectedCategory()
    {
        $this->loadVehiclesByCategory();
        $this->vehicle_id = ''; // Reset vehicle selection
    }

    public function startCreating()
    {
        $this->isCreating = true;
        $this->reset(['vehicle_id', 'departure_date', 'return_date', 'departure_time', 'return_time', 'route', 'purpose', 'passenger_count', 'driver_license']);
        $this->driver_name = Auth::user()->name;
        $this->loadVehicleData();
    }

    public function cancelCreating()
    {
        $this->isCreating = false;
        $this->reset(['vehicle_id', 'departure_date', 'return_date', 'departure_time', 'return_time', 'route', 'purpose', 'passenger_count', 'driver_name', 'driver_license', 'selectedCategory']);
        $this->dispatch('clearVehicleForm');
    }

    public function submitRegistration()
    {
        try {
            Log::info('Vehicle registration submission started', [
                'vehicle_id' => $this->vehicle_id,
                'driver_id' => $this->driver_id,
                'departure_date' => $this->departure_date,
                'return_date' => $this->return_date,
                'route' => $this->route,
                'purpose' => $this->purpose
            ]);
            
            $this->skipRender();
            $this->validate();

            // Check if vehicle_registrations table exists
            $this->ensureVehicleRegistrationTableExists();

            if ($this->isEdit && $this->editingRegistrationId) {
                // Update existing registration
                $registration = VehicleRegistrationModel::where('id', $this->editingRegistrationId)
                    ->where('user_id', Auth::id())
                    ->first();
                    
                if ($registration) {
                    $driver = \App\Models\Employee::find($this->driver_id);
                    $registration->update([
                        'vehicle_id' => $this->vehicle_id,
                        'departure_date' => $this->departure_date,
                        'return_date' => $this->return_date,
                        'departure_time' => '08:00:00',
                        'return_time' => '17:00:00',
                        'route' => $this->route,
                        'purpose' => $this->purpose,
                        'driver_name' => $driver->name ?? '',
                        'driver_license' => '',
                    ]);
                    
                    session()->flash('success', 'Đăng ký xe đã được cập nhật thành công.');
                }
            } else {
                // Create new registration
                $driver = \App\Models\Employee::find($this->driver_id);
                $registration = VehicleRegistrationModel::create([
                    'user_id' => Auth::user()->id,
                    'vehicle_id' => $this->vehicle_id,
                    'departure_date' => $this->departure_date,
                    'return_date' => $this->return_date,
                    'departure_time' => '08:00:00', // Default time
                    'return_time' => '17:00:00', // Default time
                    'route' => $this->route,
                    'purpose' => $this->purpose,
                    'passenger_count' => 1, // Default value
                    'driver_name' => $driver->name ?? '',
                    'driver_license' => '',
                    'workflow_status' => self::STATUS_SUBMITTED,
                    'created_by' => Auth::user()->name,
                ]);

                // Set initial status to wait for department head approval
                // No auto-assignment needed
                session()->flash('success', 'Đăng ký xe đã được gửi thành công! Chờ phê duyệt từ trưởng phòng.');
                
                // Reset form and refresh component
                $this->resetForm();
                $this->dispatch('clearVehicleForm');
                $this->dispatch('closeModal', elementId: '#vehicleModal');
                
                // Force component refresh to show new record immediately
                return redirect()->to(request()->header('Referer'));
            }
            
        } catch (\Exception $e) {
            session()->flash('error', 'Lỗi khi tạo đăng ký: ' . $e->getMessage());
            Log::error('Vehicle registration error: ' . $e->getMessage());
        }
    }

    public function importVehicles()
    {
        $this->validate([
            'importFile' => 'required|mimes:xlsx,xls|max:10240',
        ]);

        try {
            Excel::import(new VehiclesImport, $this->importFile->getRealPath());
            
            $this->reset('importFile');
            $this->isImporting = false;
            $this->loadVehicleData();
            
            session()->flash('success', 'Import xe thành công!');
            
        } catch (\Exception $e) {
            session()->flash('error', 'Lỗi import: ' . $e->getMessage());
        }
    }

    public function loadVehicleData()
    {
        $this->vehicleCategories = Vehicle::distinct()->pluck('category')->filter()->toArray();
        $this->loadVehiclesByCategory();
        $this->loadDrivers();
    }

    public function loadDrivers()
    {
        // Load employees where position name = 'Lái xe'
        $this->availableDrivers = \App\Models\Employee::with(['position'])
            ->whereHas('position', function($query) {
                $query->where('name', 'LIKE', '%Lái xe%')
                      ->orWhere('name', 'LIKE', '%lái xe%')
                      ->orWhere('name', 'LIKE', '%Driver%')
                      ->orWhere('name', 'LIKE', '%driver%');
            })
            ->where('is_active', true)
            ->get();
            
        \Log::info('Drivers loaded', [
            'drivers_count' => $this->availableDrivers->count(),
            'drivers' => $this->availableDrivers->pluck('name', 'id')->toArray()
        ]);

        // If no drivers found, create some sample data or show message
        if ($this->availableDrivers->isEmpty()) {
            // You can add fallback logic here if needed
            $this->availableDrivers = collect();
        }
    }

    public function loadVehiclesByCategory()
    {
        $query = Vehicle::active();
        
        if ($this->selectedCategory) {
            $query->where('category', $this->selectedCategory);
        }
        
        $this->availableVehicles = $query->get();
    }

    protected function isFromPlanningDepartment()
    {
        // Check if user is from Planning Department
        // This is a simplified check - you may need to adjust based on your department structure
        $user = Auth::user();
        
        // For now, allow all users for testing
        return true;
    }

    protected function assignToDepartmentHead(VehicleRegistrationModel $registration)
    {
        // Find department head (Planning Department head - ndsu)
        $departmentHead = User::where('username', 'ndsu')->first();
        
        if ($departmentHead) {
            $registration->update([
                'workflow_status' => 'dept_review',
            ]);
        }
    }

    public function deleteRegistration($registrationId)
    {
        try {
            $registration = VehicleRegistrationModel::where('id', $registrationId)
                ->where('user_id', Auth::user()->id)
                ->where('workflow_status', 'submitted')
                ->first();

            if ($registration) {
                $registration->delete();
                session()->flash('success', 'Đã xóa đăng ký xe!');
            } else {
                session()->flash('error', 'Không thể xóa đăng ký xe này!');
            }
        } catch (\Exception $e) {
            session()->flash('error', 'Lỗi khi xóa: ' . $e->getMessage());
        }
    }

    public function resetFilters()
    {
        $this->reset(['statusFilter', 'categoryFilter', 'dateFilter']);
    }

    protected function ensureTablesExist()
    {
        try {
            // Try to query vehicles table to check if it exists
            \DB::table('vehicles')->count();
        } catch (\Exception $e) {
            // If table doesn't exist, create it and insert sample data
            $this->createVehicleTables();
        }
    }

    protected function createVehicleTables()
    {
        try {
            // Create vehicles table
            \DB::statement("
                CREATE TABLE IF NOT EXISTS vehicles (
                    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(255) NOT NULL,
                    category VARCHAR(255) NOT NULL,
                    license_plate VARCHAR(255) NOT NULL UNIQUE,
                    brand VARCHAR(255) NULL,
                    model VARCHAR(255) NULL,
                    year INT NULL,
                    color VARCHAR(255) NULL,
                    fuel_type VARCHAR(255) NULL,
                    capacity INT NULL,
                    status ENUM('available', 'in_use', 'maintenance', 'broken') DEFAULT 'available',
                    description TEXT NULL,
                    is_active TINYINT(1) DEFAULT 1,
                    created_by VARCHAR(255) NULL,
                    updated_by VARCHAR(255) NULL,
                    deleted_by VARCHAR(255) NULL,
                    created_at TIMESTAMP NULL DEFAULT NULL,
                    updated_at TIMESTAMP NULL DEFAULT NULL,
                    deleted_at TIMESTAMP NULL DEFAULT NULL
                )
            ");

            // Create vehicle_registrations table
            \DB::statement("
                CREATE TABLE IF NOT EXISTS vehicle_registrations (
                    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                    user_id BIGINT UNSIGNED NOT NULL,
                    vehicle_id BIGINT UNSIGNED NOT NULL,
                    departure_date DATE NOT NULL,
                    return_date DATE NOT NULL,
                    departure_time TIME NOT NULL,
                    return_time TIME NOT NULL,
                    route TEXT NOT NULL,
                    purpose TEXT NOT NULL,
                    passenger_count INT DEFAULT 1,
                    driver_name VARCHAR(255) NULL,
                    driver_license VARCHAR(255) NULL,
                    status ENUM('pending', 'dept_approved', 'approved', 'rejected') DEFAULT 'pending',
                    workflow_status ENUM('submitted', 'dept_review', 'director_review', 'approved', 'rejected') DEFAULT 'submitted',
                    department_approved_by BIGINT UNSIGNED NULL,
                    department_approved_at TIMESTAMP NULL,
                    digital_signature_dept TEXT NULL,
                    director_approved_by BIGINT UNSIGNED NULL,
                    director_approved_at TIMESTAMP NULL,
                    digital_signature_director TEXT NULL,
                    rejection_reason TEXT NULL,
                    rejection_level ENUM('department', 'director') NULL,
                    created_by VARCHAR(255) NULL,
                    updated_by VARCHAR(255) NULL,
                    deleted_by VARCHAR(255) NULL,
                    created_at TIMESTAMP NULL DEFAULT NULL,
                    updated_at TIMESTAMP NULL DEFAULT NULL,
                    deleted_at TIMESTAMP NULL DEFAULT NULL
                )
            ");

            // Insert sample vehicles
            \DB::table('vehicles')->insert([
                [
                    'name' => 'Xe ô tô Toyota Camry',
                    'category' => 'Xe con',
                    'license_plate' => '30A-12345',
                    'brand' => 'Toyota',
                    'model' => 'Camry',
                    'year' => 2020,
                    'color' => 'Trắng',
                    'fuel_type' => 'Xăng',
                    'capacity' => 5,
                    'status' => 'available',
                    'is_active' => 1,
                    'created_by' => 'System',
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Xe ô tô Honda CR-V',
                    'category' => 'Xe SUV',
                    'license_plate' => '30A-67890',
                    'brand' => 'Honda',
                    'model' => 'CR-V',
                    'year' => 2021,
                    'color' => 'Đen',
                    'fuel_type' => 'Xăng',
                    'capacity' => 7,
                    'status' => 'available',
                    'is_active' => 1,
                    'created_by' => 'System',
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Xe tải Hyundai Porter',
                    'category' => 'Xe tải',
                    'license_plate' => '30C-11111',
                    'brand' => 'Hyundai',
                    'model' => 'Porter',
                    'year' => 2019,
                    'color' => 'Xanh',
                    'fuel_type' => 'Dầu',
                    'capacity' => 3,
                    'status' => 'available',
                    'is_active' => 1,
                    'created_by' => 'System',
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Xe buýt Thaco Universe',
                    'category' => 'Xe buýt',
                    'license_plate' => '30B-22222',
                    'brand' => 'Thaco',
                    'model' => 'Universe',
                    'year' => 2018,
                    'color' => 'Vàng',
                    'fuel_type' => 'Dầu',
                    'capacity' => 45,
                    'status' => 'available',
                    'is_active' => 1,
                    'created_by' => 'System',
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
            ]);

        } catch (\Exception $e) {
            Log::error('Error creating vehicle tables: ' . $e->getMessage());
        }
    }

    protected function ensureVehicleRegistrationTableExists()
    {
        try {
            // Try to query vehicle_registrations table
            \DB::table('vehicle_registrations')->count();
        } catch (\Exception $e) {
            // If table doesn't exist, create it
            \DB::statement("
                CREATE TABLE IF NOT EXISTS vehicle_registrations (
                    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                    user_id BIGINT UNSIGNED NOT NULL,
                    vehicle_id BIGINT UNSIGNED NOT NULL,
                    departure_date DATE NOT NULL,
                    return_date DATE NOT NULL,
                    departure_time TIME NOT NULL,
                    return_time TIME NOT NULL,
                    route TEXT NOT NULL,
                    purpose TEXT NOT NULL,
                    passenger_count INT DEFAULT 1,
                    driver_name VARCHAR(255) NULL,
                    driver_license VARCHAR(255) NULL,
                    status ENUM('pending', 'dept_approved', 'approved', 'rejected') DEFAULT 'pending',
                    workflow_status ENUM('submitted', 'dept_review', 'director_review', 'approved', 'rejected') DEFAULT 'submitted',
                    department_approved_by BIGINT UNSIGNED NULL,
                    department_approved_at TIMESTAMP NULL,
                    digital_signature_dept TEXT NULL,
                    director_approved_by BIGINT UNSIGNED NULL,
                    director_approved_at TIMESTAMP NULL,
                    digital_signature_director TEXT NULL,
                    rejection_reason TEXT NULL,
                    rejection_level ENUM('department', 'director') NULL,
                    created_by VARCHAR(255) NULL,
                    updated_by VARCHAR(255) NULL,
                    deleted_by VARCHAR(255) NULL,
                    created_at TIMESTAMP NULL DEFAULT NULL,
                    updated_at TIMESTAMP NULL DEFAULT NULL,
                    deleted_at TIMESTAMP NULL DEFAULT NULL
                )
            ");
        }
    }

    public function showCreateVehicleModal()
    {
        $this->resetForm();
        $this->isEdit = false;
        $this->editingRegistrationId = null;
        $this->loadVehicleData();
    }

    public function showUpdateVehicleModal($registrationId)
    {
        $registration = VehicleRegistrationModel::find($registrationId);

        if ($registration && $registration->user_id == Auth::user()->id) {
            // Set edit mode first
            $this->isEdit = true;
            $this->editingRegistrationId = $registrationId;
            
            // Load registration data
            $this->vehicle_id = $registration->vehicle_id;
            $this->departure_date = $registration->departure_date;
            $this->return_date = $registration->return_date;
            $this->route = $registration->route;
            $this->purpose = $registration->purpose;
            
            // Try to find driver by name
            $driver = \App\Models\Employee::where('name', $registration->driver_name)->first();
            $this->driver_id = $driver->id ?? '';
            
            // Load vehicle data last
            $this->loadVehicleData();
            
            session()->flash('success', 'Đã tải dữ liệu để chỉnh sửa!');
        } else {
            session()->flash('error', 'Không tìm thấy đăng ký xe để chỉnh sửa! ID: ' . $registrationId . ' | User: ' . Auth::user()->id . ' | Registration User: ' . ($registration->user_id ?? 'null'));
        }
    }

    public function viewRegistrationDetail($registrationId)
    {
        $this->selectedRegistration = VehicleRegistrationModel::with(['vehicle', 'user'])->find($registrationId);
    }

    public function confirmDeleteRegistration($registrationId)
    {
        $registration = VehicleRegistrationModel::find($registrationId);
        
        if ($registration && $registration->user_id == Auth::user()->id && $registration->workflow_status === self::STATUS_SUBMITTED) {
            $registration->delete();
            session()->flash('success', 'Đã xóa đăng ký xe thành công!');
        } else {
            session()->flash('error', 'Không thể xóa đăng ký xe này!');
        }
    }

    public function approveDepartment($registrationId)
    {
        $registration = VehicleRegistrationModel::find($registrationId);
        
        if ($registration && $registration->workflow_status === self::STATUS_SUBMITTED) {
            try {
                // Generate and sign PDF for department approval
                $vehicleService = new \App\Services\VehicleDigitalSignatureService();
                $pdfContent = $vehicleService->generateVehicleRegistrationPDF($registration);
                $signedPdf = $vehicleService->signPdfBinary($pdfContent);
                
                // Store signed PDF
                $signedPath = 'signed/vehicles/vehicle_' . $registration->id . '_dept_signed.pdf';
                $vehicleService->storeSignedPdf($signedPdf, $signedPath);
                
                // Add digital signature for department approval
                $signatureData = [
                    'approved_by' => Auth::user()->name,
                    'approved_at' => now()->format('d/m/Y H:i:s'),
                    'position' => 'Trưởng phòng Kế hoạch',
                    'signature_path' => Auth::user()->signature_path,
                    'signed_pdf_path' => $signedPath,
                ];
                
                $registration->update([
                    'workflow_status' => self::STATUS_DEPT_REVIEW,
                    'department_approved_at' => now(),
                    'department_approved_by' => Auth::user()->id,
                    'digital_signature_dept' => json_encode($signatureData),
                ]);
                
                session()->flash('success', 'Đã phê duyệt cấp trưởng phòng. Chờ Thủ trưởng phê duyệt.');
                
            } catch (\Exception $e) {
                Log::error('Error approving department: ' . $e->getMessage());
                session()->flash('error', 'Có lỗi xảy ra khi phê duyệt: ' . $e->getMessage());
            }
        }
    }

    public function approveDirector($registrationId)
    {
        $registration = VehicleRegistrationModel::find($registrationId);
        
        if ($registration && $registration->workflow_status === self::STATUS_DEPT_REVIEW) {
            try {
                // Generate and sign PDF for director approval
                $vehicleService = new \App\Services\VehicleDigitalSignatureService();
                $pdfContent = $vehicleService->generateVehicleRegistrationPDF($registration);
                $signedPdf = $vehicleService->signPdfBinary($pdfContent);
                
                // Store signed PDF
                $signedPath = 'signed/vehicles/vehicle_' . $registration->id . '_director_signed.pdf';
                $vehicleService->storeSignedPdf($signedPdf, $signedPath);
                
                // Add digital signature for director approval
                $signatureData = [
                    'approved_by' => Auth::user()->name,
                    'approved_at' => now()->format('d/m/Y H:i:s'),
                    'position' => 'Ban Giám đốc',
                    'signature_path' => Auth::user()->signature_path,
                    'signed_pdf_path' => $signedPath,
                ];
                
                $registration->update([
                    'workflow_status' => self::STATUS_APPROVED,
                    'director_approved_at' => now(),
                    'director_approved_by' => Auth::user()->id,
                    'digital_signature_director' => json_encode($signatureData),
                ]);
                
                session()->flash('success', 'Đã phê duyệt cấp Thủ trưởng. Đăng ký xe đã hoàn tất.');
                
            } catch (\Exception $e) {
                Log::error('Error approving director: ' . $e->getMessage());
                session()->flash('error', 'Có lỗi xảy ra khi phê duyệt: ' . $e->getMessage());
            }
        }
    }

    public function rejectRegistration($registrationId)
    {
        $registration = VehicleRegistrationModel::find($registrationId);
        
        if ($registration) {
            $registration->update([
                'workflow_status' => 'rejected',
                'rejected_at' => now(),
                'rejected_by' => Auth::id(),
            ]);
            
            session()->flash('success', 'Đã từ chối đăng ký.');
        }
    }

    public function applyFilter()
    {
        // Apply filters and refresh data
        $this->resetPage();
    }

    public function downloadVehiclePDF($registrationId)
    {
        $registration = VehicleRegistrationModel::with(['vehicle', 'user'])->find($registrationId);
        
        if (!$registration) {
            session()->flash('error', 'Không tìm thấy đăng ký xe.');
            return;
        }

        if (!in_array($registration->workflow_status, ['dept_review', 'approved'])) {
            session()->flash('error', 'Chỉ có thể tải PDF sau khi được phê duyệt.');
            return;
        }

        try {
            // Check for existing signed PDF first
            $signedPdfPath = null;
            if ($registration->workflow_status === 'approved' && $registration->digital_signature_director) {
                $signatureData = json_decode($registration->digital_signature_director, true);
                $signedPdfPath = $signatureData['signed_pdf_path'] ?? null;
            } elseif ($registration->workflow_status === 'dept_review' && $registration->digital_signature_dept) {
                $signatureData = json_decode($registration->digital_signature_dept, true);
                $signedPdfPath = $signatureData['signed_pdf_path'] ?? null;
            }
            
            // If signed PDF exists, use it
            if ($signedPdfPath && file_exists(storage_path('app/' . $signedPdfPath))) {
                $pdfContent = file_get_contents(storage_path('app/' . $signedPdfPath));
            } else {
                // Generate new PDF using VehicleDigitalSignatureService
                $vehicleService = new \App\Services\VehicleDigitalSignatureService();
                $pdfContent = $vehicleService->generateVehicleRegistrationPDF($registration);
                $signedPdf = $vehicleService->signPdfBinary($pdfContent);
                $pdfContent = $signedPdf;
            }

            $filename = 'dang_ky_xe_' . $registration->id . '_' . date('Y_m_d') . '.pdf';

            // Save PDF to temporary file and redirect for download
            $tempPath = storage_path('app/temp/' . $filename);

            // Ensure temp directory exists
            if (!file_exists(storage_path('app/temp'))) {
                mkdir(storage_path('app/temp'), 0755, true);
            }

            // Check if this is a PDF binary response or text fallback
            if (is_string($pdfContent) && !preg_match('/^%PDF-/', $pdfContent)) {
                // This is text fallback, apply UTF-8 encoding and save as text
                $pdfContent = mb_convert_encoding($pdfContent, 'UTF-8', 'UTF-8');
                $tempPath = str_replace('.pdf', '.txt', $tempPath);
                $filename = str_replace('.pdf', '.txt', $filename);
            }

            // Save content to temp file
            $writeResult = file_put_contents($tempPath, $pdfContent);

            Log::info('File write result', [
                'temp_path' => $tempPath,
                'write_result' => $writeResult,
                'file_exists' => file_exists($tempPath),
                'file_size' => file_exists($tempPath) ? filesize($tempPath) : 0,
                'content_length' => strlen($pdfContent)
            ]);

            // Use JavaScript to trigger download
            Log::info('Dispatching download event', [
                'filename' => $filename,
                'path' => $tempPath,
                'registration_id' => $registrationId
            ]);

            // Try direct redirect first, if not working, use JavaScript dispatch
            $downloadUrl = '/download-temp-file?filename=' . urlencode($filename);
            return redirect($downloadUrl);

        } catch (\Exception $e) {
            // Log the full error for debugging
            Log::error('Vehicle PDF Download Error: ' . $e->getMessage());
            Log::error('Registration ID: ' . $registrationId);
            Log::error('Registration Status: ' . $registration->workflow_status);

            session()->flash('error', 'Lỗi tạo PDF: ' . $e->getMessage());
        }
    }

    private function resetForm()
    {
        $this->vehicle_id = '';
        $this->departure_date = '';
        $this->return_date = '';
        $this->route = '';
        $this->purpose = '';
        $this->driver_id = '';
        $this->editingRegistrationId = null;
        $this->dispatch('clearVehicleForm');
    }
}
