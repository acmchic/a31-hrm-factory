<div>
  @include('_partials/_alerts/alert-general')
  
  <div class="text-center">
    {{-- Current Avatar --}}
    <div class="avatar-upload mb-3" wire:click="$set('isUploading', true)">
      <div class="avatar avatar-xl">
        <img src="{{ Auth::user()->profile_photo_url }}" alt="Avatar" class="rounded-circle">
      </div>
      <div class="upload-overlay">
        <i class="ti ti-camera text-white"></i>
      </div>
    </div>
    
    <h6 class="mb-2">{{ Auth::user()->name }}</h6>
    <p class="text-muted small">Click vào ảnh để thay đổi</p>

    {{-- Upload Form --}}
    @if($isUploading)
      <div class="mt-3">
        <div class="mb-3">
          <input wire:model="photo" 
                 type="file" 
                 class="form-control @error('photo') is-invalid @enderror"
                 accept="image/*">
          @error('photo') <div class="invalid-feedback">{{ $message }}</div> @enderror
        </div>
        
        @if($photo)
          <div class="mb-3">
            <img src="{{ $photo->temporaryUrl() }}" 
                 class="rounded-circle" 
                 width="80" 
                 height="80"
                 alt="Preview">
          </div>
        @endif
        
        <div class="d-flex gap-2 justify-content-center">
          <button wire:click="uploadPhoto" 
                  type="button" 
                  class="btn btn-primary btn-sm"
                  @if(!$photo) disabled @endif>
            <i class="ti ti-check me-1"></i>Cập nhật
          </button>
          <button wire:click="$set('isUploading', false)" 
                  type="button" 
                  class="btn btn-secondary btn-sm">
            <i class="ti ti-x me-1"></i>Hủy
          </button>
        </div>
      </div>
    @endif

    {{-- Delete Button --}}
    @if(Auth::user()->profile_photo_path && !$isUploading)
      <button wire:click="deletePhoto" 
              type="button" 
              class="btn btn-outline-danger btn-sm mt-2"
              onclick="return confirm('Bạn có chắc muốn xóa ảnh đại diện?')">
        <i class="ti ti-trash me-1"></i>Xóa ảnh
      </button>
    @endif
  </div>
</div>
