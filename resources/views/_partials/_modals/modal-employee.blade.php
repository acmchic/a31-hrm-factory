@push('custom-css')
  <style>
    input::-webkit-outer-spin-button,
      input::-webkit-inner-spin-button {
          -webkit-appearance: none;
          margin: 0;
      }

    input[type="number"] {
        -moz-appearance: textfield;
    }
  </style>
@endpush

<div wire:ignore.self class="modal fade" id="employeeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-simple">
    <div class="modal-content p-0 p-md-5">
      <div class="modal-body">
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        <div class="text-center mb-4">
          <h3 class="mb-2"></h3>
          <h3 class="mb-2">{{ $isEdit ? __('Update Employee') : __('New Employee') }}</h3>
          <p class="text-muted">{{ __('Please fill out the following information') }}</p>
        </div>
        <form wire:submit="submitEmployee" class="row g-3">
          <div class="col-md-6 col-12 mb-4">
            <label class="form-label w-100" for="CCCD">{{ __('CCCD') }}</label>
            <input wire:model.defer="employeeInfo.CCCD" class="form-control @error('employeeInfo.CCCD') is-invalid @enderror" id="employeeInfo.CCCD" placeholder="Nhập số CCCD" type="text">
            @error('employeeInfo.CCCD')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>
          <div class="col-md-6 col-12 mb-4">
            <label class="form-label w-100" for="phone">{{ __('Phone') }}</label>
            <input wire:model.defer="employeeInfo.phone" class="form-control @error('employeeInfo.phone') is-invalid @enderror" id="employeeInfo.phone" placeholder="Nhập số điện thoại" type="text">
            @error('employeeInfo.phone')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>
          
          <div class="col-md-6 col-12 mb-4">
            <label class="form-label w-100">{{ __('Họ và tên') }}</label>
            <input wire:model='employeeInfo.name' class="form-control @error('employeeInfo.name') is-invalid @enderror" type="text" placeholder="Nhập họ và tên đầy đủ" />
            @error('employeeInfo.name')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>
          
          <div class="col-md-6 col-12 mb-4">
            <label class="form-label w-100">{{ __('Cấp bậc') }}</label>
            <input wire:model='employeeInfo.rankCode' class="form-control @error('employeeInfo.rankCode') is-invalid @enderror" type="text" placeholder="VD: 4//" />
            @error('employeeInfo.rankCode')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>
          
          <div class="col-md-4 col-12 mb-4">
            <label class="form-label w-100" for="employeeInfo.gender" class="form-label">{{ __('Gender') }}</label>
            <select  wire:model.defer="employeeInfo.gender" @error('employeeInfo.gender') is-invalid @enderror id="employeeInfo.gender" class="form-select">
              <option value="">{{ __('Select..') }}</option>
              <option value="1">{{ __('Male') }}</option>
              <option value="0">{{ __('Female') }}</option>
            </select>
          </div>
          
          <div class="col-md-4 col-12 mb-4">
            <label class="form-label w-100">{{ __('Phòng ban') }}</label>
            <select wire:model.defer="employeeInfo.departmentId" class="form-select @error('employeeInfo.departmentId') is-invalid @enderror">
              <option value="">{{ __('Select..') }}</option>
              @foreach($departments as $department)
              <option value="{{ $department->id }}">{{ $department->name }}</option>
              @endforeach
            </select>
            @error('employeeInfo.departmentId')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>
          
          <div class="col-md-4 col-12 mb-4">
            <label class="form-label w-100">{{ __('Chức vụ') }}</label>
            <select wire:model.defer="employeeInfo.positionId" class="form-select @error('employeeInfo.positionId') is-invalid @enderror">
              <option value="">{{ __('Select..') }}</option>
              @foreach($positions as $position)
              <option value="{{ $position->id }}">{{ $position->name }}</option>
              @endforeach
            </select>
            @error('employeeInfo.positionId')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>
          
          {{-- Centers removed --}}
          
          <div class="col-md-4 col-12 mb-4">
            <label class="form-label w-100">{{ __('Ngày sinh') }}</label>
            <input id="dobInput" wire:model.defer="employeeInfo.dateOfBirth" type="text" placeholder="dd-mm-yy" class="form-control @error('employeeInfo.dateOfBirth') is-invalid @enderror">
            @error('employeeInfo.dateOfBirth')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>
          
          <div class="col-md-4 col-12 mb-4">
            <label class="form-label w-100">{{ __('Ngày nhập ngũ') }}</label>
            <input id="enlistInput" wire:model.defer="employeeInfo.enlistDate" type="text" placeholder="dd-mm-yy" class="form-control @error('employeeInfo.enlistDate') is-invalid @enderror">
            @error('employeeInfo.enlistDate')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>
          
          <div class="col-md-6 col-12 mb-4">
            <label class="form-label w-100" for="address">{{ __('Address') }}</label>
            <input wire:model.defer="employeeInfo.address" type="text" class="form-control @error('employeeInfo.address') is-invalid @enderror" id="employeeInfo.address">
            @error('employeeInfo.address')
            <div class="invalid-feedback">
                {{ $message }}
            </div>
            @enderror
          </div>

          <div class="col-12 text-center">
            <button type="submit" class="btn btn-primary me-sm-3 me-1">{{ __('Submit') }}</button>
            <button type="reset" class="btn btn-label-secondary btn-reset" data-bs-dismiss="modal" aria-label="Close">{{ __('Cancel') }}</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

@push('custom-scripts')
  <script src="{{ asset('assets/vendor/libs/flatpickr/flatpickr.js') }}"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function () {
      if (window.flatpickr) {
        flatpickr('#dobInput', { dateFormat: 'd-m-y', allowInput: true });
        flatpickr('#enlistInput', { dateFormat: 'd-m-y', allowInput: true });
      }
    });
  </script>
@endpush
