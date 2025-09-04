<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Step 1: Update email data to extract username part only
        DB::statement("
            UPDATE users 
            SET email = SUBSTRING_INDEX(email, '@', 1) 
            WHERE email LIKE '%@%'
        ");
        
        // Step 2: Rename email column to username
        Schema::table('users', function (Blueprint $table) {
            $table->renameColumn('email', 'username');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Step 1: Rename username column back to email
        Schema::table('users', function (Blueprint $table) {
            $table->renameColumn('username', 'email');
        });
        
        // Step 2: Add @quandoi.local back to usernames that don't have @
        DB::statement("
            UPDATE users 
            SET email = CONCAT(email, '@quandoi.local') 
            WHERE email NOT LIKE '%@%'
        ");
    }
};
