<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Spatie\Permission\Models\Role;

class SetupRoles extends Command
{
    protected $signature = 'setup:roles';
    protected $description = 'Setup required roles for the application';

    public function handle()
    {
        $roles = ['Admin', 'HR', 'CC', 'AM'];
        
        $this->info('Setting up roles...');
        
        foreach ($roles as $roleName) {
            $role = Role::firstOrCreate([
                'name' => $roleName,
                'guard_name' => 'web'
            ]);
            
            $this->info("✓ Role '{$roleName}' created/verified");
        }
        
        $this->info('All roles setup complete!');
        
        // Show current roles
        $allRoles = Role::pluck('name')->toArray();
        $this->table(['Roles in Database'], array_map(fn($role) => [$role], $allRoles));
        
        return 0;
    }
}