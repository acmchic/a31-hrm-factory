<?php

namespace App\Livewire\HumanResource\Structure;

use App\Models\Department;
use App\Models\Timeline;
use Livewire\Attributes\Rule;
use Livewire\Component;

class Departments extends Component
{
    // Variables - Start //
    public $departments = [];
    public $selectedDepartment = null;
    public $departmentEmployees = [];
    public $isDetailView = false;

    #[Rule('required')]
    public $name;

    public $department;

    public $isEdit = false;

    public $confirmedId;
    // Variables - End //

    public function mount($id = null)
    {
        if ($id) {
            $this->selectedDepartment = Department::find($id);
            if ($this->selectedDepartment) {
                $this->isDetailView = true;
                $this->loadDepartmentEmployees($id);
            }
        }
    }

    public function loadDepartmentEmployees($departmentId)
    {
        try {
            // Load nhân viên từ timeline active
            $employeesFromTimeline = \App\Models\Employee::whereHas('timelines', function ($query) use ($departmentId) {
                $query->where('department_id', $departmentId)
                      ->whereNull('end_date');
            })->with(['position', 'center'])->get();

            // Nếu không có từ timeline, load trực tiếp từ employee.department_id
            if ($employeesFromTimeline->count() == 0) {
                $this->departmentEmployees = \App\Models\Employee::where('department_id', $departmentId)
                    ->with(['position', 'center'])
                    ->get();
            } else {
                $this->departmentEmployees = $employeesFromTimeline;
            }
        } catch (\Exception $e) {
            // Fallback: load trực tiếp từ employee.department_id
            try {
                $this->departmentEmployees = \App\Models\Employee::where('department_id', $departmentId)
                    ->with(['position', 'center'])
                    ->get();
            } catch (\Exception $e2) {
                $this->departmentEmployees = collect();
            }
        }
    }

    public function render()
    {
        if ($this->isDetailView) {
            return view('livewire.human-resource.structure.departments-detail');
        }

        $this->departments = Department::all();

        return view('livewire.human-resource.structure.departments');
    }

    public function submitDepartment()
    {
        $this->isEdit ? $this->editDepartment() : $this->addDepartment();
    }

    public function addDepartment()
    {
        $this->validate();

        Department::create([
            'name' => $this->name,
        ]);

        $this->dispatch('closeModal', elementId: '#departmentModal');
        $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));
    }

    public function editDepartment()
    {
        $this->validate();

        $this->department->update([
            'name' => $this->name,
        ]);

        $this->dispatch('closeModal', elementId: '#departmentModal');
        $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));

        $this->reset();
    }

    public function confirmDeleteDepartment($id)
    {
        $this->confirmedId = $id;
    }

    public function deleteDepartment(Department $department)
    {
        $department->delete();
        $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));
    }

    public function showNewDepartmentModal()
    {
        $this->reset();
    }

    public function showEditDepartmentModal(Department $department)
    {
        $this->reset();
        $this->isEdit = true;

        $this->department = $department;

        $this->name = $department->name;
    }

    public function getCoordinator($id)
    {
        //
    }

    public function getMembersCount($department_id)
    {
        try {
            // Đếm số nhân viên hiện tại trong phòng ban (có timeline active)
            $activeCount = \App\Models\Employee::whereHas('timelines', function ($query) use ($department_id) {
                $query->where('department_id', $department_id)
                      ->whereNull('end_date');
            })->count();

            // Nếu không có timeline, đếm trực tiếp từ employee.department_id
            if ($activeCount == 0) {
                $directCount = \App\Models\Employee::where('department_id', $department_id)->count();
                \Log::info("Department {$department_id}: Timeline count: {$activeCount}, Direct count: {$directCount}");
                return $directCount;
            }

            \Log::info("Department {$department_id}: Timeline count: {$activeCount}");
            return $activeCount;
        } catch (\Exception $e) {
            \Log::error("Error counting employees for department {$department_id}: " . $e->getMessage());
            // Fallback: đếm trực tiếp từ employee.department_id
            try {
                $directCount = \App\Models\Employee::where('department_id', $department_id)->count();
                \Log::info("Department {$department_id}: Fallback direct count: {$directCount}");
                return $directCount;
            } catch (\Exception $e2) {
                \Log::error("Fallback error for department {$department_id}: " . $e2->getMessage());
                return 0;
            }
        }
    }
}
