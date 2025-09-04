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
        Schema::create('vehicles', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Tên xe
            $table->string('category'); // Danh mục xe (in đậm trong Excel)
            $table->string('license_plate')->unique(); // Biển số xe
            $table->string('brand')->nullable(); // Hãng xe
            $table->string('model')->nullable(); // Dòng xe
            $table->integer('year')->nullable(); // Năm sản xuất
            $table->string('color')->nullable(); // Màu sắc
            $table->string('fuel_type')->nullable(); // Loại nhiên liệu
            $table->integer('capacity')->nullable(); // Số chỗ ngồi
            $table->enum('status', ['available', 'in_use', 'maintenance', 'broken'])->default('available');
            $table->text('description')->nullable(); // Mô tả
            $table->boolean('is_active')->default(true);
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
        Schema::dropIfExists('vehicles');
    }
};
