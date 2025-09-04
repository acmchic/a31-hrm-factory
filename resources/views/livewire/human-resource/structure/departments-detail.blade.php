<div>
  @php
    $configData = Helper::appClasses();
  @endphp

  @section('title', 'Department Detail - Structure')

  {{-- Alerts --}}
  @include('_partials/_alerts/alert-general')

  <div class="row">
    <div class="col-12">
      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <div>
            <h4 class="card-title mb-0">{{ __('Department Detail') }}: {{ $selectedDepartment->name }}</h4>
            <small class="text-muted">{{ __('Total Employees') }}: {{ count($departmentEmployees) }}</small>
          </div>
          <div>
            <a href="{{ route('structure-departments') }}" class="btn btn-label-secondary">
              <i class="ti ti-arrow-left me-1"></i>{{ __('Back to Departments') }}
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header">
          <h5 class="card-title mb-0">{{ __('Employees in Department') }}</h5>
        </div>
        <div class="table-responsive text-nowrap">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>{{ __('Name') }}</th>
                <th>{{ __('Position') }}</th>
                <th>{{ __('Rank Code') }}</th>
                <th>{{ __('Center') }}</th>
                <th>{{ __('Actions') }}</th>
              </tr>
            </thead>
            <tbody class="table-border-bottom-0">
              @forelse($departmentEmployees as $employee)
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
                    @if($employee->center)
                      <span class="badge bg-label-info">{{ $employee->center->name }}</span>
                    @else
                      <span class="text-muted">-</span>
                    @endif
                  </td>
                  <td>
                    <a href="{{ route('structure-employees-info', $employee->id) }}" class="btn btn-sm btn-label-primary">
                      <i class="ti ti-eye"></i>
                    </a>
                  </td>
                </tr>
              @empty
                <tr>
                  <td colspan="5">
                    <div class="mt-2 mb-2" style="text-align: center">
                      <h3 class="mb-1 mx-2">{{ __('No Employees Found') }}</h3>
                      <p class="mb-4 mx-2">{{ __('This department has no employees assigned.') }}</p>
                    </div>
                  </td>
                </tr>
              @endforelse
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

