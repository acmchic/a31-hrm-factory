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
            // Check and drop columns if they exist
            if (Schema::hasColumn('employees', 'first_name')) {
                $table->dropColumn('first_name');
            }
            if (Schema::hasColumn('employees', 'last_name')) {
                $table->dropColumn('last_name');
            }
            if (Schema::hasColumn('employees', 'father_name')) {
                $table->dropColumn('father_name');
            }
            if (Schema::hasColumn('employees', 'mother_name')) {
                $table->dropColumn('mother_name');
            }
            if (Schema::hasColumn('employees', 'birth_and_place')) {
                $table->dropColumn('birth_and_place');
            }
            if (Schema::hasColumn('employees', 'degree')) {
                $table->dropColumn('degree');
            }
            if (Schema::hasColumn('employees', 'notes')) {
                $table->dropColumn('notes');
            }
            
            // Rename columns if they exist
            if (Schema::hasColumn('employees', 'national_number')) {
                $table->renameColumn('national_number', 'CCCD');
            }
            if (Schema::hasColumn('employees', 'mobile')) {
                $table->renameColumn('mobile', 'phone');
            }
            if (Schema::hasColumn('employees', 'full_name')) {
                $table->renameColumn('full_name', 'name');
            }
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
