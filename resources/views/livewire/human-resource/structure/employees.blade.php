<div>

@php
  $configData = Helper::appClasses();
@endphp

@section('title', 'Employees - Structure')

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

<div class="demo-inline-spacing">
  <button wire:click='showCreateEmployeeModal' type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#employeeModal">
    <span class="ti-xs ti ti-plus me-1"></span>{{ __('Add New Employee') }}
  </button>
</div>
<br>
<div class="card">
  <div class="card-header d-flex justify-content-between">
    <h5 class="card-title m-0 me-2">{{ __('Employees') }}</h5>
    <div class="col-4">
      <input wire:model.live="searchTerm" autofocus type="text" class="form-control" placeholder="{{ __('Search (ID, Name...)') }}">
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
             @if($employee->department)
               <a href="{{ route('structure-departments-show', $employee->department->id) }}" class="badge bg-label-info text-decoration-none">
                 {{ $employee->department->name }}
               </a>
             @else
               <span class="text-muted">-</span>
             @endif
           </td>
           <td>
             @if($employee->position)
               @php
                 $positionName = strtolower($employee->position->name);
                 $badgeClass = 'bg-label-secondary'; // Mặc định
                 
                 if (strpos($positionName, 'giám đốc') !== false && strpos($positionName, 'phó') === false) {
                     $badgeClass = 'bg-label-danger'; // Đỏ - Giám đốc, Chính ủy
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

  <div class="row mt-4">
    {{ $employees->links() }}
  </div>

</div>

{{-- Modal --}}
@include('_partials/_modals/modal-employee')
</div>
