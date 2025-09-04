@extends('layouts.layoutMaster')

@php
$breadcrumbs = [['link' => 'home', 'name' => 'Trang chủ'], ['link' => 'javascript:void(0)', 'name' => 'Người dùng'], ['name' => 'Hồ sơ cá nhân']];
@endphp

@section('title', 'Hồ sơ cá nhân')

@push('custom-css')
<style>
  .profile-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 15px;
    color: white;
    padding: 30px;
    margin-bottom: 30px;
  }
  .profile-card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
  }
  .upload-area {
    border: 2px dashed #dee2e6;
    border-radius: 10px;
    padding: 30px;
    text-align: center;
    transition: all 0.3s ease;
    cursor: pointer;
  }
  .upload-area:hover {
    border-color: #667eea;
    background-color: #f8f9ff;
  }
  .signature-preview {
    max-width: 200px;
    max-height: 100px;
    border: 1px solid #dee2e6;
    border-radius: 5px;
    padding: 10px;
    background: white;
  }
  .avatar-upload {
    position: relative;
    display: inline-block;
  }
  .avatar-upload .avatar {
    cursor: pointer;
    transition: all 0.3s ease;
  }
  .avatar-upload:hover .avatar {
    transform: scale(1.05);
  }
  .upload-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity 0.3s ease;
  }
  .avatar-upload:hover .upload-overlay {
    opacity: 1;
  }
</style>
@endpush

@section('content')
<div class="container-fluid">
  {{-- Header --}}
  <div class="profile-header">
    <div class="row align-items-center">
      <div class="col-md-8">
        <h2 class="mb-2">
          <i class="ti ti-user-circle me-2"></i>
          Hồ sơ cá nhân
        </h2>
        <p class="mb-0 opacity-75">
          Quản lý thông tin cá nhân và chữ ký điện tử của bạn
        </p>
      </div>
      <div class="col-md-4 text-md-end">
        <div class="d-flex align-items-center justify-content-md-end">
          <div class="avatar avatar-xl me-3">
            <img src="{{ Auth::user()->profile_photo_url }}" alt="Avatar" class="rounded-circle">
          </div>
          <div>
            <h5 class="mb-0 text-white">{{ Auth::user()->name }}</h5>
            <small class="opacity-75">{{ Auth::user()->username }}</small>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="row">
    {{-- Profile Information --}}
    <div class="col-lg-8">
      <div class="profile-card card">
        <div class="card-header">
          <h5 class="card-title mb-0">
            <i class="ti ti-user me-2"></i>Thông tin cá nhân
          </h5>
        </div>
        <div class="card-body">
          @livewire('profile.update-profile-information-vietnamese')
        </div>
      </div>

      {{-- Change Password --}}
      @if (Laravel\Fortify\Features::enabled(Laravel\Fortify\Features::updatePasswords()))
        <div class="profile-card card">
          <div class="card-header">
            <h5 class="card-title mb-0">
              <i class="ti ti-lock me-2"></i>Đổi mật khẩu
            </h5>
          </div>
          <div class="card-body">
            @livewire('profile.update-password-form-vietnamese')
          </div>
        </div>
      @endif
    </div>

    {{-- Avatar and Signature --}}
    <div class="col-lg-4">
      {{-- Avatar Upload --}}
      <div class="profile-card card">
        <div class="card-header">
          <h5 class="card-title mb-0">
            <i class="ti ti-photo me-2"></i>Ảnh đại diện
          </h5>
        </div>
        <div class="card-body text-center">
          @livewire('profile.avatar-upload')
        </div>
      </div>

      {{-- Signature Upload --}}
      <div class="profile-card card">
        <div class="card-header">
          <h5 class="card-title mb-0">
            <i class="ti ti-signature me-2"></i>Chữ ký điện tử
          </h5>
        </div>
        <div class="card-body">
          @livewire('profile.signature-upload')
        </div>
      </div>
    </div>
  </div>

  {{-- Two Factor Authentication --}}
  @if (Laravel\Fortify\Features::canManageTwoFactorAuthentication())
    <div class="profile-card card">
      <div class="card-header">
        <h5 class="card-title mb-0">
          <i class="ti ti-shield-lock me-2"></i>Xác thực hai yếu tố
        </h5>
      </div>
      <div class="card-body">
        @livewire('profile.two-factor-authentication-form')
      </div>
    </div>
  @endif

  {{-- Browser Sessions --}}
  <div class="profile-card card">
    <div class="card-header">
      <h5 class="card-title mb-0">
        <i class="ti ti-devices me-2"></i>Phiên đăng nhập
      </h5>
    </div>
    <div class="card-body">
      @livewire('profile.logout-other-browser-sessions-form')
    </div>
  </div>

  {{-- Delete Account --}}
  @if (Laravel\Jetstream\Jetstream::hasAccountDeletionFeatures())
    <div class="profile-card card border-danger">
      <div class="card-header bg-danger text-white">
        <h5 class="card-title mb-0">
          <i class="ti ti-trash me-2"></i>Xóa tài khoản
        </h5>
      </div>
      <div class="card-body">
        @livewire('profile.delete-user-form')
      </div>
    </div>
  @endif
</div>
@endsection
