<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\User;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            ContractsSeeder::class,
            EmployeesSeeder::class,

            AdminUserSeeder::class,

            CenterSeeder::class,
            DepartmentSeeder::class,
            PositionSeeder::class,
            TimelineSeeder::class,
        ]);

        if (file_exists('database/seeders/SettingsSeeder.php')) {
            $this->call([
                SettingsSeeder::class,
            ]);
        }

        // Create roles if they don't exist
        $adminRole = Role::firstOrCreate(['name' => 'Admin']);
        $hrRole = Role::firstOrCreate(['name' => 'HR']);
        $ccRole = Role::firstOrCreate(['name' => 'CC']);
        $amRole = Role::firstOrCreate(['name' => 'AM']);
        $crRole = Role::firstOrCreate(['name' => 'CR']);

        // Assign Admin role to first user
        $admin = User::where('username', 'admin')->first();
        if ($admin) {
            $admin->assignRole($adminRole);
            echo "Admin role assigned to user: {$admin->username}\n";
        }
    }
}
