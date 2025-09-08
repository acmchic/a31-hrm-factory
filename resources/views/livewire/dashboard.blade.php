<div>

  @php
  $configData = Helper::appClasses();
  use App\Models\Employee;
  use Carbon\Carbon;
  $isMenu = false; // Hide sidebar menu on dashboard
  @endphp

  @section('title', 'Dashboard - Nhà Máy A31')

  @section('vendor-style')

  @endsection

  @section('page-style')
  <style>
    .software-module-card {
      transition: all 0.3s ease;
      border: 1px solid #e9ecef;
      height: 200px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-decoration: none;
      color: inherit;
      cursor: pointer;
    }

    .software-module-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
      text-decoration: none;
      color: inherit;
    }

    .module-icon {
      font-size: 3rem;
      margin-bottom: 1rem;
      color: #7367f0;
    }

    .module-title {
      font-size: 1.2rem;
      font-weight: 600;
      margin-bottom: 0.5rem;
      text-align: center;
    }

    .module-description {
      font-size: 0.9rem;
      color: #6c757d;
      text-align: center;
    }

    .module-status {
      font-size: 0.8rem;
      margin-top: 0.5rem;
    }

    .header-section {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      color: #495057;
      padding: 2rem;
      border-radius: 10px;
      margin-bottom: 2rem;
      text-align: center;
      position: relative;
      border: 1px solid #dee2e6;
    }

    .factory-logo {
      height: 60px;
      width: auto;
      margin-bottom: 1rem;
    }
  </style>
  @endsection

  {{-- Alerts --}}
  @include('_partials/_alerts/alert-general')


  <!-- Factory Header -->
  <div class="header-section">
    <img src="{{ asset('assets/img/logo/logo.png') }}" alt="A31 Factory Logo" class="factory-logo">
    <h2 class="mb-1">Nhà Máy A31 - Quân Chủng PK-KQ</h2>
    <h5 class="mb-0">TRUNG TÂM CHỈ HUY ĐIỀU HÀNH SẢN XUẤT</h5>
    <div class="position-absolute top-0 end-0 p-3">
      <div class="text-end text-primary">
        <h6 id="date" class="mb-1"></h6>
        <h6 id="time" class="mb-0"></h6>
      </div>
    </div>
  </div>

  <!-- Software Modules Grid -->
  <div class="row">
    <!-- Module 1: Báo cáo quân số -->
    <div class="col-lg-4 col-md-6 col-12 mb-4">
      <div class="card software-module-card" onclick="window.location.href='{{ route('structure-employees') }}'">
        <div class="card-body text-center">
          <i class="ti ti-users module-icon"></i>
          <h5 class="module-title">Phần mềm Báo cáo quân số</h5>
          <p class="module-description">Quản lý nhân sự và báo cáo quân số hiện tại</p>
          <span class="badge bg-success module-status">Đang hoạt động</span>
        </div>
      </div>
    </div>

    <!-- Module 2: Đăng ký xe -->
    <div class="col-lg-4 col-md-6 col-12 mb-4">
      <div class="card software-module-card" onclick="window.location.href='{{ route('vehicle-registration') }}'">
        <div class="card-body text-center">
          <i class="ti ti-car module-icon"></i>
          <h5 class="module-title">Phần mềm Đăng ký xe</h5>
          <p class="module-description">Hệ thống đăng ký và quản lý phương tiện</p>
          <span class="badge bg-success module-status">Đang hoạt động</span>
        </div>
      </div>
    </div>

    <!-- Module 3: Xin nghỉ phép -->
    <div class="col-lg-4 col-md-6 col-12 mb-4">
      <div class="card software-module-card" onclick="window.location.href='{{ route('attendance-leaves') }}'">
        <div class="card-body text-center">
          <i class="ti ti-calendar-time module-icon"></i>
          <h5 class="module-title">Phần mềm Xin nghỉ phép</h5>
          <p class="module-description">Đăng ký và quản lý đơn xin nghỉ phép</p>
          <span class="badge bg-success module-status">Đang hoạt động</span>
        </div>
      </div>
    </div>
  </div>


  @push('custom-scripts')
  <script>
    function updateClock() {
            const now = new Date();
            const dateOptions = {
                weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
            };
            const timeOptions = {
                hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false
            };

            const formattedDate = now.toLocaleDateString('vi-VN', dateOptions);
            const formattedTime = now.toLocaleTimeString('vi-VN', timeOptions);

            document.getElementById('date').innerHTML = formattedDate;
            document.getElementById('time').innerHTML = formattedTime;
        }

        setInterval(updateClock, 1000); // Update every second
        updateClock(); // Initial call to display clock immediately
  </script>
  @endpush
</div>
