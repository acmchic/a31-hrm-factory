<?php

namespace App\Models;

use App\Traits\CreatedUpdatedDeletedBy;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Leave extends Model
{
    use CreatedUpdatedDeletedBy, HasFactory, SoftDeletes;

    protected $fillable = [
        'name', 
        'is_instantly', 
        'is_accumulative', 
        'discount_rate', 
        'days_limit', 
        'minutes_limit', 
        'notes'
    ];

    // 👉 Links
    public function employees(): BelongsToMany
    {
        return $this->belongsToMany(Employee::class)->withPivot(
            'id',
            'from_date',
            'to_date',
            'start_at',
            'end_at',
            'note',
            'is_authorized',
            'is_checked',
            'created_by',
            'updated_by',
            'deleted_by',
            'created_at',
            'updated_at',
            'deleted_at'
        );
    }
}
