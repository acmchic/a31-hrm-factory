<?php

namespace App\Livewire\Profile;

use Illuminate\Support\Facades\Auth;
use Livewire\Component;

class UpdateProfileInformationVietnamese extends Component
{
    public $state = [];

    public function mount()
    {
        $this->state = Auth::user()->only(['name', 'username', 'email', 'mobile']);
    }

    public function updateProfileInformation()
    {
        $this->validate([
            'state.name' => 'required|string|max:255',
            'state.username' => 'required|string|max:255|unique:users,username,' . Auth::id(),
            'state.email' => 'required|email|max:255|unique:users,email,' . Auth::id(),
            'state.mobile' => 'nullable|string|max:20',
        ], [
            'state.name.required' => 'Tên không được để trống',
            'state.username.required' => 'Tên đăng nhập không được để trống',
            'state.username.unique' => 'Tên đăng nhập đã được sử dụng',
            'state.email.required' => 'Email không được để trống',
            'state.email.email' => 'Email không đúng định dạng',
            'state.email.unique' => 'Email đã được sử dụng',
        ]);

        Auth::user()->update($this->state);

        session()->flash('success', 'Thông tin cá nhân đã được cập nhật thành công!');
    }

    public function render()
    {
        return view('livewire.profile.update-profile-information-vietnamese');
    }
}
