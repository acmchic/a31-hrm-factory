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

Route::get('lang/{locale}', [LanguageController::class, 'swap']);

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
    
    // Download route for leave documents
    Route::get('/leave/{id}/download', function($id) {
        $employeeLeave = \App\Models\EmployeeLeave::findOrFail($id);
        
        if (!$employeeLeave->digital_signature) {
            abort(404, 'Document not found');
        }

        $user = \App\Models\User::find($employeeLeave->employee_id);
        
        // Create simple HTML for PDF conversion
        $html = '
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Leave Request</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .info-table { width: 100%; border-collapse: collapse; }
                .info-table td { padding: 10px; border: 1px solid #ddd; }
                .label { font-weight: bold; background-color: #f5f5f5; width: 30%; }
            </style>
        </head>
        <body>
            <div class="header">
                <h2>LEAVE REQUEST FORM</h2>
                <p>Request ID: #' . $employeeLeave->id . '</p>
            </div>
            
            <table class="info-table">
                <tr>
                    <td class="label">Employee Name:</td>
                    <td>' . ($user->name ?? 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">Username:</td>
                    <td>' . ($user->username ?? 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">Leave Type:</td>
                    <td>' . ($employeeLeave->leave->name ?? 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">From Date:</td>
                    <td>' . ($employeeLeave->from_date ? $employeeLeave->from_date->format('d/m/Y') : 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">To Date:</td>
                    <td>' . ($employeeLeave->to_date ? $employeeLeave->to_date->format('d/m/Y') : 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">Note:</td>
                    <td>' . ($employeeLeave->note ?: 'None') . '</td>
                </tr>
                <tr>
                    <td class="label">Status:</td>
                    <td><strong>' . strtoupper($employeeLeave->status ?? 'pending') . '</strong></td>
                </tr>
                <tr>
                    <td class="label">Created:</td>
                    <td>' . ($employeeLeave->created_at ? $employeeLeave->created_at->format('d/m/Y H:i') : 'N/A') . '</td>
                </tr>
                <tr>
                    <td class="label">Approved:</td>
                    <td>' . ($employeeLeave->approved_at ? $employeeLeave->approved_at->format('d/m/Y H:i') : 'Not approved') . '</td>
                </tr>
            </table>
            
            <div style="margin-top: 30px; padding: 15px; background-color: #f8f9fa; border: 1px solid #dee2e6;">
                <strong>Digital Signature:</strong><br>
                <small>' . $employeeLeave->digital_signature . '</small>
            </div>
        </body>
        </html>';
        
        return response($html)
            ->header('Content-Type', 'text/html; charset=utf-8')
            ->header('Content-Disposition', 'attachment; filename="leave_request_' . $employeeLeave->id . '.html"');
            
    })->name('leave.download');

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
