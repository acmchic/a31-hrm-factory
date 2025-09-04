<?php

use App\Http\Controllers\language\LanguageController;
use App\Livewire\Assets\Categories;
use App\Livewire\Assets\Inventory;
use App\Livewire\ContactUs;
use App\Livewire\Dashboard;
use App\Livewire\HumanResource\Attendance\Fingerprints;
use App\Livewire\HumanResource\Attendance\Leaves;
use App\Livewire\HumanResource\Discounts;
use App\Livewire\HumanResource\Holidays;
use App\Livewire\HumanResource\Messages\Bulk;
use App\Livewire\HumanResource\Messages\Personal;
use App\Livewire\HumanResource\Statistics;
use App\Livewire\HumanResource\Structure\Centers;
use App\Livewire\HumanResource\Structure\Departments;
use App\Livewire\HumanResource\Structure\EmployeeInfo;
use App\Livewire\HumanResource\Structure\Employees;
use App\Livewire\HumanResource\Structure\Positions;
use App\Livewire\Misc\ComingSoon;
use App\Livewire\Settings\Users;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

// Language switching disabled
// Route::get('lang/{locale}', [LanguageController::class, 'swap']);

// Routes cho quân nhân
Route::prefix('military')->group(function () {
    Route::get('/employees', [App\Http\Controllers\MilitaryImportExportController::class, 'index'])->name('military.employees.index');
    Route::post('/import-excel', [App\Http\Controllers\MilitaryImportExportController::class, 'importExcel'])->name('military.import.excel');
    Route::post('/import-json', [App\Http\Controllers\MilitaryImportExportController::class, 'importFromJson'])->name('military.import.json');
    Route::get('/export-excel', [App\Http\Controllers\MilitaryImportExportController::class, 'exportExcel'])->name('military.export.excel');
});

Route::middleware([
    'auth:sanctum',
    config('jetstream.auth_session'),
    'verified',
    'allow_admin_during_maintenance',
])->group(function () {
    // 👉 Dashboard
    Route::group(['middleware' => ['role:Admin|AM|CC|CR|HR']], function () {
        Route::redirect('/', '/dashboard');
        Route::get('/dashboard', Dashboard::class)->name('dashboard');
    });

    // 👉 Human Resource
    Route::group(['middleware' => ['role:Admin|HR']], function () {
        Route::prefix('attendance')->group(function () {
            Route::get('/fingerprints', Fingerprints::class)->name('attendance-fingerprints');
        });
    });

    Route::group(['middleware' => ['role:Admin|HR|CC']], function () {
        Route::prefix('attendance')->group(function () {
            // Empty - moved leaves to be accessible by all users
        });
    });

    // Leave management available for all authenticated users
    Route::get('/attendance/leaves', Leaves::class)->name('attendance-leaves');
    Route::get('/attendance/leave-management', \App\Livewire\HumanResource\LeaveManagement::class)->name('attendance-leave-management');
    
    // Download route for leave documents - Generate proper PDF
    Route::get('/leave/{id}/download', function($id) {
        $employeeLeave = \App\Models\EmployeeLeave::findOrFail($id);
        
        if (!$employeeLeave->digital_signature) {
            abort(404, 'Tài liệu không tồn tại');
        }

        // Use DigitalSignatureService to generate proper PDF
        $digitalSignatureService = new \App\Services\DigitalSignatureService();
        
        try {
            $pdfContent = $digitalSignatureService->generateLeaveRequestPDF($employeeLeave);
            
            return response($pdfContent)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'attachment; filename="don_nghi_phep_' . $employeeLeave->id . '.pdf"');
                
        } catch (\Exception $e) {
            abort(500, 'Lỗi tạo PDF: ' . $e->getMessage());
        }
            
    })->name('leave.download');
    
    // Custom profile route with Vietnamese interface
    Route::get('/user/profile', function() {
        return view('profile.show-vietnamese');
    })->name('profile.show');
    
    // Vehicle Registration System
    Route::get('/vehicles/registration', \App\Livewire\VehicleRegistration::class)->name('vehicle-registration');
    
    // Debug route to check user roles
    Route::get('/debug-roles', function() {
        $user = Auth::user();
        
        // Ensure roles exist
        $roles = ['Admin', 'HR', 'CC', 'AM'];
        foreach ($roles as $roleName) {
            \Spatie\Permission\Models\Role::firstOrCreate(['name' => $roleName, 'guard_name' => 'web']);
        }
        
        return response()->json([
            'user' => $user->email ?? $user->username,
            'name' => $user->name,
            'username' => $user->username ?? 'N/A',
            'roles' => $user->getRoleNames(),
            'has_admin' => $user->hasRole('Admin'),
            'has_hr' => $user->hasRole('HR'),
            'has_cc' => $user->hasRole('CC'),
            'has_am' => $user->hasRole('AM'),
            'has_any_role' => $user->hasAnyRole(['Admin', 'HR', 'CC']),
            'all_roles_in_db' => \Spatie\Permission\Models\Role::pluck('name')->toArray(),
        ]);
    });

    Route::group(['middleware' => ['role:Admin|HR']], function () {
        Route::prefix('structure')->group(function () {
            Route::get('/centers', Centers::class)->name('structure-centers');
            Route::get('/departments', Departments::class)->name('structure-departments');
            Route::get('/departments/{id}', Departments::class)->name('structure-departments-show');
            Route::get('/positions', Positions::class)->name('structure-positions');
            Route::get('/employees', Employees::class)->name('structure-employees');
            Route::get('/employee/{id?}', EmployeeInfo::class)->name('structure-employees-info');
        });
    });

    Route::prefix('messages')->group(function () {
        Route::get('/bulk', Bulk::class)
            ->middleware('role:Admin|HR|CC')
            ->name('messages-bulk');
        Route::get('/personal', Personal::class)
            ->middleware('role:Admin|HR')
            ->name('messages-personal');
    });

    Route::group(['middleware' => ['role:Admin|HR']], function () {
        Route::get('/discounts', Discounts::class)->name('discounts');
        Route::get('/holidays', Holidays::class)->name('holidays');
    });

    Route::group(['middleware' => ['role:Admin|HR']], function () {
        Route::get('/statistics', Statistics::class)->name('statistics');
    });

    Route::group(['middleware' => ['role:Admin']], function () {
        Route::prefix('settings')->group(function () {
            Route::get('/users', Users::class)->name('settings-users');
            Route::get('/roles', ComingSoon::class)->name('settings-roles');
            Route::get('/permissions', ComingSoon::class)->name('settings-permissions');
        });
    });

    // 👉 Assets
    Route::group(['middleware' => ['role:Admin|AM']], function () {
        Route::get('/assets/inventory', Inventory::class)->name('inventory');
        Route::get('/assets/categories', Categories::class)->name('categories');
        // Route::get('/assets/transfers', ComingSoon::class)->name('transfers');
    });
    Route::group(['middleware' => ['role:Admin|AM|HR']], function () {
        Route::get('/assets/reports', ComingSoon::class)->name('reports');
    });
});

Route::get('/contact-us', ContactUs::class)->name('contact-us');

Route::webhooks('/deploy');
