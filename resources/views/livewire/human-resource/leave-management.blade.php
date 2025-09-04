<div>
  @php
    $configData = Helper::appClasses();
  @endphp

  @section('title', 'Quản lý nghỉ phép - HRMS')

  {{-- Alerts --}}
  @include('_partials/_alerts/alert-general')

  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="card-title mb-0">
            <i class="ti ti-calendar-off ti-lg text-primary me-3"></i>{{ __('Quản lý nghỉ phép') }}
          </h5>
          <button wire:click.prevent='showCreateLeaveModal' type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#leaveModal">
            <span class="ti ti-plus me-1"></span>{{ __('Tạo đơn nghỉ phép') }}
          </button>
        </div>

        <!-- Filters -->
        <div class="card-body">
          <div class="row mb-3">
            <div class="col-md-3">
              <label class="form-label">{{ __('Trạng thái') }}</label>
              <select wire:model.live="statusFilter" class="form-select">
                <option value="">{{ __('Tất cả') }}</option>
                <option value="pending">{{ __('Chờ phê duyệt') }}</option>
                <option value="approved">{{ __('Đã phê duyệt') }}</option>
                <option value="rejected">{{ __('Bị từ chối') }}</option>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">{{ __('Phòng ban') }}</label>
              <select wire:model.live="departmentFilter" class="form-select">
                <option value="">{{ __('Tất cả') }}</option>
                @foreach($departments as $department)
                  <option value="{{ $department->id }}">{{ $department->name }}</option>
                @endforeach
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">{{ __('Ngày tạo') }}</label>
              <input wire:model.live="dateFilter" type="date" class="form-control">
            </div>
            <div class="col-md-3 d-flex align-items-end">
              <button wire:click="resetFilters" class="btn btn-label-secondary">
                <i class="ti ti-refresh me-1"></span>{{ __('Làm mới') }}
              </button>
            </div>
          </div>
        </div>

        <!-- Table -->
        <div class="table-responsive text-nowrap">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>{{ __('Nhân viên') }}</th>
                <th>{{ __('Loại nghỉ phép') }}</th>
                <th>{{ __('Thời gian') }}</th>
                <th>{{ __('Trạng thái') }}</th>
                <th>{{ __('Người phê duyệt') }}</th>
                <th>{{ __('Ngày tạo') }}</th>
                <th>{{ __('Thao tác') }}</th>
              </tr>
            </thead>
            <tbody class="table-border-bottom-0">
              @forelse($leaveRequests as $leaveRequest)
                <tr>
                  <td>
                    <div class="d-flex align-items-center">
                      <div class="avatar avatar-xs me-2">
                        <span class="avatar-initial rounded-circle bg-label-primary">
                          {{ substr($leaveRequest->employee->name, 0, 2) }}
                        </span>
                      </div>
                      <div>
                        <h6 class="mb-0">{{ $leaveRequest->employee->name }}</h6>
                        <small class="text-muted">{{ $leaveRequest->employee->department->name ?? 'N/A' }}</small>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span class="badge bg-label-info">{{ $leaveRequest->leave->name }}</span>
                  </td>
                  <td>
                    <div>
                      <div>{{ $leaveRequest->from_date->format('d/m/Y') }} - {{ $leaveRequest->to_date->format('d/m/Y') }}</div>
                      @if($leaveRequest->start_at && $leaveRequest->end_at)
                        <small class="text-muted">{{ $leaveRequest->start_at }} - {{ $leaveRequest->end_at }}</small>
                      @endif
                    </div>
                  </td>
                  <td>
                    @php
                      $statusClass = match($leaveRequest->status) {
                        'pending' => 'bg-label-warning',
                        'approved' => 'bg-label-success',
                        'rejected' => 'bg-label-danger',
                        default => 'bg-label-secondary'
                      };
                    @endphp
                    <span class="badge {{ $statusClass }}">{{ $leaveRequest->status_text }}</span>
                  </td>
                  <td>
                    @if($leaveRequest->approved_by)
                      <div class="d-flex align-items-center">
                        <div class="avatar avatar-xs me-2">
                          <span class="avatar-initial rounded-circle bg-label-success">
                            {{ substr($leaveRequest->approvedBy->name, 0, 2) }}
                          </span>
                        </div>
                        <div>
                          <h6 class="mb-0">{{ $leaveRequest->approvedBy->name }}</h6>
                          <small class="text-muted">{{ $leaveRequest->approved_at->format('d/m/Y H:i') }}</small>
                        </div>
                      </div>
                    @else
                      <span class="text-muted">-</span>
                    @endif
                  </td>
                  <td>
                    <small class="text-muted">{{ $leaveRequest->created_at->format('d/m/Y H:i') }}</small>
                  </td>
                  <td>
                    <div class="dropdown">
                      <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
                        <i class="ti ti-dots-vertical"></i>
                      </button>
                      <div class="dropdown-menu">
                        @if($leaveRequest->status === 'pending' && auth()->user()->can('approve', $leaveRequest))
                          <a wire:click.prevent="approveLeave({{ $leaveRequest->id }})" class="dropdown-item" href="#">
                            <i class="ti ti-check me-1"></i>{{ __('Phê duyệt') }}
                          </a>
                          <a wire:click.prevent="rejectLeave({{ $leaveRequest->id }})" class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#rejectModal">
                            <i class="ti ti-x me-1"></i>{{ __('Từ chối') }}
                          </a>
                        @endif

                        @if($leaveRequest->status === 'approved' && $leaveRequest->digital_signature)
                          <a wire:click.prevent="exportSignedPDF({{ $leaveRequest->id }})" class="dropdown-item" href="#">
                            <i class="ti ti-download me-1"></i>{{ __('Xuất PDF đã ký') }}
                          </a>
                        @endif

                        @if($leaveRequest->status === 'pending')
                          <a wire:click.prevent="showEditLeaveModal({{ $leaveRequest->id }})" class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#leaveModal">
                            <i class="ti ti-pencil me-1"></i>{{ __('Sửa') }}
                          </a>
                          <a wire:click.prevent="confirmDeleteLeave({{ $leaveRequest->id }})" class="dropdown-item" href="#">
                            <i class="ti ti-trash me-1"></i>{{ __('Xóa') }}
                          </a>
                        @endif

                        @if($confirmedId === $leaveRequest->id)
                          <button wire:click.prevent="deleteLeave({{ $leaveRequest->id }})" type="button" class="btn btn-sm btn-danger">
                            {{ __('Xác nhận xóa?') }}
                          </button>
                        @endif
                      </div>
                    </div>
                  </td>
                </tr>
              @empty
                <tr>
                  <td colspan="7">
                    <div class="text-center py-4">
                      <h4 class="mb-2">{{ __('Không có đơn nghỉ phép nào') }}</h4>
                    </div>
                  </td>
                </tr>
              @endforelse
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div class="card-footer">
          {{ $leaveRequests->links() }}
        </div>
      </div>
    </div>
  </div>

  <!-- Leave Modal -->
  @include('_partials._modals.modal-leave', ['employees' => $employees])

  <!-- Reject Modal -->
  <div wire:ignore.self class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{{ __('Từ chối đơn nghỉ phép') }}</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label">{{ __('Lý do từ chối') }} <span class="text-danger">*</span></label>
            <textarea wire:model="rejection_reason" class="form-control" rows="4" placeholder="Nhập lý do từ chối..."></textarea>
            @error('rejection_reason') <span class="text-danger">{{ $message }}</span> @enderror
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-label-secondary" data-bs-dismiss="modal">{{ __('Hủy') }}</button>
          <button type="button" class="btn btn-danger" data-bs-dismiss="modal">{{ __('Từ chối') }}</button>
        </div>
      </div>
    </div>
  </div>
</div>
