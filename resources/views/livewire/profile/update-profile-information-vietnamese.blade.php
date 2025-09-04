<div>
  @include('_partials/_alerts/alert-general')
  
  <form wire:submit="updateProfileInformation">
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
          <label class="form-label">Địa chỉ email <span class="text-danger">*</span></label>
          <input wire:model="state.email" 
                 type="email" 
                 class="form-control @error('state.email') is-invalid @enderror" 
                 placeholder="Nhập địa chỉ email">
          @error('state.email') <div class="invalid-feedback">{{ $message }}</div> @enderror
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
      
      <div class="col-12">
        <button type="submit" class="btn btn-primary">
          <i class="ti ti-check me-1"></i>Cập nhật thông tin
        </button>
      </div>
    </div>
  </form>
</div>
