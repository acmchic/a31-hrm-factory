<?php

namespace App\Livewire\HumanResource\Attendance;

use App\Exports\ExportLeaves;
use App\Imports\ImportLeaves;
use App\Livewire\Sections\Navbar\Navbar;
use App\Models\Center;
use App\Models\Employee;
use App\Models\EmployeeLeave;
use App\Models\Leave;
use App\Notifications\DefaultNotification;
use Carbon\Carbon;
use Exception;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Notification;
use Illuminate\Pagination\LengthAwarePaginator;
use Livewire\Component;
use Livewire\WithFileUploads;
use Livewire\WithPagination;
use Maatwebsite\Excel\Facades\Excel;

class Leaves extends Component
{
    use WithFileUploads, WithPagination;

    /*
                Leave ID Structure:
                1 Leave - 1 Daily  - LeaveID
                2 Task  - 2 Hourly - LeaveID
                */

    // 👉 Variables
    public $activeEmployees = [];
    public $employees = [];

    public $selectedEmployee;

    public $selectedEmployeeId;

    public $dateRange;

    public $fromDate;

    public $toDate;

    public $employeeLeaveId;

    public $newLeaveInfo = [
        'LeaveId' => '',
        'fromDate' => null,
        'toDate' => null,
        'startAt' => null,
        'endAt' => null,
        'note' => null,
    ];

    public $isEdit = false;

    public $leaveTypes;

    public $selectedLeave;

    public $selectedLeaveId;

    public $confirmedId;

    public $file;
    
    public $rejection_reason;

    public function mount()
    {
        $this->selectedEmployeeId = Auth::user()->id;
        $this->selectedEmployee = Auth::user(); // Use current user as selected employee

        $this->leaveTypes = Leave::all();
        $this->employees = Employee::where('is_active', 1)->get();

        // Simplified logic - no need for complex timeline/center logic
        $this->activeEmployees = collect([Auth::user()]); // Just current user

        $currentDate = Carbon::now();
        $previousMonth = $currentDate->copy()->subMonth();
        $this->dateRange = $previousMonth->format('Y-n-1').' to '.$currentDate;
    }

    public function render()
    {
        $leaves = $this->applyFilter();

        return view('livewire.human-resource.attendance.leaves', [
            'leaves' => $leaves,
            'employees' => $this->employees,
            'leaveTypes' => $this->leaveTypes,
        ]);
    }

    public function applyFilter()
    {
        // Use current user as selected employee
        $this->selectedEmployee = Auth::user();

        $this->selectedLeave = Leave::find($this->selectedLeaveId);

        if ($this->dateRange) {
            $dates = explode(' to ', $this->dateRange);

            $this->fromDate = $dates[0];
            $this->toDate = $dates[1];
        }

        // Get leaves based on user role
        $user = Auth::user();
        
        $query = EmployeeLeave::with(['leave', 'employee'])
            ->when($this->selectedLeaveId, function ($query) {
                return $query->where('leave_id', $this->selectedLeaveId);
            })
            ->whereBetween('from_date', [$this->fromDate, $this->toDate])
            ->orderBy('from_date');

        if ($user->hasAnyRole(['Admin', 'HR'])) {
            // Admin/HR can see all leaves
            // No additional filter needed
        } elseif ($user->hasAnyRole(['Head of Department', 'CC'])) {
            // Department heads can see leaves from their department + own leaves
            $userDepartment = Employee::where('name', $user->name)->first()?->department_id;
            if ($userDepartment) {
                $query->where(function($q) use ($user, $userDepartment) {
                    $q->where('employee_id', $user->id) // Own leaves
                      ->orWhereHas('employee', function($eq) use ($userDepartment) {
                          $eq->where('department_id', $userDepartment);
                      });
                });
            } else {
                $query->where('employee_id', $user->id); // Only own leaves
            }
        } else {
            // Regular employees only see their own leaves
            $query->where('employee_id', $user->id);
        }

        // If not admin/HR, only show unchecked leaves
        if (!$user->hasAnyRole(['Admin', 'HR'])) {
            $query->where('is_checked', 0);
        }

        return $query->paginate(7);
    }

    public function submitLeave()
    {
        // Ensure selectedEmployeeId is always set to current user ID
        $this->selectedEmployeeId = Auth::user()->id;

        $this->validate(
            [
                'newLeaveInfo.LeaveId' => 'required',
                'newLeaveInfo.fromDate' => 'required|date',
                'newLeaveInfo.toDate' => 'required|date',
            ],
            null,
            [
                'newLeaveInfo.LeaveId' => 'Type',
                'newLeaveInfo.fromDate' => 'From Date',
                'newLeaveInfo.toDate' => 'To Date',
            ]
        );

        if (
            substr($this->newLeaveInfo['LeaveId'], 1, 1) == 1 &&
            ($this->newLeaveInfo['startAt'] != null || $this->newLeaveInfo['endAt'] != null)
        ) {
            session()->flash('error', __('Can\'t add daily leave with time!'));
            $this->dispatch('closeModal', elementId: '#leaveModal');
            $this->dispatch('toastr', type: 'error' /* , title: 'Done!' */, message: __('Requires Attention!'));

            return;
        }

        if (
            substr($this->newLeaveInfo['LeaveId'], 1, 1) == 2 &&
            ($this->newLeaveInfo['startAt'] == null || $this->newLeaveInfo['endAt'] == null)
        ) {
            session()->flash('error', __('Can\'t add hourly leave without time!'));
            $this->dispatch('closeModal', elementId: '#leaveModal');
            $this->dispatch('toastr', type: 'error' /* , title: 'Done!' */, message: __('Requires Attention!'));

            return;
        }

        if (
            substr($this->newLeaveInfo['LeaveId'], 1, 1) == 2 &&
            $this->newLeaveInfo['fromDate'] != $this->newLeaveInfo['toDate'] &&
            $this->newLeaveInfo['LeaveId'] != '1210'
        ) {
            session()->flash('error', __('Hourly leave must be on the same day!'));
            $this->dispatch('closeModal', elementId: '#leaveModal');
            $this->dispatch('toastr', type: 'error' /* , title: 'Done!' */, message: __('Requires Attention!'));

            return;
        }

        if ($this->newLeaveInfo['fromDate'] > $this->newLeaveInfo['toDate']) {
            session()->flash('error', __('Check the dates entered. "From Date" cannot be greater than "To Date"'));
            $this->dispatch('closeModal', elementId: '#leaveModal');
            $this->dispatch('toastr', type: 'error' /* , title: 'Done!' */, message: __('Requires Attention!'));

            return;
        }

        if ($this->newLeaveInfo['startAt'] > $this->newLeaveInfo['endAt']) {
            session()->flash('error', __('Check the times entered. "Start At" cannot be greater than "End To"'));
            $this->dispatch('closeModal', elementId: '#leaveModal');
            $this->dispatch('toastr', type: 'error' /* , title: 'Done!' */, message: __('Requires Attention!'));

            return;
        }

        $this->isEdit ? $this->updateLeave() : $this->createLeave();
    }

    public function showCreateLeaveModal()
    {
        $this->dispatch('clearSelect2Values');
        $this->reset('isEdit', 'newLeaveInfo');
        
        // Always set to current user ID
        $this->selectedEmployeeId = Auth::user()->id;
    }

    public function createLeave()
    {
        $employeeLeave = EmployeeLeave::create([
            'employee_id' => $this->selectedEmployeeId,
            'leave_id' => $this->newLeaveInfo['LeaveId'],
            'from_date' => $this->newLeaveInfo['fromDate'],
            'to_date' => $this->newLeaveInfo['toDate'],
            'start_at' => $this->newLeaveInfo['startAt'],
            'end_at' => $this->newLeaveInfo['endAt'],
            'note' => $this->newLeaveInfo['note'],
            'status' => 'pending',
            'workflow_status' => 'submitted',
            'rejection_reason' => null,
            'approved_by' => null,
            'approved_at' => null,
            'created_by' => Auth::user()->name,
        ]);

        // Auto-assign reviewer (head of department) - Disabled for simplicity
        // $this->assignReviewer($employeeLeave);

        session()->flash('success', __('Success, record created successfully!'));
        $this->dispatch('scrollToTop');

        $this->dispatch('closeModal', elementId: '#leaveModal');
        $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));
    }

    public function showUpdateLeaveModal($id)
    {
        $this->reset('newLeaveInfo');

        $this->isEdit = true;
        $this->employeeLeaveId = $id;

        $record = EmployeeLeave::find($this->employeeLeaveId);

        if ($record) {
            $this->selectedEmployeeId = $record->employee_id;
            $this->newLeaveInfo = [
                'LeaveId' => $record->leave_id,
                'fromDate' => $record->from_date,
                'toDate' => $record->to_date,
                'startAt' => $record->start_at,
                'endAt' => $record->end_at,
                'note' => $record->note,
            ];

            $this->dispatch('setSelect2Values', employeeId: $this->selectedEmployeeId, leaveId: $record->leave_id);
        }
    }

    public function updateLeave()
    {
        $employeeLeave = EmployeeLeave::find($this->employeeLeaveId);
        if ($employeeLeave) {
            $employeeLeave->update([
                'employee_id' => $this->selectedEmployeeId,
                'leave_id' => $this->newLeaveInfo['LeaveId'],
                'from_date' => $this->newLeaveInfo['fromDate'],
                'to_date' => $this->newLeaveInfo['toDate'],
                'start_at' => $this->newLeaveInfo['startAt'],
                'end_at' => $this->newLeaveInfo['endAt'],
                'note' => $this->newLeaveInfo['note'],
                'workflow_status' => 'submitted',
                'status' => 'pending',
                'rejection_reason' => null,
                'approved_by' => null,
                'approved_at' => null,
                'updated_by' => Auth::user()->name,
            ]);

            // Re-assign reviewer if employee changed
            if ($employeeLeave->employee_id != $this->selectedEmployeeId) {
                $this->assignReviewer($employeeLeave);
            }
        }

        session()->flash('success', __('Success, record updated successfully!'));
        $this->dispatch('scrollToTop');

        $this->dispatch('closeModal', elementId: '#leaveModal');
        $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));

        $this->reset('isEdit', 'newLeaveInfo');
    }

    public function confirmDestroyLeave($id)
    {
        $this->confirmedId = $id;
    }

    public function destroyLeave()
    {
        $employeeLeave = EmployeeLeave::find($this->confirmedId);
        if ($employeeLeave) {
            $employeeLeave->delete();
            $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));
        }
        $this->confirmedId = null;
    }

    protected function assignReviewer(EmployeeLeave $employeeLeave)
    {
        $employee = $employeeLeave->employee;
        if ($employee && $employee->department_id) {
            // Find head of department
            $headOfDepartment = Employee::where('department_id', $employee->department_id)
                ->whereHas('position', function ($q) {
                    $q->where('name', 'like', '%trưởng phòng%');
                })
                ->first();

            if ($headOfDepartment) {
                // Find user by employee name or ID
                $reviewerUser = \App\Models\User::where('name', $headOfDepartment->name)
                    ->orWhere('id', $headOfDepartment->id)
                    ->first();

                if ($reviewerUser) {
                    $employeeLeave->update([
                        'reviewer_id' => $reviewerUser->id,
                        'workflow_status' => 'under_review',
                        'approved_by' => null,
                        'approved_at' => null,
                        'rejection_reason' => null,
                    ]);
                }
            }
        }
    }

    public function approveLeave($leaveId)
    {
        try {
            $employeeLeave = EmployeeLeave::findOrFail($leaveId);
            
            // Check if user can approve
            if (!$this->canApproveLeave($employeeLeave)) {
                session()->flash('error', 'Bạn không có quyền phê duyệt đơn nghỉ phép này!');
                return;
            }

            // Use digital signature service if available
            if (class_exists('\App\Services\DigitalSignatureService')) {
                $digitalSignatureService = new \App\Services\DigitalSignatureService();
                $digitalSignatureService->signLeaveRequest($employeeLeave, Auth::user());
            } else {
                // Simple approval without digital signature
                $employeeLeave->update([
                    'status' => 'approved',
                    'workflow_status' => 'approved',
                    'approved_by' => Auth::user()->id,
                    'approved_at' => now(),
                ]);
            }

            session()->flash('success', 'Đơn nghỉ phép đã được phê duyệt thành công!');
            
        } catch (\Exception $e) {
            session()->flash('error', 'Có lỗi xảy ra khi phê duyệt: ' . $e->getMessage());
        }
    }

    public function rejectLeave($leaveId)
    {
        $this->validate([
            'rejection_reason' => 'required|min:10',
        ]);

        $employeeLeave = EmployeeLeave::findOrFail($leaveId);
        
        if (!$this->canApproveLeave($employeeLeave)) {
            session()->flash('error', 'Bạn không có quyền từ chối đơn nghỉ phép này!');
            return;
        }

        $employeeLeave->update([
            'status' => 'rejected',
            'workflow_status' => 'rejected',
            'rejection_reason' => $this->rejection_reason,
            'reviewer_id' => Auth::user()->id,
            'reviewed_at' => now(),
        ]);

        session()->flash('success', 'Đơn nghỉ phép đã bị từ chối!');
        $this->reset('rejection_reason');
    }

    protected function canApproveLeave(EmployeeLeave $employeeLeave)
    {
        $user = Auth::user();
        
        // Admin và HR có thể phê duyệt tất cả
        if ($user->hasRole(['Admin', 'HR'])) {
            return true;
        }

        // Head of department có thể phê duyệt đơn của nhân viên trong phòng mình
        if ($user->hasRole(['Head of Department', 'CC'])) {
            $userDepartment = Employee::where('name', $user->name)->first()?->department_id;
            $leaveDepartment = $employeeLeave->employee?->department_id;
            
            if ($userDepartment && $userDepartment == $leaveDepartment) {
                return true;
            }
        }

        return false;
    }

    public function viewLeaveDetail($leaveId)
    {
        // Method placeholder for view detail action
        // Modal will be opened via data-bs-target
    }

    public function exportSignedPDF($leaveId)
    {
        try {
            $employeeLeave = EmployeeLeave::findOrFail($leaveId);
            
            if (!$employeeLeave->digital_signature) {
                session()->flash('error', 'Don nghi phep chua duoc ky so!');
                return;
            }

            // Redirect to download route
            return redirect()->route('leave.download', ['id' => $leaveId]);
            
        } catch (\Exception $e) {
            session()->flash('error', 'Co loi xay ra khi xuat file: ' . $e->getMessage());
        }
    }

    public function importFromExcel()
    {
        $this->validate(
            [
                'file' => 'required|mimes:xlsx',
            ],
            [
                'file.required' => 'Please select a file to upload',
                'file.mimes' => 'Excel files is accepted only',
            ]
        );

        try {
            Excel::import(new ImportLeaves(), $this->file);

            Notification::send(
                Auth::user(),
                new DefaultNotification(Auth::user()->id, 'Successfully imported the leaves file')
            );
            $this->dispatch('refreshNotifications')->to(Navbar::class);

            session()->flash('success', __('Well done! The file has been imported successfully.'));
        } catch (Exception $e) {
            session()->flash('error', __('Error occurred: ').$e->getMessage());
        }

        $this->dispatch('closeModal', elementId: '#importModal');
    }

    public function exportToExcel()
    {
        $user = Employee::find(Auth::user()->employee_id);
        
        if ($user) {
            $currentTimeline = $user->timelines()->where('end_date', null)->first();
            
            if ($currentTimeline && $currentTimeline->center_id) {
                $center = Center::find($currentTimeline->center_id);
                if ($center) {
                    $this->activeEmployees = $center->activeEmployees();
                } else {
                    $this->activeEmployees = collect();
                }
            } else {
                $this->activeEmployees = collect();
            }
        } else {
            $this->activeEmployees = collect();
        }

        $centerEmployees = array_map(function ($object) {
            return $object['id'];
        }, $this->activeEmployees->toArray());

        $firstName = explode(' ', Auth::user()->name)[0];

        $leavesToExport = DB::table('employee_leave')
            ->select([
                'employee_leave.id AS ID',
                DB::raw('employees.name AS Employee'),
                'leaves.name AS Leave',
                'employee_leave.from_date AS From Date',
                'employee_leave.to_date AS To Date',
                'employee_leave.start_at AS Start At',
                'employee_leave.end_at AS End At',
                'employee_leave.note AS Note',
                'employee_leave.created_by As Created By',
                'employee_leave.updated_by As Updated By',
            ])
            ->leftJoin('employees', 'employee_leave.employee_id', '=', 'employees.id') // Left join for missing employee
            ->leftJoin('leaves', 'employee_leave.leave_id', '=', 'leaves.id') // Left join for missing leave type
            ->whereIn('employee_leave.employee_id', $centerEmployees)
            ->where(
                'employee_leave.created_at',
                '>=',
                Carbon::now()
                    ->subDays(7)
                    ->format('Y-m-d')
            )
            ->where('is_checked', 0)
            ->where(DB::raw('SUBSTRING_INDEX(employee_leave.created_by, " ", 1)'), '=', $firstName)
            ->get();

        session()->flash('success', __('Well done! The file has been exported successfully.'));

        return Excel::download(
            new ExportLeaves($leavesToExport),
            'Leaves - '.
              Auth::user()->name.
              ' - '.
              Carbon::now()
                  ->subDays(7)
                  ->format('Y-m-d').
              ' --- '.
              Carbon::now()->format('Y-m-d').
              '.xlsx'
        );
    }
}
