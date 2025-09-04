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

  <div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
      <div class="d-flex align-items-center">
        <div class="avatar avatar-sm me-3">
          <span class="avatar-initial rounded-circle bg-label-primary">
            {{ substr(auth()->user()->name, 0, 2) }}
          </span>
        </div>
        <div>
          <h5 class="mb-0">{{ __('Leaves') }}</h5>
          <small class="text-muted">{{ auth()->user()->name }}</small>
        </div>
      </div>
      <button wire:click.prevent='showCreateLeaveModal' type="button" class="btn btn-primary"
              data-bs-toggle="modal" data-bs-target="#leaveModal">
        <span class="ti ti-plus me-1"></span>{{ __('Add New Record') }}
      </button>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-12">
          <div class="table-responsive">
            @if ($leaves && $leaves->count() > 0)
              <table class="table table-striped">
                <thead>
                  <tr>
                    <th>STT</th>
                    <th>Nhân viên</th>
                    <th>Loại nghỉ</th>
                    <th>Từ ngày</th>
                    <th>Đến ngày</th>
                    <th>Ghi chú</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  @foreach ($leaves as $index => $leave)
                    <tr>
                      <td>{{ $index + 1 }}</td>
                      <td>
                        @php
                          $user = \App\Models\User::find($leave->employee_id);
                        @endphp
                        <div class="d-flex align-items-center">
                          <div class="avatar avatar-sm me-3">
                            <span class="avatar-initial rounded-circle bg-label-primary">
                              {{ substr($user->name ?? 'U', 0, 2) }}
                            </span>
                          </div>
                          <div>
                            <h6 class="mb-0">{{ $user->name ?? 'Unknown' }}</h6>
                            <small class="text-muted">{{ $user->email ?? 'N/A' }}</small>
                          </div>
                        </div>
                      </td>
                      <td>{{ $leave->leave->name ?? 'N/A' }}</td>
                      <td>{{ $leave->from_date ? \Carbon\Carbon::parse($leave->from_date)->format('d-m-Y') : 'N/A' }}</td>
                      <td>{{ $leave->to_date ? \Carbon\Carbon::parse($leave->to_date)->format('d-m-Y') : 'N/A' }}</td>
                      <td>{{ Str::limit($leave->note, 30) }}</td>
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
                          
                          {{-- Approval actions for department heads and HR (not for own leaves) --}}
                          @if($leave->status === 'pending' && $leave->employee_id != auth()->user()->id && auth()->user()->hasAnyRole(['Admin', 'HR', 'Head of Department', 'CC']))
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
                        </div>
                      </td>
                    </tr>
                  @endforeach
                </tbody>
              </table>
            @else
              <div class="text-center p-5">
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
            @endif
          </div>
        </div>
      </div>
    </div>
  </div>

  {{-- Include Leave Modal --}}
  @include('_partials/_modals/modal-leave')

  @if ($leaves && $leaves->count() > 0)
    <div class="mt-4">
      {{ $leaves->links() }}
    </div>
  @endif

  {{-- Detail/Edit Modals --}}
  @foreach($leaves as $leave)
    @php
      $user = \App\Models\User::find($leave->employee_id);
      $isUserLeave = $leave->employee_id == auth()->user()->id;
      $canApprove = !$isUserLeave && auth()->user()->hasAnyRole(['Admin', 'HR', 'Head of Department', 'CC']);
    @endphp
    
    <div wire:ignore.self class="modal fade" id="detailModal{{ $leave->id }}" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ $canApprove ? 'Phê duyệt đơn nghỉ phép' : 'Chi tiết đơn nghỉ phép' }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <form>
              <div class="row g-3">
                <div class="col-12">
                  <label class="form-label">Nhân viên</label>
                  <div class="alert alert-info d-flex align-items-center">
                    <div class="avatar avatar-sm me-3">
                      <span class="avatar-initial rounded-circle bg-label-primary">
                        {{ substr($user->name ?? 'U', 0, 2) }}
                      </span>
                    </div>
                    <div>
                      <h6 class="mb-0">{{ $user->name ?? 'Unknown' }}</h6>
                      <small class="text-muted">{{ $user->username ?? 'N/A' }}</small>
                    </div>
                  </div>
                </div>
                
                <div class="col-12">
                  <label class="form-label">Loại nghỉ phép</label>
                  <input type="text" class="form-control" value="{{ $leave->leave->name ?? 'N/A' }}" readonly>
                </div>
                
                <div class="col-md-6">
                  <label class="form-label">Từ ngày</label>
                  <input type="text" class="form-control" value="{{ $leave->from_date ? \Carbon\Carbon::parse($leave->from_date)->format('d-m-Y') : 'N/A' }}" readonly>
                </div>
                
                <div class="col-md-6">
                  <label class="form-label">Đến ngày</label>
                  <input type="text" class="form-control" value="{{ $leave->to_date ? \Carbon\Carbon::parse($leave->to_date)->format('d-m-Y') : 'N/A' }}" readonly>
                </div>
                
                @if($leave->start_at || $leave->end_at)
                <div class="col-md-6">
                  <label class="form-label">Thời gian bắt đầu</label>
                  <input type="text" class="form-control" value="{{ $leave->start_at ?? 'N/A' }}" readonly>
                </div>
                
                <div class="col-md-6">
                  <label class="form-label">Thời gian kết thúc</label>
                  <input type="text" class="form-control" value="{{ $leave->end_at ?? 'N/A' }}" readonly>
                </div>
                @endif
                
                <div class="col-12">
                  <label class="form-label">Ghi chú</label>
                  <textarea class="form-control" rows="3" readonly>{{ $leave->note ?? 'Không có ghi chú' }}</textarea>
                </div>
                
                <div class="col-md-6">
                  <label class="form-label">Trạng thái</label>
                  <input type="text" class="form-control" value="{{ $leave->status_text }}" readonly>
                </div>
                
                <div class="col-md-6">
                  <label class="form-label">Ngày tạo</label>
                  <input type="text" class="form-control" value="{{ $leave->created_at ? $leave->created_at->format('d-m-Y H:i') : 'N/A' }}" readonly>
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            @if($canApprove && $leave->status === 'pending')
              <button wire:click="approveLeave({{ $leave->id }})" class="btn btn-success" data-bs-dismiss="modal">
                <i class="ti ti-check me-1"></i>Duyệt
              </button>
              <button wire:click="$set('rejection_reason', '')" 
                      data-bs-toggle="modal" 
                      data-bs-target="#rejectModal{{ $leave->id }}"
                      data-bs-dismiss="modal"
                      class="btn btn-danger">
                <i class="ti ti-x me-1"></i>Từ chối
              </button>
            @endif
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          </div>
        </div>
      </div>
    </div>

    {{-- Reject Modal --}}
    <div wire:ignore.self class="modal fade" id="rejectModal{{ $leave->id }}" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Từ chối đơn nghỉ phép</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <textarea wire:model="rejection_reason" class="form-control" rows="3" placeholder="Nhập lý do từ chối..."></textarea>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button wire:click="rejectLeave({{ $leave->id }})" class="btn btn-danger" data-bs-dismiss="modal">Từ chối</button>
          </div>
        </div>
      </div>
    </div>
  @endforeach

  @push('custom-scripts')
    {{-- No additional scripts needed --}}
  @endpush
</div>
