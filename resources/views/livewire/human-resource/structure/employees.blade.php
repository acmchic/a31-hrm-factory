<div>

@php
  $configData = Helper::appClasses();
@endphp

@section('title', 'Danh sách quân nhân')

@section('page-style')
  <style>
    .btn-tr {
      opacity: 0;
    }

    tr:hover .btn-tr {
      display: inline-block;
      opacity: 1;
    }

    tr:hover .td {
      color: #7367f0 !important;
    }
  </style>
@endsection

<div class="card">
  <div class="card-header d-flex align-items-center justify-content-between flex-wrap gap-2">
    <h5 class="card-title m-0 me-2">{{ 'Danh sách quân nhân' }}</h5>
    <div class="d-flex align-items-center gap-2">
      <div class="me-2" style="min-width:260px">
        <input wire:model.live="searchTerm" autofocus type="text" class="form-control" placeholder="Tìm (ID, Họ tên, Phòng ban, Chức vụ)">
      </div>
      <button wire:click='showCreateEmployeeModal' type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#employeeModal">
        <span class="ti-xs ti ti-plus me-1"></span>{{ 'Thêm mới' }}
      </button>
    </div>
  </div>

  <div class="card-body pt-0">
    <div class="row g-3 mb-2">
      <div class="col-md-4">
        <div class="card bg-label-primary h-100">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted small">Tổng số quân nhân</div>
              <div class="h4 m-0">{{ $totalEmployees }}</div>
            </div>
            <i class="ti ti-users h3 m-0"></i>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card bg-label-success h-100">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted small">Số người làm việc</div>
              <div class="h4 m-0">{{ $activeEmployees }}</div>
            </div>
            <i class="ti ti-user-check h3 m-0"></i>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card bg-label-warning h-100" style="cursor:pointer" wire:click="openTodayLeaveModal">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted small">Nghỉ phép</div>
              <div class="h4 m-0">{{ $onDayLeave }}</div>
            </div>
            <i class="ti ti-calendar h3 m-0"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="table-responsive text-nowrap">
    <table class="table">
             <thead>
         <tr>
           <th class="col-4">{{ __('Họ và tên') }}</th>
           <th class="col-2">{{ __('Phòng ban') }}</th>
           <th class="col-2">{{ __('Chức vụ') }}</th>
           <th class="col-2">{{ __('Cấp bậc') }}</th>
           <th class="col-2">{{ __('Actions') }}</th>
         </tr>
       </thead>
       <tbody class="table-border-bottom-0">
         @forelse($employees as $employee)
         <tr>
           <td>
             <ul class="list-unstyled users-list m-0 avatar-group d-flex align-items-center">
               <li class="avatar avatar-xs pull-up">
                 <a href="{{ route('structure-employees-info', $employee->id) }}">
                   {{ $employee->name }}
                 </a>
               </li>
             </ul>
           </td>
           <td>
            @php $deptName = $employee->department->name ?? ($employee->department_name ?? ($departmentMap[$employee->department_id] ?? null)); @endphp
            @if($deptName)
              <span class="badge bg-label-info">{{ $deptName }}</span>
            @else
              <span class="text-muted">-</span>
            @endif
           </td>
           <td>
             @if($employee->position)
               @php
                 $positionName = strtolower($employee->position->name);
                 $badgeClass = 'bg-label-secondary'; // Mặc định
                 
                 if ((strpos($positionName, 'giám đốc') !== false && strpos($positionName, 'phó') === false) || strpos($positionName, 'chính uỷ') !== false || strpos($positionName, 'chinh uy') !== false) {
                     $badgeClass = 'bg-label-danger'; // Đỏ - Giám đốc, Chính uỷ
                 } elseif (strpos($positionName, 'phó giám đốc') !== false) {
                     $badgeClass = 'bg-label-warning'; // Vàng - Phó Giám đốc
                 } elseif (strpos($positionName, 'trưởng phòng') !== false) {
                     $badgeClass = 'bg-label-primary'; // Xanh dương - Trưởng phòng
                 }
               @endphp
               <span class="badge {{ $badgeClass }}">{{ $employee->position->name }}</span>
             @else
               <span class="text-muted">-</span>
             @endif
           </td>
           <td>
             @if($employee->rank_code)
               @php
                 $rankCode = $employee->rank_code;
                 $badgeClass = 'bg-label-secondary'; // Mặc định
                 
                 if (strpos($rankCode, '//') !== false) {
                     $badgeClass = 'bg-label-danger'; // Đỏ - Cấp tá
                 } elseif (strpos($rankCode, '/') !== false && strpos($rankCode, '//') === false) {
                     $badgeClass = 'bg-label-warning'; // Vàng - Cấp uy
                 }
               @endphp
               <span class="badge {{ $badgeClass }}">{{ $employee->rank_code }}</span>
             @else
               <span class="text-muted">-</span>
             @endif
           </td>
          <td>
            <button type="button" class="btn btn-sm btn-tr rounded-pill btn-icon btn-outline-secondary waves-effect">
              <span wire:click='showEditEmployeeModal({{ $employee }})' data-bs-toggle="modal" data-bs-target="#employeeModal" class="ti ti-pencil"></span>
            </button>
            <button type="button" class="btn btn-sm btn-tr rounded-pill btn-icon btn-outline-danger waves-effect">
              <span wire:click.prevent='confirmDeleteEmployee({{ $employee->id }})' class="ti ti-trash"></span>
            </button>
            @if ($confirmedId === $employee->id)
            <button wire:click.prevent='deleteEmployee({{ $employee }})' type="button" class="btn btn-sm btn-danger waves-effect waves-light">{{ __('Sure?') }}</button>
          @endif
          </td>
        </tr>
        @empty
        <tr>
          <td colspan="5">
            <div class="mt-2 mb-2" style="text-align: center">
                <h3 class="mb-1 mx-2">{{ __('Oopsie-doodle!') }}</h3>
                <p class="mb-4 mx-2">
                  {{ __('No data found, please sprinkle some data in my virtual bowl, and let the fun begin!') }}
                </p>
                <button class="btn btn-label-primary mb-4" data-bs-toggle="modal" data-bs-target="#employeeModal">
                    {{ __('Add New Employee') }}
                  </button>
                <div>
                  <img src="{{ asset('assets/img/illustrations/page-misc-under-maintenance.png') }}" width="200" class="img-fluid">
                </div>
            </div>
          </td>
        </tr>
        @endforelse
      </tbody>
    </table>
  </div>

  @if ($employees->hasPages())
  <div class="row mt-4">
    <div class="col-12 d-flex justify-content-end">
      {{ $employees->links() }}
    </div>
  </div>
  @endif

</div>

{{-- Modal --}}
@include('_partials/_modals/modal-employee')

<!-- Today Leave Modal -->
<div wire:ignore.self class="modal fade" id="todayLeaveModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-simple">
    <div class="modal-content p-0 p-md-4">
      <div class="modal-body">
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        <div class="text-center mb-3">
          <h3 class="mb-1">Danh sách nghỉ phép hôm nay</h3>
          <p class="text-muted">Theo họ và tên, phòng ban</p>
        </div>
        <div class="table-responsive">
          <table class="table">
            <thead>
              <tr>
                <th>Họ và tên</th>
                <th>Phòng ban</th>
              </tr>
            </thead>
            <tbody>
              @forelse($todayLeaveEmployees as $e)
                <tr>
                  <td>{{ $e['name'] }}</td>
                  <td>{{ $e['department'] }}</td>
                </tr>
              @empty
                <tr>
                  <td colspan="2" class="text-center text-muted">Không có ai nghỉ phép hôm nay</td>
                </tr>
              @endforelse
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

@push('custom-scripts')
<script>
  window.addEventListener('openModal', event => {
    const id = event.detail.elementId;
    if (id) {
      const el = document.querySelector(id);
      if (el) {
        const modal = new bootstrap.Modal(el);
        modal.show();
      }
    }
  });
</script>
@endpush
</div>
