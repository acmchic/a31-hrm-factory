<div>

  @php
    $configData = Helper::appClasses();
    use Carbon\Carbon;
  @endphp

  @section('title', 'Attendance - Leaves')

  @section('vendor-style')
    <link rel="stylesheet" href="{{asset('assets/vendor/libs/flatpickr/flatpickr.css')}}"/>
    <link rel="stylesheet" href="{{asset('assets/vendor/libs/select2/select2.css')}}"/>
  @endsection

  @section('page-style')
    <link rel="stylesheet" href="{{asset('assets/vendor/css/pages/app-calendar.css')}}"/>

    <style>
      tr.disabled {
        opacity: 0.5;
        pointer-events: none;
        text-decoration: line-through;
      }
      tr.disabled i {
          display: none;
      }
    </style>
  @endsection

  {{-- Alerts --}}
  @include('_partials/_alerts/alert-general')

  <div class="card app-calendar-wrapper">
    <div class="row g-0">

      <!-- Sidebar -->
      <div class="col app-calendar-sidebar" id="app-calendar-sidebar">
        <div class="border-bottom p-3 my-sm-0 mb-3">
          <div class="d-grid">
            <div class="sidebar-header">
              <div class="d-flex align-items-center me-3 me-lg-0">
                <div class="col-12">
                  <label class="form-label">{{ __('Employee') }}</label>
                  <div class="alert alert-info d-flex align-items-center">
                    <div class="avatar avatar-sm me-3">
                      <span class="avatar-initial rounded-circle bg-label-primary">
                        {{ substr(auth()->user()->name, 0, 2) }}
                      </span>
                    </div>
                    <div>
                      <h6 class="mb-0">{{ auth()->user()->name }}</h6>
                      <small class="text-muted">ID: {{ auth()->user()->id }}</small>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="border-bottom p-3 my-sm-0 mb-3">
          <div class="col-12">
            <label class="form-label">{{ __('Date Range') }}</label>
            <input wire:model='dateRange' type="text" class="form-control flatpickr-input active"
                   id="flatpickr-range" placeholder="YYYY-MM-DD {{ __('to') }} YYYY-MM-DD" readonly="readonly">
          </div>
        </div>

        <div class="border-bottom p-3 my-sm-0 mb-3">
          <div class="col-12">
            <div wire:ignore class="col-12">
              <label class="form-label">{{ __('Type') }}</label>
              <select wire:model='selectedLeaveId' class="select2 form-control" id="select2selectedLeaveId">
                <option value=""></option>
                @forelse ($leaveTypes as $leaveType)
                  <option value="{{ $leaveType->id }}">{{ $leaveType->name }}</option>
                @empty
                  <option value="0" disabled>{{ __('No Leave Found!') }}</option>
                @endforelse
              </select>
            </div>
          </div>
        </div>

        <div class="row p-5">
          <div class="d-grid gap-2 col-12 mx-auto">
            <button wire:click='applyFilter' class="btn btn-label-primary btn-xl waves-effect waves-light"
                    type="button">{{ __('Apply') }}
            </button>
          </div>
        </div>
      </div>
      <!-- /Sidebar -->

      <!-- Calendar -->
      <div class="col app-calendar-content">
        <div class="card shadow-none border-0">
          <div class="card-body pb-0" style="height: 464px;">
            <div>
              <div class="row d-flex justify-content-between">
                <div class="col-7 p-0 d-flex overflow-hidden align-items-center">
                  <a class="nav-item d-xl-none nav-link px-0 mx-2" href="javascript:void(0)" data-bs-toggle="sidebar" data-overlay="" data-target="#app-calendar-sidebar">
                    <i class="ti ti-menu-2 ti-sm"></i>
                  </a>
                  @if($selectedEmployee)
                  <div class="flex-shrink-0 avatar">
                    <img src="{{ Storage::disk("public")->url($selectedEmployee->profile_photo_path ?? 'profile-photos/.default-photo.jpg') }}" class="rounded-circle" alt="Avatar">
                  </div>
                  <div class="chat-contact-info flex-grow-1 ms-2">
                    <h6 class="m-0">{{ $selectedEmployee->name ?? 'Unknown Employee' }}</h6>
                    <small class="user-status text-muted">{{ $selectedEmployee->position->name ?? 'No Position' }}</small>
                  </div>
                  @else
                  <div class="flex-shrink-0 avatar">
                    <img src="{{ Storage::disk("public")->url('profile-photos/.default-photo.jpg') }}" class="rounded-circle" alt="Avatar">
                  </div>
                  <div class="chat-contact-info flex-grow-1 ms-2">
                    <h6 class="m-0">Unknown Employee</h6>
                    <small class="user-status text-muted">No Position</small>
                  </div>
                  @endif
                </div>
                <div class="col-5 btn-group d-flex justify-content-end">
                  <button wire:click.prevent='showCreateLeaveModal' type="button" class="btn btn-primary"
                          data-bs-toggle="modal" data-bs-target="#leaveModal">
                    <span class="ti ti-plus me-1"></span>{{ __('Add New Record') }}
                  </button>
                  <button type="button"
                          class="btn btn-primary dropdown-toggle dropdown-toggle-split waves-effect waves-light"
                          data-bs-toggle="dropdown" aria-expanded="false">
                    <span class="visually-hidden"></span>
                  </button>
                  <ul class="dropdown-menu">
                    <li>
                      <h6 class="dropdown-header text-uppercase">{{ __('Import & Export') }}</h6>
                    </li>
                    <li>
                      @can('Import leaves')
                      <button class="dropdown-item" data-bs-toggle="modal" data-bs-target="#importModal">
                        <i class="ti ti-table-import me-1"></i> {{ __('Import From Excel') }}
                      </button>
                      @endcan
                    </li>
                    <li>
                      <button wire:click='exportToExcel()' class="dropdown-item">
                        <i class="ti ti-table-export me-1"></i> {{ __('Export To Excel') }}
                      </button>
                    </li>
                  </ul>
                </div>
              </div>

              <div class="table-responsive text-nowrap">
                <table class="table">
                  <thead>
                  <tr>
                    <th>{{ __('ID') }}</th>
                    <th>{{ __('Employee') }}</th>
                    <th>{{ __('Leave Type') }}</th>
                    <th>{{ __('From Date') }}</th>
                    <th>{{ __('To Date') }}</th>
                    <th>{{ __('Status') }}</th>
                    <th class="col-1">{{ __('Actions') }}</th>
                  </tr>
                  </thead>
                  <tbody class="table-border-bottom-0">
                  @forelse($leaves as $leave)
                    <tr class="@if ($leave->is_checked) disabled @endif">
                      <td>{{ $leave->id }}</td>
                      <td>
                        @php
                          $leaveUser = \App\Models\User::find($leave->employee_id);
                        @endphp
                        <div class="d-flex align-items-center">
                          <div class="avatar avatar-xs me-2">
                            <span class="avatar-initial rounded-circle bg-label-primary">
                              {{ substr($leaveUser->name ?? 'U', 0, 2) }}
                            </span>
                          </div>
                          <div>
                            <h6 class="mb-0">{{ $leaveUser->name ?? 'Unknown' }}</h6>
                            <small class="text-muted">{{ $leaveUser->username ?? 'ID: ' . $leave->employee_id }}</small>
                          </div>
                        </div>
                      </td>
                      <td>
                        <span class="badge bg-label-info">{{ $leave->leave->name }}</span>
                      </td>
                      <td>{{ $leave->from_date ? Carbon::parse($leave->from_date)->format('d/m/Y') : '-' }}</td>
                      <td>{{ $leave->to_date ? Carbon::parse($leave->to_date)->format('d/m/Y') : '-' }}</td>
                      <td>
                        @php
                          $statusClass = match($leave->status ?? 'pending') {
                            'pending' => 'bg-label-warning',
                            'approved' => 'bg-label-success',
                            'rejected' => 'bg-label-danger',
                            default => 'bg-label-secondary'
                          };
                          $statusText = match($leave->status ?? 'pending') {
                            'pending' => __('Chờ phê duyệt'),
                            'approved' => __('Đã phê duyệt'),
                            'rejected' => __('Bị từ chối'),
                            default => __('Không xác định')
                          };
                        @endphp
                        <span class="badge {{ $statusClass }}">{{ $statusText }}</span>
                      </td>
                      <td>
                        <div class="d-flex gap-1">
                          {{-- View detail button --}}
                          <button wire:click.prevent="viewLeaveDetail({{ $leave->id }})" 
                                  data-bs-toggle="modal" 
                                  data-bs-target="#detailModal{{ $leave->id }}"
                                  class="btn btn-sm btn-info" 
                                  title="Xem chi tiết">
                            <i class="ti ti-eye"></i>
                          </button>
                          
                          {{-- Approval actions for department heads and HR --}}
                          @if($leave->status === 'pending' && auth()->user()->hasAnyRole(['Admin', 'HR', 'Head of Department', 'CC']))
                            <button wire:click.prevent="approveLeave({{ $leave->id }})" 
                                    class="btn btn-sm btn-success" 
                                    title="Phê duyệt">
                              <i class="ti ti-check"></i>
                            </button>
                            <button wire:click.prevent="$set('rejection_reason', '')" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#rejectModal{{ $leave->id }}"
                                    class="btn btn-sm btn-danger" 
                                    title="Từ chối">
                              <i class="ti ti-x"></i>
                            </button>
                          @endif
                          
                          {{-- Edit/Delete for own leaves --}}
                          @if($leave->employee_id == auth()->user()->id && $leave->status === 'pending')
                            <button wire:click.prevent="showUpdateLeaveModal({{ $leave->id }})" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#leaveModal"
                                    class="btn btn-sm btn-info" 
                                    title="Sửa">
                              <i class="ti ti-edit"></i>
                            </button>
                            <button wire:click.prevent="confirmDestroyLeave({{ $leave->id }})" 
                                    class="btn btn-sm btn-danger" 
                                    title="Xóa">
                              <i class="ti ti-trash"></i>
                            </button>
                          @endif
                          
                          {{-- Export signed PDF --}}
                          @if($leave->status === 'approved' && $leave->digital_signature)
                            <a href="{{ route('leave.download', ['id' => $leave->id]) }}" 
                               class="btn btn-sm btn-primary" 
                               title="Xuất PDF đã ký"
                               target="_blank">
                              <i class="ti ti-download"></i>
                            </a>
                          @endif
                          
                          @if ($confirmedId === $leave->id)
                            <button wire:click.prevent='destroyLeave({{ $leave->id }})' type="button"
                                    class="btn btn-xs btn-danger waves-effect waves-light">{{ __('Sure?') }}
                            </button>
                          @endif
                        </div>
                      </td>
                    </tr>
                  @empty
                    <tr>
                      <td colspan="7">
                        <div class="mt-2 mb-2" style="text-align: center">
                          <h3 class="mb-1 mx-2">{{ __('Oopsie-doodle!') }}</h3>
                          <p class="mb-4 mx-2">
                            {{ __('No data found, please sprinkle some data in my virtual bowl, and let the fun begin!') }}
                          </p>
                          <button class="btn btn-label-primary mb-4"
                            data-bs-toggle="modal" data-bs-target="#leaveModal">
                            {{ __('Add New Record') }}
                          </button>
                          <div>
                            <img src="{{ asset('assets/img/illustrations/page-misc-under-maintenance.png') }}"
                                 alt="page-misc-under-maintenance" width="200" class="img-fluid">
                          </div>
                        </div>
                      </td>
                    </tr>
                  @endforelse
                  </tbody>
                </table>
              </div>
              {{ $leaves->links() }}
            </div>
          </div>
        </div>

        <div class="app-overlay"></div>
      </div>
      <!-- /Calendar-->
    </div>

    {{-- Modals --}}
    @include('_partials._modals.modal-leave')
    @include('_partials/_modals/modal-import')
  </div>

  @push('custom-scripts')
    <script src="{{asset('assets/vendor/libs/select2/select2.js')}}"></script>
    <script src="{{ asset('assets/vendor/libs/flatpickr/flatpickr.js') }}"></script>

    <script>
      'use strict';

      $(function () {
        const select2selectedEmployeeId = $('#select2selectedEmployeeId');
        const select2selectedLeaveId = $('#select2selectedLeaveId');

        if (select2selectedEmployeeId.length) {
          select2selectedEmployeeId.each(function () {
            var $this = $(this);
            $this.wrap('<div class="position-relative"></div>').select2({
              placeholder: "{{ __('Select..') }}",
              dropdownParent: $this.parent()
            });
          });
        }

        $('#select2selectedEmployeeId').on('change', function (e) {
          var data = $('#select2selectedEmployeeId').select2("val");
          @this.set('selectedEmployeeId', data);
        });

        if (select2selectedLeaveId.length) {
          select2selectedLeaveId.each(function () {
            var $this = $(this);
            $this.wrap('<div class="position-relative"></div>').select2({
              placeholder: "{{ __('Select..') }}",
              allowClear: true,
              dropdownParent: $this.parent()
            });
          });
        }

        $('#select2selectedLeaveId').on('change', function (e) {
          var data = $('#select2selectedLeaveId').select2("val");
          @this.set('selectedLeaveId', data);
        });
      });
    </script>

    <script>
      $(document).ready(function () {
        const flatpickrRange = document.querySelector('#flatpickr-range');
        if (typeof flatpickrRange != undefined) {
          flatpickrRange.flatpickr({
            mode: 'range'
          });
        }
      });

    </script>
  @endpush

  {{-- Detail Modals --}}
  @foreach($leaves as $leave)
    <div wire:ignore.self class="modal fade" id="detailModal{{ $leave->id }}" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ __('Chi tiết đơn nghỉ phép') }} #{{ $leave->id }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            @php
              $leaveUser = \App\Models\User::find($leave->employee_id);
            @endphp
            <div class="row">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">{{ __('Nhân viên') }}</label>
                  <div class="alert alert-info">
                    <strong>{{ $leaveUser->name ?? 'Unknown' }}</strong><br>
                    <small>{{ $leaveUser->username ?? 'ID: ' . $leave->employee_id }}</small>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">{{ __('Loại nghỉ phép') }}</label>
                  <div class="alert alert-secondary">
                    <strong>{{ $leave->leave->name }}</strong>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">{{ __('Từ ngày') }}</label>
                  <div class="form-control-plaintext">{{ $leave->from_date ? Carbon::parse($leave->from_date)->format('d/m/Y') : '-' }}</div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">{{ __('Đến ngày') }}</label>
                  <div class="form-control-plaintext">{{ $leave->to_date ? Carbon::parse($leave->to_date)->format('d/m/Y') : '-' }}</div>
                </div>
              </div>
              @if($leave->start_at || $leave->end_at)
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">{{ __('Giờ bắt đầu') }}</label>
                  <div class="form-control-plaintext">{{ $leave->start_at ? Carbon::parse($leave->start_at)->format('H:i') : '-' }}</div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">{{ __('Giờ kết thúc') }}</label>
                  <div class="form-control-plaintext">{{ $leave->end_at ? Carbon::parse($leave->end_at)->format('H:i') : '-' }}</div>
                </div>
              </div>
              @endif
              <div class="col-12">
                <div class="mb-3">
                  <label class="form-label">{{ __('Ghi chú') }}</label>
                  <div class="form-control-plaintext">{{ $leave->note ?: __('Không có ghi chú') }}</div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">{{ __('Trạng thái') }}</label>
                  @php
                    $statusClass = match($leave->status ?? 'pending') {
                      'pending' => 'bg-label-warning',
                      'approved' => 'bg-label-success',
                      'rejected' => 'bg-label-danger',
                      default => 'bg-label-secondary'
                    };
                    $statusText = match($leave->status ?? 'pending') {
                      'pending' => __('Chờ phê duyệt'),
                      'approved' => __('Đã phê duyệt'),
                      'rejected' => __('Bị từ chối'),
                      default => __('Không xác định')
                    };
                  @endphp
                  <span class="badge {{ $statusClass }}">{{ $statusText }}</span>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">{{ __('Ngày tạo') }}</label>
                  <div class="form-control-plaintext">{{ $leave->created_at ? $leave->created_at->format('d/m/Y H:i') : '-' }}</div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">{{ __('Đóng') }}</button>
          </div>
        </div>
      </div>
    </div>
  @endforeach

  {{-- Rejection Modals --}}
  @foreach($leaves as $leave)
    <div wire:ignore.self class="modal fade" id="rejectModal{{ $leave->id }}" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ __('Từ chối đơn nghỉ phép') }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">{{ __('Nhân viên') }}</label>
              <div class="alert alert-info">
                <strong>{{ $leave->employee->name ?? auth()->user()->name }}</strong>
              </div>
            </div>
            <div class="mb-3">
              <label class="form-label">{{ __('Lý do từ chối') }} <span class="text-danger">*</span></label>
              <textarea wire:model="rejection_reason" class="form-control" rows="4" placeholder="Nhập lý do từ chối..."></textarea>
              @error('rejection_reason') <span class="text-danger">{{ $message }}</span> @enderror
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">{{ __('Hủy') }}</button>
            <button wire:click.prevent="rejectLeave({{ $leave->id }})" type="button" class="btn btn-danger" data-bs-dismiss="modal">{{ __('Từ chối') }}</button>
          </div>
        </div>
      </div>
    </div>
  @endforeach
</div>
