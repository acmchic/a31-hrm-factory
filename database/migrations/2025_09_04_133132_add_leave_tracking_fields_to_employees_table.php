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
            $table->integer('annual_leave_total')->default(12)->after('annual_leave_balance')->comment('Tổng số ngày nghỉ phép trong năm');
            $table->integer('annual_leave_used')->default(0)->after('annual_leave_total')->comment('Số ngày nghỉ phép đã sử dụng');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('employees', function (Blueprint $table) {
            $table->dropColumn(['annual_leave_total', 'annual_leave_used']);
        });
    }
};
