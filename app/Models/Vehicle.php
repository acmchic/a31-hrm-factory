<?php

namespace App\Models;

use App\Traits\CreatedUpdatedDeletedBy;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Vehicle extends Model
{
    use HasFactory, SoftDeletes, CreatedUpdatedDeletedBy;

    protected $fillable = [
        'name',
        'category',
        'license_plate',
        'brand',
        'model',
        'year',
        'color',
        'fuel_type',
        'capacity',
        'status',
        'description',
        'is_active',
    ];

    protected $casts = [
        'year' => 'integer',
        'capacity' => 'integer',
        'is_active' => 'boolean',
    ];

    // Relationships
    public function registrations(): HasMany
    {
        return $this->hasMany(VehicleRegistration::class);
    }

    // Scopes
    public function scopeActive($query)
    {
        return $query->where('is_active', true)->where('status', 'available');
    }

    public function scopeByCategory($query, $category)
    {
        return $query->where('category', $category);
    }

    // Attributes
    public function getFullNameAttribute()
    {
        return $this->name . ' (' . $this->license_plate . ')';
    }

    public function getStatusTextAttribute()
    {
        return match($this->status) {
            'available' => 'Sẵn sàng',
            'in_use' => 'Đang sử dụng',
            'maintenance' => 'Bảo trì',
            'broken' => 'Hỏng hóc',
            default => 'Không xác định'
        };
    }
}
