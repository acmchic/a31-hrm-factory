<div>
  @push('custom-css')
    <link rel="stylesheet" href="{{asset('assets/vendor/libs/flatpickr/flatpickr.css')}}"/>
    <link rel="stylesheet" href="{{asset('assets/vendor/libs/select2/select2.css')}}"/>
  @endpush

  <div wire:ignore.self class="modal fade" id="leaveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-simple">
      <div class="modal-content p-0 p-md-5">
        <div class="modal-body">
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          <div class="text-center mb-4">
            <h3 class="mb-2"></h3>
            <h3 class="mb-2">{{ $isEdit ? __('Update Record') : __('New Record') }}</h3>
            <p class="text-muted">{{ __('Please fill out the following information') }}</p>
          </div>
          <form wire:submit="submitLeave" class="row g-3">
            @if ($errors->any())
            <div class="alert alert-danger">
              <ul>
                @foreach ($errors->all() as $error)
                  <li>{{ $error }}</li>
                @endforeach
              </ul>
            </div>
            @endif
            <div class="col-12">
              <label class="form-label w-100">{{ __('Employee') }}</label>
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
            <div class="col-12">
              <label class="form-label w-100">{{ __('Type') }}</label>
              <select wire:model='newLeaveInfo.LeaveId' class="form-control @error('newLeaveInfo.LeaveId') is-invalid @enderror">
                <option value="">{{ __('Select leave type') }}</option>
                @if(isset($leaveTypes))
                  @foreach($leaveTypes as $leaveType)
                    <option value="{{ $leaveType->id }}">{{ $leaveType->name }}</option>
                  @endforeach
                @else
                  <option value="1">Nghỉ Ốm</option>
                  <option value="2">Nghỉ Việc cá nhân</option>
                @endif
              </select>
            </div>
            <div class="col-md-6 col-12">
              <label class="form-label">{{ __('From Date') }}</label>
              <input wire:model='newLeaveInfo.fromDate' type="text" class="form-control flatpickr-input active @error('newLeaveInfo.fromDate') is-invalid @enderror" id="flatpickr-date-from" readonly="readonly">
            </div>
            <div class="col-md-6 col-12">
              <label class="form-label w-100">{{ __('To Date') }}</label>
              <input wire:model='newLeaveInfo.toDate' type="text" class="form-control flatpickr-input active @error('newLeaveInfo.toDate') is-invalid @enderror" id="flatpickr-date-to" readonly="readonly" />
            </div>
            <div class="col-12">
              <label class="form-label w-100">{{ __('Note') }} <small class="text-muted">({{ __('Optional') }})</small></label>
              <textarea wire:model='newLeaveInfo.note' class="form-control" rows="3" placeholder="{{ __('Enter note here...') }}"></textarea>
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
      $(document).ready(function () {
        const flatpickrDateFrom = document.querySelector('#flatpickr-date-from');
        if (typeof flatpickrDateFrom != undefined) {
          flatpickrDateFrom.flatpickr({
            dateFormat: "Y-m-d",
            locale: "vi",
            allowInput: true,
            clickOpens: true,
            theme: "light"
          });
        }
      });
    </script>

    <script>
      $(document).ready(function () {
        const flatpickrDateTo = document.querySelector('#flatpickr-date-to');
        if (typeof flatpickrDateTo != undefined) {
          flatpickrDateTo.flatpickr({
            dateFormat: "Y-m-d",
            locale: "vi",
            allowInput: true,
            clickOpens: true,
            theme: "light"
          });
        }
      });
    </script>

    <script>
      'use strict';

      window.addEventListener('clearSelect2Values', event => {
        $(function () {
          // Reset form values
          $('#flatpickr-date-from').val('');
          $('#flatpickr-date-to').val('');
        });
      })
    </script>
  @endpush
</div>
