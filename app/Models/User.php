<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use App\Traits\CreatedUpdatedDeletedBy;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Fortify\TwoFactorAuthenticatable;
use Laravel\Jetstream\HasProfilePhoto;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    use CreatedUpdatedDeletedBy,
        HasApiTokens,
        HasFactory,
        HasProfilePhoto,
        HasRoles,
        Notifiable,
        SoftDeletes,
        TwoFactorAuthenticatable;

    protected $fillable = [
        'name',
        'username',
        'mobile',
        'mobile_verified_at',
        'email',
        'email_verified_at',
        'password',
        'profile_photo_path',
        'signature_path',
    ];

    protected $hidden = ['password', 'remember_token', 'two_factor_recovery_codes', 'two_factor_secret'];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    protected $appends = ['profile_photo_url'];

    // 👉 Links - Commented out since employee_id field was removed
    // public function employee(): BelongsTo
    // {
    //     return $this->belongsTo(Employee::class);
    // }

    // 👉 Attributes
    public function getEmployeeFullNameAttribute()
    {
        return $this->name;
    }
}
