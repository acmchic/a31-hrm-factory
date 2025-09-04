<?php

namespace App\Livewire\Sections\Menu;

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Livewire\Component;

class VerticalMenu extends Component
{
    public $role = null;
    public $menuData = null;

    public function mount()
    {
        // Get user role, default to 'Guest' if not authenticated
        if (Auth::check()) {
            $this->role = User::find(Auth::id())?->getRoleNames()->first() ?? 'Guest';
        } else {
            $this->role = 'Guest';
        }
        
        // Load menu data from JSON file
        $verticalMenuJson = file_get_contents(base_path('resources/menu/verticalMenu.json'));
        $this->menuData = json_decode($verticalMenuJson);
    }

    public function render()
    {
        return view('livewire.sections.menu.vertical-menu', [
            'menuData' => $this->menuData,
            'role' => $this->role
        ]);
    }
}
