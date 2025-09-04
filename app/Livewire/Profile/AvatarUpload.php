<?php

namespace App\Livewire\Profile;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Livewire\Component;
use Livewire\WithFileUploads;

class AvatarUpload extends Component
{
    use WithFileUploads;

    public $photo;
    public $isUploading = false;

    public function updatedPhoto()
    {
        $this->validate([
            'photo' => 'image|max:2048|mimes:png,jpg,jpeg',
        ], [
            'photo.image' => 'File phải là hình ảnh',
            'photo.max' => 'Kích thước file không được vượt quá 2MB',
            'photo.mimes' => 'File phải có định dạng PNG, JPG hoặc JPEG',
        ]);
    }

    public function uploadPhoto()
    {
        $this->validate([
            'photo' => 'required|image|max:2048|mimes:png,jpg,jpeg',
        ]);

        $user = Auth::user();
        
        // Delete old photo
        if ($user->profile_photo_path) {
            Storage::disk('public')->delete($user->profile_photo_path);
        }

        $filename = 'avatar_' . $user->id . '_' . time() . '.' . $this->photo->getClientOriginalExtension();
        $path = $this->photo->storeAs('profile-photos', $filename, 'public');

        $user->update(['profile_photo_path' => $path]);

        $this->reset('photo');
        $this->isUploading = false;
        
        session()->flash('success', 'Ảnh đại diện đã được cập nhật thành công!');
    }

    public function deletePhoto()
    {
        $user = Auth::user();
        
        if ($user->profile_photo_path) {
            Storage::disk('public')->delete($user->profile_photo_path);
            $user->update(['profile_photo_path' => null]);
            
            session()->flash('success', 'Đã xóa ảnh đại diện!');
        }
    }

    public function render()
    {
        return view('livewire.profile.avatar-upload');
    }
}
