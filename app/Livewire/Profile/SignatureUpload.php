<?php

namespace App\Livewire\Profile;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Livewire\Component;
use Livewire\WithFileUploads;

class SignatureUpload extends Component
{
    use WithFileUploads;

    public $signatureImage;
    public $isUploading = false;

    public function updatedSignatureImage()
    {
        $this->validate([
            'signatureImage' => 'image|max:2048|mimes:png,jpg,jpeg',
        ], [
            'signatureImage.image' => 'File phải là hình ảnh',
            'signatureImage.max' => 'Kích thước file không được vượt quá 2MB',
            'signatureImage.mimes' => 'File phải có định dạng PNG, JPG hoặc JPEG',
        ]);
    }

    public function uploadSignature()
    {
        $this->validate([
            'signatureImage' => 'required|image|max:2048|mimes:png,jpg,jpeg',
        ]);

        $user = Auth::user();
        
        // Delete old signature from storage
        $oldSignaturePath = $this->getUserSignaturePath($user);
        if ($oldSignaturePath) {
            Storage::disk('public')->delete($oldSignaturePath);
        }

        // Store new signature with unique filename
        $filename = 'signature_' . $user->id . '_' . time() . '.' . $this->signatureImage->getClientOriginalExtension();
        $path = $this->signatureImage->storeAs('signatures', $filename, 'public');

        // Save signature path to database (column now exists)
        $user->update(['signature_path' => $path]);
        
        // Also clear any old session data
        session()->forget('user_signature_path_' . $user->id);

        $this->reset('signatureImage');
        $this->isUploading = false;
        
        session()->flash('success', 'Chữ ký điện tử đã được cập nhật thành công!');
    }

    public function deleteSignature()
    {
        $user = Auth::user();
        
        $signaturePath = $this->getUserSignaturePath($user);
        
        if ($signaturePath) {
            // Delete file from storage
            Storage::disk('public')->delete($signaturePath);
            
            // Remove from database
            $user->update(['signature_path' => null]);
            
            // Also clear any session data
            session()->forget('user_signature_path_' . $user->id);
            
            session()->flash('success', 'Đã xóa chữ ký điện tử!');
        }
    }
    
    protected function getUserSignaturePath($user)
    {
        // Priority: database first, then session as fallback
        return $user->signature_path ?? session('user_signature_path_' . $user->id);
    }

    public function render()
    {
        return view('livewire.profile.signature-upload');
    }
}
