<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class AdminUserSeeder extends Seeder
{
    public function run(): void
    {
        // Check if admin user already exists
        $existingAdmin = User::where('username', 'admin')->first();
        
        if (!$existingAdmin) {
            User::create([
                'name' => 'Administrator A31',
                'employee_id' => '1',
                'username' => 'admin',
                'password' => bcrypt('admin'),
                'profile_photo_path' => 'profile-photos/.default-photo.jpg',
            ]);
            
            echo "Admin user created: admin/admin\n";
        } else {
            echo "Admin user already exists\n";
        }
    }
}
