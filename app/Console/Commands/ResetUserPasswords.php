<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;

class ResetUserPasswords extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'users:reset-passwords {--user=} {--all}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Reset user passwords to their username';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        if ($this->option('user')) {
            // Reset specific user
            $username = $this->option('user');
            $user = User::where('username', $username)->first();
            
            if (!$user) {
                $this->error("User '{$username}' not found!");
                return 1;
            }
            
            $user->password = Hash::make($username);
            $user->save();
            
            $this->info("Password reset for user '{$user->name}' (username: {$username})");
            $this->info("New password: {$username}");
            
        } elseif ($this->option('all')) {
            // Reset all users
            if (!$this->confirm('Are you sure you want to reset ALL user passwords to their username?')) {
                $this->info('Operation cancelled.');
                return 0;
            }
            
            $users = User::all();
            $count = 0;
            
            foreach ($users as $user) {
                if ($user->username) {
                    $user->password = Hash::make($user->username);
                    $user->save();
                    $count++;
                    $this->info("Reset password for: {$user->name} (username: {$user->username})");
                }
            }
            
            $this->info("Reset passwords for {$count} users.");
            
        } else {
            $this->error('Please specify --user=username or --all option');
            return 1;
        }
        
        return 0;
    }
}
