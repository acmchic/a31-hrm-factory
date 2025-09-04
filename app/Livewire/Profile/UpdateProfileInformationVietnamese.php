<?php

namespace App\Livewire\Profile;

use Illuminate\Support\Facades\Auth;
use Livewire\Component;

class UpdateProfileInformationVietnamese extends Component
{
    public $state = [];

    public function mount()
    {
        $this->state = Auth::user()->only(['name', 'username', 'mobile', 'cccd', 'date_of_birth', 'enlist_date']);
        
        // Format dates for input fields
        if ($this->state['date_of_birth']) {
            $this->state['date_of_birth'] = $this->state['date_of_birth']->format('Y-m-d');
        }
        if ($this->state['enlist_date']) {
            $this->state['enlist_date'] = $this->state['enlist_date']->format('Y-m-d');
        }
    }

    public function updateProfileInformation()
    {
        $this->validate([
            'state.name' => 'required|string|max:255',
            'state.username' => 'required|string|max:255|unique:users,username,' . Auth::id(),
            'state.mobile' => 'nullable|string|max:20',
            'state.cccd' => 'nullable|string|max:12|unique:users,cccd,' . Auth::id(),
            'state.date_of_birth' => 'nullable|date|before:today',
            'state.enlist_date' => 'nullable|date',
        ], [
            'state.name.required' => 'Tên không được để trống',
            'state.username.required' => 'Tên đăng nhập không được để trống',
            'state.username.unique' => 'Tên đăng nhập đã được sử dụng',
            'state.cccd.unique' => 'Số CCCD đã được sử dụng',
            'state.cccd.max' => 'Số CCCD không được vượt quá 12 ký tự',
            'state.date_of_birth.before' => 'Ngày sinh phải trước ngày hiện tại',
            'state.enlist_date.date' => 'Ngày nhập ngũ không đúng định dạng',
        ]);

        // Clean empty values
        $updateData = array_filter($this->state, function($value) {
            return $value !== null && $value !== '';
        });

        Auth::user()->update($updateData);

        session()->flash('success', 'Thông tin cá nhân đã được cập nhật thành công!');
        
        return redirect()->route('profile.show');
    }

    public function render()
    {
        return view('livewire.profile.update-profile-information-vietnamese');
    }
}
