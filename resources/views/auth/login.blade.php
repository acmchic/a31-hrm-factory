@php
$customizerHidden = 'customizer-hide';
$configData = Helper::appClasses();
@endphp

@extends('layouts/blankLayout')

@section('title', 'Login')

@section('page-style')
{{-- Page Css files --}}
<link rel="stylesheet" href="{{ asset(mix('assets/vendor/css/pages/page-auth.css')) }}">
<style>
  .authentication-wrapper {
    min-height: 100vh;
  }
  
  .auth-cover-bg {
    position: relative;
    overflow: hidden;
  }
  
  .auth-cover-bg::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(135, 206, 235, 0.9) 0%, rgba(173, 216, 230, 0.9) 100%);
    z-index: 1;
  }
  
  .auth-cover-bg > div {
    position: relative;
    z-index: 2;
  }
  
  .form-control:focus {
    border-color: #87ceeb;
    box-shadow: 0 0 0 0.2rem rgba(135, 206, 235, 0.25);
  }
  
  .btn-primary {
    background: linear-gradient(135deg, #87ceeb 0%, #add8e6 100%);
    border: none;
    transition: all 0.3s ease;
  }
  
  .btn-primary:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(135, 206, 235, 0.4);
  }
  
  .form-control {
    border: 1px solid #e1e5e9;
    transition: all 0.3s ease;
  }
  
  .form-control:hover {
    border-color: #87ceeb;
  }
  
  .form-label {
    color: #344767;
    margin-bottom: 8px;
  }
  
  .authentication-inner {
    margin: 0;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    border-radius: 12px;
    overflow: hidden;
    max-width: 1200px;
    margin: auto;
    margin-top: 2rem;
    margin-bottom: 2rem;
  }
  
  @media (max-width: 991.98px) {
    .authentication-inner {
      margin: 1rem;
      border-radius: 8px;
    }
  }
</style>
@endsection

@section('content')
<div class="authentication-wrapper authentication-cover authentication-bg">
  <div class="authentication-inner row">
    <!-- Left Side - Logo Section -->
    <div class="d-none d-lg-flex col-lg-7 p-0">
      <div class="auth-cover-bg auth-cover-bg-color d-flex justify-content-center align-items-center flex-column" style="background: linear-gradient(135deg, #87ceeb 0%, #add8e6 100%);">
        <div class="text-center text-white">
          <img src="{{ asset('assets/img/logo/logo.png') }}" alt="A31 Factory Logo" style="height: 120px; width: auto; margin-bottom: 2rem;">
          <h1 class="mb-3 fw-bold text-white">NHÀ MÁY A31</h1>
          <h3 class="mb-2 text-white">QUÂN CHỦNG PK-KQ</h3>
          <h4 class="mb-0 text-white-50">TRUNG TÂM CHỈ HUY ĐIỀU HÀNH SẢN XUẤT</h4>
        </div>
      </div>
    </div>
    <!-- /Left Side -->

    <!-- Login Form -->
    <div class="d-flex col-12 col-lg-5 align-items-center justify-content-center p-sm-5 p-4">
      <div class="w-px-400 mx-auto">
        <!-- Mobile Logo (visible only on small screens) -->
        <div class="d-lg-none text-center mb-4">
          <img src="{{ asset('assets/img/logo/logo.png') }}" alt="A31 Factory Logo" style="height: 80px; width: auto; margin-bottom: 1rem;">
          <h2 class="mb-2 text-primary fw-bold">NHÀ MÁY A31</h2>
          <h5 class="mb-1 text-secondary">QUÂN CHỦNG PK-KQ</h5>
          <h6 class="mb-3 text-muted">TRUNG TÂM CHỈ HUY ĐIỀU HÀNH SẢN XUẤT</h6>
        </div>
        <!-- /Mobile Logo -->

        @if (session('status'))
        <div class="alert alert-success mb-1 rounded-0" role="alert">
          <div class="alert-body">
            {{ session('status') }}
          </div>
        </div>
        @endif

        <form id="formAuthentication" class="mb-3" action="{{ route('login') }}" method="POST">
          @csrf
          <div class="mb-4">
            <label for="login-username" class="form-label fw-semibold">Tên đăng nhập</label>
            <input type="text" class="form-control form-control-lg @error('username') is-invalid @enderror" id="login-username" name="username" autofocus value="{{ old('username') }}" style="border-radius: 8px; padding: 12px 16px;">
            @error('username')
            <span class="invalid-feedback" role="alert">
              <span class="fw-medium">{{ $message }}</span>
            </span>
            @enderror
          </div>
          <div class="mb-4 form-password-toggle">
            <label class="form-label fw-semibold" for="login-password">Mật khẩu</label>
            <div class="input-group input-group-merge @error('password') is-invalid @enderror">
              <input type="password" id="login-password" class="form-control form-control-lg @error('password') is-invalid @enderror" name="password" aria-describedby="password" style="border-radius: 8px 0 0 8px; padding: 12px 16px;" />
              <span class="input-group-text cursor-pointer" style="border-radius: 0 8px 8px 0; padding: 12px 16px;"><i class="ti ti-eye-off"></i></span>
            </div>
            @error('password')
            <span class="invalid-feedback" role="alert">
              <span class="fw-medium">{{ $message }}</span>
            </span>
            @enderror
          </div>
          <div class="mb-4">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="remember-me" name="remember" {{ old('remember') ? 'checked' : '' }} checked>
              <label class="form-check-label" for="remember-me">
                Ghi nhớ đăng nhập
              </label>
            </div>
          </div>
          <button class="btn btn-primary btn-lg d-grid w-100 fw-semibold" type="submit" style="border-radius: 8px; padding: 12px;">ĐĂNG NHẬP</button>
        </form>
      </div>
    </div>
    <!-- /Login -->
  </div>
</div>
@endsection
