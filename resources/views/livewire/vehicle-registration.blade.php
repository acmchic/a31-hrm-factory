<div>
  @php
    $configData = Helper::appClasses();
    use Carbon\Carbon;
  @endphp

  @section('title', 'Đăng ký xe - HRMS')

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

  <div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
      <div class="d-flex align-items-center">
        <div class="avatar avatar-sm me-3">
          <span class="avatar-initial rounded-circle bg-label-primary">
            {{ substr(auth()->user()->name, 0, 2) }}
          </span>
        </div>
        <div>
          <h5 class="mb-0">Đăng ký xe công</h5>
          <small class="text-muted">{{ auth()->user()->name }}</small>
        </div>
      </div>
      <button wire:click.prevent='showCreateVehicleModal' type="button" class="btn btn-primary"
              data-bs-toggle="modal" data-bs-target="#vehicleModal">
        <span class="ti ti-plus me-1"></span>Đăng ký xe mới
      </button>
    </div>
    <div class="card-body">
      <div class="row">
          <div class="col-12">
            <div class="table-responsive">
              @if ($registrations && $registrations->count() > 0)
                <table class="table table-striped">
                  <thead>
                    <tr>
                      <th>STT</th>
                      <th>Lái xe</th>
                      <th>Xe</th>
                      <th>Ngày đi</th>
                      <th>Ngày về</th>
                      <th>Tuyến đường</th>
                      <th>Trạng thái</th>
                      <th>Thao tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    @foreach ($registrations as $index => $registration)
                      <tr>
                        <td>{{ $index + 1 }}</td>
                        <td>
                          <div class="d-flex align-items-center">
                            <div class="avatar avatar-sm me-3">
                              <span class="avatar-initial rounded-circle bg-label-success">
                                {{ substr($registration->driver_name ?? 'L', 0, 2) }}
                              </span>
                            </div>
                            <div>
                              <h6 class="mb-0">{{ $registration->driver_name ?? 'Chưa chọn' }}</h6>
                              <small class="text-muted">Lái xe</small>
                            </div>
                          </div>
                        </td>
                        <td>{{ $registration->vehicle->full_name ?? 'N/A' }}</td>
                        <td>{{ \Carbon\Carbon::parse($registration->departure_date)->format('d/m/Y') }}</td>
                        <td>{{ \Carbon\Carbon::parse($registration->return_date)->format('d/m/Y') }}</td>
                        <td>{{ Str::limit($registration->route, 30) }}</td>
                        <td>
                          @php
                            $statusClass = match($registration->workflow_status ?? 'submitted') {
                              'submitted' => 'bg-label-warning',
                              'dept_review' => 'bg-label-info', 
                              'director_review' => 'bg-label-info',
                              'approved' => 'bg-label-success',
                              'rejected' => 'bg-label-danger',
                              default => 'bg-label-secondary'
                            };
                            $statusText = \App\Livewire\VehicleRegistration::STATUS_LABELS[$registration->workflow_status ?? 'submitted'] ?? 'Không xác định';
                          @endphp
                          <span class="badge {{ $statusClass }}">{{ $statusText }}</span>
                        </td>
                        <td>
                          <div class="d-flex gap-1">
                            {{-- View detail button --}}
                            <button wire:click.prevent="viewRegistrationDetail({{ $registration->id }})" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#detailModal{{ $registration->id }}"
                                    class="btn btn-sm btn-info" 
                                    title="Xem chi tiết">
                              <i class="ti ti-eye"></i>
                            </button>
                            
                            {{-- Department Head Approval (Trưởng phòng Kế hoạch) --}}
                            @if($registration->workflow_status === 'submitted' && $registration->user_id != auth()->user()->id && auth()->user()->hasAnyRole(['Admin', 'HR', 'Trưởng phòng Kế hoạch']))
                              <button wire:click.prevent="approveDepartment({{ $registration->id }})" 
                                      class="btn btn-sm btn-success" 
                                      title="Phê duyệt (Trưởng phòng)">
                                <i class="ti ti-check"></i> Trưởng phòng duyệt
                              </button>
                              <button wire:click.prevent="rejectRegistration({{ $registration->id }})" 
                                      class="btn btn-sm btn-danger" 
                                      title="Từ chối">
                                <i class="ti ti-x"></i> Từ chối
                              </button>
                            @endif
                            
                            {{-- Director Approval (Ban Giám đốc) --}}
                            @if($registration->workflow_status === 'dept_review' && $registration->user_id != auth()->user()->id && auth()->user()->hasAnyRole(['Admin', 'Ban Giám đốc']))
                              <button wire:click.prevent="approveDirector({{ $registration->id }})" 
                                      class="btn btn-sm btn-primary" 
                                      title="Phê duyệt (Thủ trưởng)">
                                <i class="ti ti-check-double"></i> Thủ trưởng duyệt
                              </button>
                              <button wire:click.prevent="rejectRegistration({{ $registration->id }})" 
                                      class="btn btn-sm btn-danger" 
                                      title="Từ chối">
                                <i class="ti ti-x"></i> Từ chối
                              </button>
                            @endif
                            
                            {{-- Edit/Delete for own registrations - only when not approved --}}
                            @if($registration->user_id == auth()->user()->id && $registration->workflow_status === 'submitted')
                              <button wire:click.prevent="showUpdateVehicleModal({{ $registration->id }})" 
                                      data-bs-toggle="modal" 
                                      data-bs-target="#vehicleModal"
                                      class="btn btn-sm btn-warning" 
                                      title="Chỉnh sửa">
                                <i class="ti ti-edit"></i>
                              </button>
                              <button wire:click.prevent="confirmDeleteRegistration({{ $registration->id }})" 
                                      class="btn btn-sm btn-danger" 
                                      title="Xóa đăng ký">
                                <i class="ti ti-trash"></i>
                              </button>
                            @endif
                            
                            {{-- Export signed PDF - available after department approval --}}
                            @if(in_array($registration->workflow_status, ['dept_review', 'approved']))
                              <button wire:click.prevent="downloadVehiclePDF({{ $registration->id }})" 
                                      class="btn btn-sm btn-success" 
                                      title="Tải PDF đăng ký xe">
                                <i class="ti ti-download"></i>
                              </button>
                            @endif
                          </div>
                        </td>
                      </tr>
                    @endforeach
                  </tbody>
                </table>
              @else
                <div class="text-center p-5">
                  <p class="mb-4 mx-2">
                    Chưa có dữ liệu đăng ký xe nào!
                  </p>
                  <button class="btn btn-label-primary mb-4"
                    data-bs-toggle="modal" data-bs-target="#vehicleModal">
                    Đăng ký xe mới
                  </button>
                  <div>
                    <img src="{{ asset('assets/img/illustrations/page-misc-under-maintenance.png') }}"
                         alt="page-misc-under-maintenance" width="200" class="img-fluid">
                  </div>
                </div>
              @endif
            </div>
          </div>
        </div>
    </div>
  </div>

  {{-- Include Vehicle Modal --}}
  @include('_partials/_modals/modal-vehicle')

  @if ($registrations && $registrations->count() > 0)
    <div class="mt-4">
      {{ $registrations->links() }}
    </div>
  @endif

  {{-- Detail Modals --}}
  @foreach($registrations as $registration)
    <div wire:ignore.self class="modal fade" id="detailModal{{ $registration->id }}" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Chi tiết đăng ký xe</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Xe đăng ký</label>
                <input type="text" class="form-control" value="{{ $registration->vehicle->full_name ?? 'N/A' }}" readonly>
              </div>
              <div class="col-md-6">
                <label class="form-label">Lái xe</label>
                <input type="text" class="form-control" value="{{ $registration->driver_name ?? 'N/A' }}" readonly>
              </div>
              <div class="col-md-6">
                <label class="form-label">Ngày đi</label>
                <input type="text" class="form-control" value="{{ \Carbon\Carbon::parse($registration->departure_date)->format('d-m-Y') }}" readonly>
              </div>
              <div class="col-md-6">
                <label class="form-label">Ngày về</label>
                <input type="text" class="form-control" value="{{ \Carbon\Carbon::parse($registration->return_date)->format('d-m-Y') }}" readonly>
              </div>
              <div class="col-12">
                <label class="form-label">Tuyến đường</label>
                <input type="text" class="form-control" value="{{ $registration->route ?? 'N/A' }}" readonly>
              </div>
              <div class="col-12">
                <label class="form-label">Mục đích sử dụng</label>
                <textarea class="form-control" rows="3" readonly>{{ $registration->purpose ?? 'N/A' }}</textarea>
              </div>
              <div class="col-md-6">
                <label class="form-label">Trạng thái</label>
                <input type="text" class="form-control" value="{{ \App\Livewire\VehicleRegistration::STATUS_LABELS[$registration->workflow_status ?? 'submitted'] ?? 'Không xác định' }}" readonly>
              </div>
              <div class="col-md-6">
                <label class="form-label">Ngày tạo</label>
                <input type="text" class="form-control" value="{{ $registration->created_at->format('d-m-Y H:i') }}" readonly>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            {{-- Department Head Approval in modal --}}
            @if($registration->workflow_status === 'submitted' && $registration->user_id != auth()->user()->id && auth()->user()->hasAnyRole(['Admin', 'HR', 'Trưởng phòng Kế hoạch']))
              <button wire:click="approveDepartment({{ $registration->id }})" 
                      class="btn btn-success" 
                      data-bs-dismiss="modal">
                <i class="ti ti-check me-1"></i>Trưởng phòng duyệt
              </button>
            @endif
            
            {{-- Director Approval in modal --}}
            @if($registration->workflow_status === 'dept_review' && $registration->user_id != auth()->user()->id && auth()->user()->hasAnyRole(['Admin', 'Ban Giám đốc']))
              <button wire:click="approveDirector({{ $registration->id }})" 
                      class="btn btn-primary" 
                      data-bs-dismiss="modal">
                <i class="ti ti-check-double me-1"></i>Thủ trưởng duyệt
              </button>
            @endif
            
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          </div>
        </div>
      </div>
    </div>
  @endforeach

  @push('custom-scripts')
    {{-- No additional scripts needed --}}
  @endpush
</div>