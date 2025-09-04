<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('vehicle_registrations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade'); // Người đăng ký
            $table->foreignId('vehicle_id')->constrained()->onDelete('cascade'); // Xe đăng ký
            $table->date('departure_date'); // Ngày đi
            $table->date('return_date'); // Ngày về
            $table->time('departure_time'); // Giờ đi
            $table->time('return_time'); // Giờ về
            $table->text('route'); // Tuyến đường
            $table->text('purpose'); // Lý do xin xe
            $table->integer('passenger_count')->default(1); // Số người đi
            $table->string('driver_name')->nullable(); // Tên lái xe
            $table->string('driver_license')->nullable(); // Bằng lái xe
            
            // Status workflow
            $table->enum('status', ['pending', 'dept_approved', 'approved', 'rejected'])->default('pending');
            $table->enum('workflow_status', ['submitted', 'dept_review', 'director_review', 'approved', 'rejected'])->default('submitted');
            
            // Department approval
            $table->foreignId('department_approved_by')->nullable()->constrained('users')->onDelete('set null');
            $table->timestamp('department_approved_at')->nullable();
            $table->text('digital_signature_dept')->nullable();
            
            // Director approval  
            $table->foreignId('director_approved_by')->nullable()->constrained('users')->onDelete('set null');
            $table->timestamp('director_approved_at')->nullable();
            $table->text('digital_signature_director')->nullable();
            
            // Rejection
            $table->text('rejection_reason')->nullable();
            $table->enum('rejection_level', ['department', 'director'])->nullable(); // Cấp nào từ chối
            
            $table->string('created_by')->nullable();
            $table->string('updated_by')->nullable();
            $table->string('deleted_by')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('vehicle_registrations');
    }
};
