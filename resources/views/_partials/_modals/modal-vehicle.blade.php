<div>
  @push('custom-css')
    <link rel="stylesheet" href="{{asset('assets/vendor/libs/flatpickr/flatpickr.css')}}"/>
    <link rel="stylesheet" href="{{asset('assets/vendor/libs/select2/select2.css')}}"/>
  @endpush

  <div wire:ignore.self class="modal fade" id="vehicleModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-simple">
      <div class="modal-content p-0 p-md-5">
        <div class="modal-body">
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
          <div class="text-center mb-4">
            <h3 class="mb-2">{{ $isEdit ? 'Cập nhật đăng ký' : 'Đăng ký xe mới' }}</h3>
            <p class="text-muted">Vui lòng điền đầy đủ thông tin</p>
          </div>
          <form wire:submit.prevent="submitRegistration" class="row g-3">
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
              <label class="form-label w-100">Người đăng ký</label>
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
              <label class="form-label w-100">Danh mục xe <span class="text-danger">*</span></label>
              <select wire:model='selectedCategory' class="form-control @error('selectedCategory') is-invalid @enderror" wire:change="loadVehiclesByCategory">
                <option value="">Chọn danh mục xe</option>
                @if(isset($vehicleCategories))
                  @foreach($vehicleCategories as $category)
                    <option value="{{ $category }}">{{ $category }}</option>
                  @endforeach
                @endif
              </select>
              @error('selectedCategory') <div class="invalid-feedback">{{ $message }}</div> @enderror
            </div>

            <div class="col-12">
              <label class="form-label w-100">Chọn xe <span class="text-danger">*</span></label>
              <select wire:model='vehicle_id' class="form-control @error('vehicle_id') is-invalid @enderror">
                <option value="">Chọn xe</option>
                @if(isset($availableVehicles))
                  @foreach($availableVehicles as $vehicle)
                    <option value="{{ $vehicle->id }}">{{ $vehicle->full_name }}</option>
                  @endforeach
                @endif
              </select>
              @error('vehicle_id') <div class="invalid-feedback">{{ $message }}</div> @enderror
            </div>

            <div class="col-12">
              <label class="form-label w-100">Chọn lái xe <span class="text-danger">*</span></label>
              <select wire:model='driver_id' class="form-control @error('driver_id') is-invalid @enderror">
                <option value="">Chọn lái xe</option>
                @if(isset($availableDrivers) && $availableDrivers->count() > 0)
                  @foreach($availableDrivers as $driver)
                    <option value="{{ $driver->id }}">{{ $driver->name }} - {{ $driver->position->name ?? 'Lái xe' }}</option>
                  @endforeach
                @else
                  <option value="" disabled>Không có lái xe nào</option>
                @endif
              </select>
              @error('driver_id') <div class="invalid-feedback">{{ $message }}</div> @enderror
            </div>
            
            <div class="col-md-6 col-12">
              <label class="form-label">Ngày đi <span class="text-danger">*</span></label>
              <input wire:model='departure_date' type="text" class="form-control flatpickr-input active @error('departure_date') is-invalid @enderror" id="flatpickr-date-from" readonly="readonly">
              @error('departure_date') <div class="invalid-feedback">{{ $message }}</div> @enderror
            </div>
            <div class="col-md-6 col-12">
              <label class="form-label w-100">Ngày về <span class="text-danger">*</span></label>
              <input wire:model='return_date' type="text" class="form-control flatpickr-input active @error('return_date') is-invalid @enderror" id="flatpickr-date-to" readonly="readonly" />
              @error('return_date') <div class="invalid-feedback">{{ $message }}</div> @enderror
            </div>
            
            <div class="col-12">
              <label class="form-label w-100">Tuyến đường <span class="text-danger">*</span></label>
              <textarea wire:model='route' class="form-control @error('route') is-invalid @enderror" rows="3" placeholder="Nhập tuyến đường..."></textarea>
              @error('route') <div class="invalid-feedback">{{ $message }}</div> @enderror
            </div>
            
            <div class="col-12">
              <label class="form-label w-100">Lý do xin xe <span class="text-danger">*</span></label>
              <textarea wire:model='purpose' class="form-control @error('purpose') is-invalid @enderror" rows="3" placeholder="Nhập lý do xin xe..."></textarea>
              @error('purpose') <div class="invalid-feedback">{{ $message }}</div> @enderror
            </div>
            
            <div class="col-12 text-center">
              <button type="submit" class="btn btn-primary me-sm-3 me-1" onclick="console.log('Submit button clicked')">Đăng ký</button>
              <button type="reset" class="btn btn-label-secondary btn-reset" data-bs-dismiss="modal" aria-label="Đóng">Hủy</button>
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

      window.addEventListener('clearVehicleForm', event => {
        $(function () {
          // Reset form values
          $('#flatpickr-date-from').val('');
          $('#flatpickr-date-to').val('');
          // Close modal
          $('#vehicleModal').modal('hide');
        });
      })
    </script>
  @endpush
</div>
