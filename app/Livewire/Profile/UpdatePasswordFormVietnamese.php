<?php

namespace App\Livewire\Profile;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Livewire\Component;

class UpdatePasswordFormVietnamese extends Component
{
    public $current_password = '';
    public $password = '';
    public $password_confirmation = '';

    protected $rules = [
        'current_password' => 'required',
        'password' => 'required|min:8|confirmed',
    ];

    protected $messages = [
        'current_password.required' => 'Vui lòng nhập mật khẩu hiện tại',
        'password.required' => 'Vui lòng nhập mật khẩu mới',
        'password.min' => 'Mật khẩu mới phải có ít nhất 8 ký tự',
        'password.confirmed' => 'Xác nhận mật khẩu không khớp',
    ];

    public function updatePassword()
    {
        $this->validate();

        // Verify current password
        if (!Hash::check($this->current_password, Auth::user()->password)) {
            $this->addError('current_password', 'Mật khẩu hiện tại không đúng');
            return;
        }

        // Update password
        Auth::user()->update([
            'password' => Hash::make($this->password),
        ]);

        // Reset form
        $this->reset();

        session()->flash('success', 'Mật khẩu đã được thay đổi thành công!');
    }

    public function render()
    {
        return view('livewire.profile.update-password-form-vietnamese');
    }
}
