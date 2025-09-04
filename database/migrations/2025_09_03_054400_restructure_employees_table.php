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
        Schema::table('employees', function (Blueprint $table) {
            // Bỏ các trường không cần thiết
            $table->dropColumn([
                'first_name',
                'last_name', 
                'father_name',
                'mother_name',
                'birth_and_place',
                'degree',
                'notes'
            ]);
            
            // Đổi tên national_number thành CCCD
            $table->renameColumn('national_number', 'CCCD');
            
            // Đổi tên mobile thành phone
            $table->renameColumn('mobile', 'phone');
            
            // Đổi tên full_name thành name
            $table->renameColumn('full_name', 'name');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('employees', function (Blueprint $table) {
            // Khôi phục các trường đã bỏ
            $table->string('first_name')->nullable();
            $table->string('last_name')->nullable();
            $table->string('father_name')->nullable();
            $table->string('mother_name')->nullable();
            $table->string('birth_and_place')->nullable();
            $table->string('degree')->nullable();
            $table->text('notes')->nullable();
            
            // Khôi phục tên cột
            $table->renameColumn('CCCD', 'national_number');
            $table->renameColumn('phone', 'mobile');
            $table->renameColumn('name', 'full_name');
        });
    }
};
