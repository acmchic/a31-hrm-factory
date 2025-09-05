<?php

namespace App\Livewire\HumanResource\Structure;

use App\Models\Department;
use App\Models\Employee;
use App\Models\Position;
use App\Models\Timeline;
use Carbon\Carbon;
use Exception;
use Illuminate\Support\Facades\DB;
use Livewire\Component;

class EmployeeInfo extends Component
{
    public $departments;

    public $positions;

    public $employee;

    public $timeline;

    public $employeeTimelines;

    public $employeeTimelineInfo = [];

    public $employeeAssets;

    public $isEdit = false;

    public $confirmedId;

    public $selectedDepartment;

    public $selectedPosition;

    // 👉 Mount
    public function mount($id)
    {
        $this->employee = Employee::find($id);
        
        if ($this->employee) {
            $this->employeeAssets = $this->employee
                ->transitions()
                ->with('asset')
                ->orderBy('handed_date', 'desc')
                ->get();
        } else {
            $this->employeeAssets = collect();
        }
        
        $this->departments = Department::all();
        $this->positions = Position::all();
    }

    // 👉 Render
    public function render()
    {
        if ($this->employee) {
            $this->employeeTimelines = Timeline::with(['department', 'position'])
                ->where('employee_id', $this->employee->id)
                ->orderBy('id', 'desc')
                ->get();
        } else {
            $this->employeeTimelines = collect();
        }

        return view('livewire.human-resource.structure.employee-info');
    }

    // 👉 Toggle active status
    public function toggleActive()
    {
        if (!$this->employee) {
            return;
        }

        $presentTimeline = $this->employee
            ->timelines()
            ->orderBy('timelines.id', 'desc')
            ->first();

        if ($this->employee->is_active == true) {
            $this->employee->is_active = false;
            if ($presentTimeline) {
                $presentTimeline->end_date = Carbon::now();
                $presentTimeline->save();
            }
        } else {
            $this->employee->is_active = true;
            if ($presentTimeline) {
                $presentTimeline->end_date = null;
                $presentTimeline->save();
            }
        }

        $this->employee->save();

        $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));
    }

    // 👉 Submit timeline
    public function submitTimeline()
    {
        $this->employeeTimelineInfo['departmentId'] = $this->selectedDepartment;
        $this->employeeTimelineInfo['positionId'] = $this->selectedPosition;

        $this->validate([
            'employeeTimelineInfo.departmentId' => 'required',
            'employeeTimelineInfo.positionId' => 'required',
            'employeeTimelineInfo.startDate' => 'required',
            'employeeTimelineInfo.isSequent' => 'required',
        ]);

        $this->isEdit ? $this->updateTimeline() : $this->storeTimeline();
    }

    // 👉 Store timeline
    public function showStoreTimelineModal()
    {
        $this->reset('isEdit', 'selectedDepartment', 'selectedPosition', 'employeeTimelineInfo');
        $this->dispatch('clearSelect2Values');
    }

    public function storeTimeline()
    {
        DB::beginTransaction();
        try {
            $presentTimeline = $this->employee
                ->timelines()
                ->orderBy('timelines.id', 'desc')
                ->first();

            if ($presentTimeline) {
                $presentTimeline->end_date = Carbon::now();
                $presentTimeline->save();
            }

            Timeline::create([
                'employee_id' => $this->employee->id,
                'department_id' => $this->employeeTimelineInfo['departmentId'],
                'position_id' => $this->employeeTimelineInfo['positionId'],
                'start_date' => $this->employeeTimelineInfo['startDate'],
                'end_date' => isset($this->employeeTimelineInfo['endDate']) ? $this->employeeTimelineInfo['endDate'] : null,
                'is_sequent' => $this->employeeTimelineInfo['isSequent'],
                'notes' => isset($this->employeeTimelineInfo['notes']) ? $this->employeeTimelineInfo['notes'] : null,
            ]);

            $this->dispatch('closeModal', elementId: '#timelineModal');
            $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));

            DB::commit();
        } catch (Exception $e) {
            DB::rollBack();
            $this->dispatch(
                'toastr',
                type: 'success' /* , title: 'Done!' */,
                message: 'Something is going wrong, check the log file!'
            );
            throw $e;
        }
    }

    // 👉 Update timeline
    public function showUpdateTimelineModal(Timeline $timeline)
    {
        $this->isEdit = true;

        $this->timeline = $timeline;

        $this->employeeTimelineInfo['departmentId'] = $timeline->department_id;
        $this->employeeTimelineInfo['positionId'] = $timeline->position_id;
        $this->employeeTimelineInfo['startDate'] = $timeline->start_date;
        $this->employeeTimelineInfo['endDate'] = $timeline->end_date;
        $this->employeeTimelineInfo['isSequent'] = $timeline->is_sequent;
        $this->employeeTimelineInfo['notes'] = $timeline->notes;

        $this->dispatch(
            'setSelect2Values',
            departmentId: $timeline->department_id,
            positionId: $timeline->position_id
        );
    }

    public function updateTimeline()
    {
        $this->timeline->update([
            'department_id' => $this->employeeTimelineInfo['departmentId'],
            'position_id' => $this->employeeTimelineInfo['positionId'],
            'start_date' => $this->employeeTimelineInfo['startDate'],
            'end_date' => $this->employeeTimelineInfo['endDate'],
            'is_sequent' => $this->employeeTimelineInfo['isSequent'],
            'notes' => $this->employeeTimelineInfo['notes'],
        ]);

        $this->dispatch('closeModal', elementId: '#timelineModal');
        $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));
    }

    // 👉 Delete timeline
    public function confirmDeleteTimeline(Timeline $timeline)
    {
        $this->confirmedId = $timeline->id;
    }

    public function deleteTimeline(Timeline $timeline)
    {
        $timeline->delete();

        $this->dispatch('toastr', type: 'success' /* , title: 'Done!' */, message: __('Going Well!'));
    }

    // 👉 Set present timeline
    public function setPresentTimeline(Timeline $timeline)
    {
        $timeline->end_date = null;
        $timeline->save();

        session()->flash('success', __('The current position assigned successfully.'));
    }
}
