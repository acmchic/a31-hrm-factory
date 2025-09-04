<div>
  @include('_partials/_alerts/alert-general')
  
  {{-- Current Signature --}}
  @php
    // Get signature path directly from database
    $currentSignature = Auth::user()->signature_path;
  @endphp
  @if($currentSignature)
    <div class="mb-4">
      <label class="form-label">Chữ ký hiện tại</label>
      <div class="text-center p-3 border rounded">
        <img src="{{ Storage::url($currentSignature) }}" 
             alt="Chữ ký" 
             class="signature-preview">
      </div>
      <div class="text-center mt-2">
        <button wire:click="deleteSignature" 
                type="button" 
                class="btn btn-outline-danger btn-sm"
                onclick="return confirm('Bạn có chắc muốn xóa chữ ký?')">
          <i class="ti ti-trash me-1"></i>Xóa chữ ký
        </button>
      </div>
    </div>
  @endif

  {{-- Upload New Signature --}}
  @if(!$isUploading)
    <div class="upload-area" wire:click="$set('isUploading', true)">
      <i class="ti ti-signature ti-lg text-primary mb-2"></i>
      <h6 class="mb-2">{{ $currentSignature ? 'Thay đổi chữ ký' : 'Tải lên chữ ký' }}</h6>
      <p class="text-muted small mb-0">Click để chọn file hình ảnh</p>
      <p class="text-muted small">PNG, JPG, JPEG (tối đa 2MB)</p>
    </div>
  @else
    <div>
      <div class="mb-3">
        <label class="form-label">Chọn file chữ ký</label>
        <input wire:model="signatureImage" 
               type="file" 
               class="form-control @error('signatureImage') is-invalid @enderror"
               accept="image/*">
        @error('signatureImage') <div class="invalid-feedback">{{ $message }}</div> @enderror
      </div>
      
      @if($signatureImage)
        <div class="mb-3 text-center">
          <label class="form-label">Xem trước</label>
          <div class="p-3 border rounded">
            <img src="{{ $signatureImage->temporaryUrl() }}" 
                 alt="Preview" 
                 class="signature-preview">
          </div>
        </div>
      @endif
      
      <div class="d-flex gap-2">
        <button wire:click="uploadSignature" 
                type="button" 
                class="btn btn-primary"
                @if(!$signatureImage) disabled @endif>
          <i class="ti ti-check me-1"></i>Cập nhật chữ ký
        </button>
        <button wire:click="$set('isUploading', false)" 
                type="button" 
                class="btn btn-secondary">
          <i class="ti ti-x me-1"></i>Hủy
        </button>
      </div>
    </div>
  @endif

  {{-- Instructions --}}
  <div class="alert alert-info mt-3">
    <h6 class="alert-heading">
      <i class="ti ti-info-circle me-1"></i>Hướng dẫn
    </h6>
    <ul class="mb-0 small">
      <li>Sử dụng hình ảnh có nền trong suốt để chữ ký đẹp hơn</li>
      <li>Kích thước khuyến nghị: 300x150 pixels</li>
      <li>Chữ ký sẽ được sử dụng khi phê duyệt đơn nghỉ phép</li>
      <li>File được lưu an toàn và chỉ bạn mới thấy được</li>
    </ul>
  </div>
</div>
