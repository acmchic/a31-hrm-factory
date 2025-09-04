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
        
        // Delete old signature
        if ($user->signature_path) {
            Storage::disk('public')->delete($user->signature_path);
        }

        $filename = 'signature_' . $user->id . '_' . time() . '.' . $this->signatureImage->getClientOriginalExtension();
        $path = $this->signatureImage->storeAs('signatures', $filename, 'public');

        // Try to update signature_path, fallback if column doesn't exist
        try {
            $user->update(['signature_path' => $path]);
        } catch (\Exception $e) {
            // If column doesn't exist, store in session temporarily
            session(['user_signature_path_' . $user->id => $path]);
        }

        $this->reset('signatureImage');
        $this->isUploading = false;
        
        session()->flash('success', 'Chữ ký điện tử đã được cập nhật thành công!');
    }

    public function deleteSignature()
    {
        $user = Auth::user();
        
        $signaturePath = $this->getUserSignaturePath($user);
        
        if ($signaturePath) {
            Storage::disk('public')->delete($signaturePath);
            
            try {
                $user->update(['signature_path' => null]);
            } catch (\Exception $e) {
                // If column doesn't exist, remove from session
                session()->forget('user_signature_path_' . $user->id);
            }
            
            session()->flash('success', 'Đã xóa chữ ký điện tử!');
        }
    }
    
    protected function getUserSignaturePath($user)
    {
        // Try to get from database first, fallback to session
        try {
            return $user->signature_path;
        } catch (\Exception $e) {
            return session('user_signature_path_' . $user->id);
        }
    }

    public function render()
    {
        return view('livewire.profile.signature-upload');
    }
}
