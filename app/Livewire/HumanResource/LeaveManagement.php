<?php

namespace App\Livewire\HumanResource;

use App\Models\EmployeeLeave;
use App\Models\Leave;
use App\Models\Employee;
use App\Services\DigitalSignatureService;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;
use Livewire\WithPagination;
use Livewire\Attributes\Rule;

class LeaveManagement extends Component
{
    use WithPagination;

    // Properties
    public $selectedEmployeeId;
    public $leaveTypes = [];
    public $employees = [];
    public $isEdit = false;
    public $employeeLeaveId;
    public $confirmedId;

    #[Rule('required')]
    public $newLeaveInfo = [
        'LeaveId' => '',
        'fromDate' => '',
        'toDate' => '',
        'startAt' => '',
        'endAt' => '',
        'note' => '',
    ];

    // Filter properties
    public $statusFilter = '';
    public $departmentFilter = '';
    public $dateFilter = '';

    protected $paginationTheme = 'bootstrap';

    public function mount()
    {
        $this->leaveTypes = Leave::all();
        $this->employees = Employee::where('is_active', 1)->get();
        
        // Set default employee to current user ID
        $this->selectedEmployeeId = Auth::user()->id;
    }

    public function render()
    {
        $query = EmployeeLeave::with(['employee.department', 'employee.position', 'leave', 'approvedBy', 'reviewer']);

        // Filter by status
        if ($this->statusFilter) {
            $query->where('status', $this->statusFilter);
        }

        // Filter by department
        if ($this->departmentFilter) {
            $query->whereHas('employee.department', function ($q) {
                $q->where('id', $this->departmentFilter);
            });
        }

        // Filter by date
        if ($this->dateFilter) {
            $query->whereDate('created_at', $this->dateFilter);
        }

        // If user is not admin/HR, only show their own requests
        if (!Auth::user()->hasRole(['Admin', 'HR'])) {
            $query->where('employee_id', Auth::user()->id);
        }

        $leaveRequests = $query->orderBy('created_at', 'desc')->paginate(15);

        return view('livewire.human-resource.leave-management', [
            'leaveRequests' => $leaveRequests,
            'departments' => \App\Models\Department::all(),
        ]);
    }

    public function submitLeave()
    {
        // Ensure selectedEmployeeId is always set to current user ID
        $this->selectedEmployeeId = Auth::user()->id;

        $this->validate([
            'newLeaveInfo.LeaveId' => 'required',
            'newLeaveInfo.fromDate' => 'required|date',
            'newLeaveInfo.toDate' => 'required|date',
        ]);

        // Validation logic
        if ($this->validateLeaveRequest()) {
            $this->isEdit ? $this->updateLeave() : $this->createLeave();
        }
    }

    protected function validateLeaveRequest()
    {
        // Check date range
        if ($this->newLeaveInfo['fromDate'] > $this->newLeaveInfo['toDate']) {
            session()->flash('error', 'Ngày bắt đầu không thể lớn hơn ngày kết thúc!');
            return false;
        }

        return true;
    }

    public function createLeave()
    {
        $employeeLeave = EmployeeLeave::create([
            'employee_id' => $this->selectedEmployeeId,
            'leave_id' => $this->newLeaveInfo['LeaveId'],
            'from_date' => $this->newLeaveInfo['fromDate'],
            'to_date' => $this->newLeaveInfo['toDate'],
            'note' => $this->newLeaveInfo['note'],
            'status' => 'pending',
            'workflow_status' => 'submitted',
            'created_by' => Auth::user()->name,
        ]);

        // Auto-assign reviewer (head of department) - Disabled for simplicity
        // $this->assignReviewer($employeeLeave);

        session()->flash('success', 'Đơn nghỉ phép đã được tạo thành công!');
        $this->reset('newLeaveInfo');
        $this->dispatch('closeModal', elementId: '#leaveModal');
    }

    public function updateLeave()
    {
        $employeeLeave = EmployeeLeave::find($this->employeeLeaveId);
        
        if ($employeeLeave) {
            $employeeLeave->update([
                'leave_id' => $this->newLeaveInfo['LeaveId'],
                'from_date' => $this->newLeaveInfo['fromDate'],
                'to_date' => $this->newLeaveInfo['toDate'],
                'note' => $this->newLeaveInfo['note'],
                'workflow_status' => 'submitted',
            ]);
        }

        session()->flash('success', 'Đơn nghỉ phép đã được cập nhật thành công!');
        $this->reset('newLeaveInfo', 'isEdit');
        $this->dispatch('closeModal', elementId: '#leaveModal');
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

            $digitalSignatureService = new DigitalSignatureService();
            $digitalSignatureService->signLeaveRequest($employeeLeave, Auth::user());

            session()->flash('success', 'Đơn nghỉ phép đã được phê duyệt và ký số thành công!');
            
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

        // Head of department có thể phê duyệt đơn (simplified logic)
        if ($user->hasRole(['Head of Department'])) {
            return true;
        }

        return false;
    }

    public function exportSignedPDF($leaveId)
    {
        try {
            $employeeLeave = EmployeeLeave::findOrFail($leaveId);
            
            if (!$employeeLeave->digital_signature) {
                session()->flash('error', 'Đơn nghỉ phép chưa được ký số!');
                return;
            }

            $digitalSignatureService = new DigitalSignatureService();
            return $digitalSignatureService->exportSignedPDF($employeeLeave);
            
        } catch (\Exception $e) {
            session()->flash('error', 'Có lỗi xảy ra khi xuất PDF: ' . $e->getMessage());
        }
    }

    public function showCreateLeaveModal()
    {
        $this->reset('newLeaveInfo', 'isEdit');
        
        // Always set to current user ID
        $this->selectedEmployeeId = Auth::user()->id;
        
        $this->dispatch('clearSelect2Values');
    }

    public function showEditLeaveModal($id)
    {
        $this->reset('newLeaveInfo');
        $this->isEdit = true;
        $this->employeeLeaveId = $id;

        $record = EmployeeLeave::where('id', $id)
            ->where('employee_id', Auth::user()->id)
            ->first();
            
        if ($record) {
            $this->selectedEmployeeId = $record->employee_id;
            $this->newLeaveInfo = [
                'LeaveId' => $record->leave_id,
                'fromDate' => $record->from_date->format('Y-m-d'),
                'toDate' => $record->to_date->format('Y-m-d'),
                'note' => $record->note,
            ];
        } else {
            session()->flash('error', 'Bạn chỉ có thể chỉnh sửa đơn nghỉ phép của chính mình!');
        }
    }

    public function confirmDeleteLeave($id)
    {
        $this->confirmedId = $id;
    }

    public function deleteLeave($id)
    {
        $employeeLeave = EmployeeLeave::where('id', $id)
            ->where('employee_id', Auth::user()->id)
            ->first();
        
        if ($employeeLeave && $employeeLeave->status === 'pending') {
            $employeeLeave->delete();
            session()->flash('success', 'Đơn nghỉ phép đã được xóa!');
        } elseif ($employeeLeave) {
            session()->flash('error', 'Không thể xóa đơn nghỉ phép đã được phê duyệt!');
        } else {
            session()->flash('error', 'Bạn chỉ có thể xóa đơn nghỉ phép của chính mình!');
        }
        
        $this->confirmedId = null;
    }

    public function resetFilters()
    {
        $this->reset(['statusFilter', 'departmentFilter', 'dateFilter']);
    }
}
