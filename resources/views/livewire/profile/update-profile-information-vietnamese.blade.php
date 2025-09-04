<div>
  @include('_partials/_alerts/alert-general')
  
  <form wire:submit.prevent="updateProfileInformation">
    <div class="row">
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
          <input wire:model="state.name" 
                 type="text" 
                 class="form-control @error('state.name') is-invalid @enderror" 
                 placeholder="Nhập họ và tên đầy đủ">
          @error('state.name') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
          <input wire:model="state.username" 
                 type="text" 
                 class="form-control @error('state.username') is-invalid @enderror" 
                 placeholder="Nhập tên đăng nhập">
          @error('state.username') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label">Số căn cước công dân (CCCD)</label>
          <input wire:model="state.cccd" 
                 type="text" 
                 class="form-control @error('state.cccd') is-invalid @enderror" 
                 placeholder="Nhập số CCCD (12 số)"
                 maxlength="12">
          @error('state.cccd') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label">Số điện thoại</label>
          <input wire:model="state.mobile" 
                 type="text" 
                 class="form-control @error('state.mobile') is-invalid @enderror" 
                 placeholder="Nhập số điện thoại">
          @error('state.mobile') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label">Ngày tháng năm sinh</label>
          <input wire:model="state.date_of_birth" 
                 type="text" 
                 class="form-control flatpickr-input active @error('state.date_of_birth') is-invalid @enderror" 
                 id="flatpickr-birth-date" 
                 placeholder="YYYY-MM-DD"
                 readonly="readonly">
          @error('state.date_of_birth') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      <div class="col-md-6">
        <div class="mb-3">
          <label class="form-label">Ngày nhập ngũ</label>
          <input wire:model="state.enlist_date" 
                 type="text" 
                 class="form-control flatpickr-input active @error('state.enlist_date') is-invalid @enderror" 
                 id="flatpickr-enlist-date" 
                 placeholder="YYYY-MM-DD"
                 readonly="readonly">
          @error('state.enlist_date') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      
      <div class="col-12">
        <button type="submit" class="btn btn-primary">
          <i class="ti ti-check me-1"></i>Cập nhật thông tin
        </button>
      </div>
    </div>
  </form>
</div>
