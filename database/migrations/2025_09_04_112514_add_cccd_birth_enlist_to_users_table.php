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
        Schema::table('users', function (Blueprint $table) {
            $table->string('cccd')->nullable()->after('mobile')->comment('Số căn cước công dân');
            $table->date('date_of_birth')->nullable()->after('cccd')->comment('Ngày sinh');
            $table->date('enlist_date')->nullable()->after('date_of_birth')->comment('Ngày nhập ngũ');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['cccd', 'date_of_birth', 'enlist_date']);
        });
    }
};
