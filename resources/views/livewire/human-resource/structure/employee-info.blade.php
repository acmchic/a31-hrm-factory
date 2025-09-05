<div>

@php
  $configData = Helper::appClasses();
@endphp

@section('title', 'Thông tin quân nhân')

@section('page-style')
  <style>
    .timeline-icon {
      cursor: pointer;
      opacity: 0;
    }

    .timeline-row:hover .timeline-icon {
      display: inline-block;
      opacity: 1;
    }
  </style>

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

{{-- Alerts --}}
@include('_partials/_alerts/alert-general')

@if($employee)
<div class="row">
  <div class="col-12">
    <div class="card mb-4">
      {{-- <div class="user-profile-header-banner">
        <img src="{{ asset('assets/img/pages/profile-banner.png') }}" alt="Banner image" class="rounded-top">
      </div> --}}
      <div class="user-profile-header d-flex flex-column flex-sm-row text-sm-start text-center mb-4">
        <div class="flex-shrink-0 mt-n2 mx-sm-0 mx-auto">
          <div class="d-block h-auto ms-0 ms-sm-4 rounded user-profile-img bg-label-primary d-flex align-items-center justify-content-center" style="width: 100px; height: 100px;">
            <h2 class="text-white m-0">{{ substr($employee->name, 0, 2) }}</h2>
          </div>
        </div>
        <div class="flex-grow-1 mt-3 mt-sm-5">
          <div class="d-flex align-items-md-end align-items-sm-start align-items-center justify-content-md-between justify-content-start mx-4 flex-md-row flex-column gap-4">
            <div class="user-profile-info">
              <h4>{{ $employee->name }}</h4>
               <ul class="list-inline mb-0 d-flex align-items-center flex-wrap justify-content-sm-start justify-content-center gap-2">
                 <li class="list-inline-item">
                   <span class="badge rounded-pill bg-label-primary"><i class="ti ti-id"></i> {{ $employee->id }}</span>
                 </li>
                 @if($employee->department)
                 <li class="list-inline-item">
                   <i class="ti ti-building-community"></i> {{ $employee->department->name }}
                 </li>
                 @endif
                 @if($employee->position)
                 <li class="list-inline-item">
                   <i class="ti ti-map-pin"></i> {{ $employee->position->name }}
                 </li>
                 @endif
                 @if($employee->enlist_date)
                 <li class="list-inline-item">
                   <i class="ti ti-rocket"></i> {{ 'Ngày nhập ngũ: ' . $employee->enlist_date->format('d/m/Y') }}
                 </li>
                 @endif
                 @if($employee->start_date)
                 <li class="list-inline-item">
                   <i class="ti ti-player-track-next"></i> {{ 'Ngày bắt đầu: ' . $employee->start_date->format('d/m/Y') }}
                 </li>
                 @endif
               </ul>
            </div>
            <button wire:click='toggleActive' type="button" class="btn @if ($employee->is_active == 1)  btn-success @else btn-danger  @endif waves-effect waves-light">
              <span class="ti @if ($employee->is_active == 1) ti-user-check @else ti-user-x @endif me-1"></span>
              @if ($employee->is_active == 1) {{ 'Đang làm' }} @else {{ 'Nghỉ việc' }}  @endif
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
@else
<div class="row">
  <div class="col-12">
    <div class="card">
      <div class="card-body text-center">
        <h4>{{ __('Employee not found') }}</h4>
        <p>{{ __('The employee you are looking for does not exist.') }}</p>
        <a href="{{ route('structure-employees') }}" class="btn btn-primary">{{ __('Back to Employees') }}</a>
      </div>
    </div>
  </div>
</div>
@endif
<!--/ Header -->

<!-- Navbar pills -->
{{-- <div class="row">
  <div class="col-md-12">
    <ul class="nav nav-pills flex-column flex-sm-row mb-4">
      <li class="nav-item"><a class="nav-link active" href="javascript:void(0);"><i class='ti-xs ti ti-user-check me-1'></i> Profile</a></li>
      <li class="nav-item"><a class="nav-link" href="{{url('pages/profile-teams')}}"><i class='ti-xs ti ti-users me-1'></i> Teams</a></li>
      <li class="nav-item"><a class="nav-link" href="{{url('pages/profile-projects')}}"><i class='ti-xs ti ti-layout-grid me-1'></i> Projects</a></li>
      <li class="nav-item"><a class="nav-link" href="{{url('pages/profile-connections')}}"><i class='ti-xs ti ti-link me-1'></i> Connections</a></li>
    </ul>
  </div>
</div> --}}
<!--/ Navbar pills -->

<div class="row">
  {{-- Ẩn phần Tài sản theo yêu cầu --}}

  <!-- Details -->
  <div class="col-xl-4 col-lg-5 col-md-5">
    <div class="card mb-4">
      <div class="card-body">
        <h5 class="card-action-title mb-0">{{ 'Thông tin' }}</h5>
        <ul class="list-unstyled mb-4 mt-3">
          <li class="d-flex align-items-center mb-3"><i class="ti ti-home"></i><span class="fw-bold mx-2">{{ 'Địa chỉ' }}:</span> <span>{{ $employee->address ?: '-' }}</span></li>
        </ul>
        <ul class="list-unstyled mb-4 mt-3">
          <li class="d-flex align-items-center mb-3"><i class="ti ti-phone-call"></i><span class="fw-bold mx-2">{{ 'Điện thoại' }}:</span> <span style="direction: ltr">{{ $employee->phone ?: '-' }}</span></li>
        </ul>
        <ul class="list-unstyled mb-4 mt-3">
          <li class="d-flex align-items-center mb-3"><i class="ti ti-id"></i><span class="fw-bold mx-2">{{ 'CCCD' }}:</span> <span>{{ $employee->CCCD ?: '-' }}</span></li>
        </ul>
        @if($employee->enlist_date)
        <ul class="list-unstyled mb-4 mt-3">
          <li class="d-flex align-items-center mb-3"><i class="ti ti-rocket"></i><span class="fw-bold mx-2">{{ 'Ngày nhập ngũ' }}:</span> <span>{{ $employee->enlist_date->format('d/m/Y') }}</span></li>
        </ul>
        @endif
        @if($employee->date_of_birth)
        <ul class="list-unstyled mb-4 mt-3">
          <li class="d-flex align-items-center mb-3"><i class="ti ti-calendar"></i><span class="fw-bold mx-2">{{ 'Ngày sinh' }}:</span> <span>{{ $employee->date_of_birth->format('d/m/Y') }}</span></li>
        </ul>
        @endif

        <h5 class="card-action-title mb-0">{{ 'Nghỉ phép' }}</h5>
        <ul class="list-unstyled mb-0 mt-3">
          <li class="d-flex align-items-center mb-3"><i class="ti ti-calendar"></i><span class="fw-bold mx-2">{{ 'Số dư ngày phép' }}:</span> <span class="badge bg-label-secondary">{{ $employee->annual_leave_balance }}</span></li>
          <li class="d-flex align-items-center mb-3"><i class="ti ti-calendar-up"></i><span class="fw-bold mx-2">{{ 'Ngày phép đã dùng' }}:</span> <span class="badge bg-label-secondary">{{ $employee->annual_leave_used }}</span></li>
        </ul>
      </div>
    </div>
  </div>
  <!--/ Details -->

  <!-- Timeline -->
  <div class="col-xl-8 col-lg-7 col-md-7">
    <div class="card card-action mb-4">
      <div class="card-header align-items-center">
        <h5 class="card-action-title mb-0">{{ 'Quá trình công tác' }}</h5>
        <div class="card-action-element">
          <div class="dropdown">
            <button type="button" class="btn dropdown-toggle hide-arrow p-0" data-bs-toggle="dropdown" aria-expanded="false"><i class="ti ti-dots-vertical text-muted"></i></button>
            <ul class="dropdown-menu dropdown-menu-end">
              <li>
                <a wire:click='showStoreTimelineModal()' class="dropdown-item" data-bs-toggle="modal" data-bs-target="#timelineModal">{{ 'Thêm mốc công tác' }}</a>
              </li>
              {{-- <li><a class="dropdown-item" href="javascript:void(0);">Edit timeline</a></li> --}}
            </ul>
          </div>
        </div>
      </div>
      <div class="card-body pb-0">
        <ul class="timeline ms-1 mb-0">
          @foreach ($employeeTimelines as $timeline)
            <li class="timeline-item timeline-item-transparent @if ($loop->last) border-0 @endif">
              <span class="timeline-point @if ($loop->first) timeline-point-primary @else timeline-point-info @endif"></span>
              <div class="timeline-event">
                <div class="timeline-header">
                  <div class="timeline-row d-flex m-0">
                    <h6 class="m-0">{{ $timeline->position->name }}</h6>
                    <i wire:click='setPresentTimeline({{ $timeline }})' class="timeline-icon text-success ti ti-refresh mx-1"></i>
                    <i wire:click='showUpdateTimelineModal({{ $timeline }})' class="timeline-icon text-info ti ti-edit" data-bs-toggle="modal" data-bs-target="#timelineModal"></i>
                    <i wire:click='confirmDeleteTimeline({{ $timeline }})' class="timeline-icon text-danger ti ti-trash mx-1"></i>
                    @if ($confirmedId === $timeline->id)
                      <button wire:click.prevent='deleteTimeline({{ $timeline }})' type="button"
                        class="btn btn-xs btn-danger waves-effect waves-light mx-1">{{ __('Sure?') }}
                      </button>
                    @endif
                  </div>
                  <small class="text-muted">@if ($timeline->end_date == null) {{ __('Present') }} @else {{ $timeline->start_date }} --> {{ $timeline->end_date }} @endif</small>
                </div>
                <p class="mb-2">{{ $timeline->employee?->department?->name ?? '-' }}</p>
              </div>
            </li>
          @endforeach
        </ul>
      </div>
    </div>
  </div>
  <!--/ Timeline -->
</div>

{{-- Modal --}}
@include('_partials._modals.modal-timeline')

{{-- Scripts --}}
@push('custom-scripts')
  @if(session('openTimelineModal'))
    <script>
      document.addEventListener('DOMContentLoaded', function () {
          $('#timelineModal').modal('show');
      });
    </script>
  @endif
@endpush
</div>

</div>
