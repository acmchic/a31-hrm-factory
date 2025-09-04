<div>
  @include('_partials/_alerts/alert-general')
  
  <form wire:submit="updatePassword">
    <div class="row">
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label">Mật khẩu hiện tại <span class="text-danger">*</span></label>
          <input wire:model="current_password" 
                 type="password" 
                 class="form-control @error('current_password') is-invalid @enderror" 
                 placeholder="Nhập mật khẩu hiện tại">
          @error('current_password') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label">Mật khẩu mới <span class="text-danger">*</span></label>
          <input wire:model="password" 
                 type="password" 
                 class="form-control @error('password') is-invalid @enderror" 
                 placeholder="Nhập mật khẩu mới">
          @error('password') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      <div class="col-md-4">
        <div class="mb-3">
          <label class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
          <input wire:model="password_confirmation" 
                 type="password" 
                 class="form-control @error('password_confirmation') is-invalid @enderror" 
                 placeholder="Nhập lại mật khẩu mới">
          @error('password_confirmation') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
      </div>
      
      <div class="col-12">
        <button type="submit" class="btn btn-primary">
          <i class="ti ti-lock me-1"></i>Đổi mật khẩu
        </button>
      </div>
    </div>
    
    <div class="alert alert-info mt-3">
      <h6 class="alert-heading">
        <i class="ti ti-info-circle me-1"></i>Lưu ý bảo mật
      </h6>
      <ul class="mb-0 small">
        <li>Mật khẩu mới phải có ít nhất 8 ký tự</li>
        <li>Nên sử dụng kết hợp chữ hoa, chữ thường, số và ký tự đặc biệt</li>
        <li>Không sử dụng thông tin cá nhân dễ đoán</li>
        <li>Thay đổi mật khẩu định kỳ để bảo mật tài khoản</li>
      </ul>
    </div>
  </form>
</div>
