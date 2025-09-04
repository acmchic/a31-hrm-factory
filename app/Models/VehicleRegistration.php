<?php

namespace App\Models;

use App\Traits\CreatedUpdatedDeletedBy;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class VehicleRegistration extends Model
{
    use HasFactory, SoftDeletes, CreatedUpdatedDeletedBy;

    protected $fillable = [
        'user_id',
        'vehicle_id',
        'departure_date',
        'return_date',
        'departure_time',
        'return_time',
        'route',
        'purpose',
        'passenger_count',
        'driver_name',
        'driver_license',
        'status',
        'workflow_status',
        'department_approved_by',
        'department_approved_at',
        'director_approved_by', 
        'director_approved_at',
        'rejection_reason',
        'rejection_level',
        'digital_signature_dept',
        'digital_signature_director',
    ];

    protected $casts = [
        'departure_date' => 'date',
        'return_date' => 'date',
        'departure_time' => 'datetime',
        'return_time' => 'datetime',
        'department_approved_at' => 'datetime',
        'director_approved_at' => 'datetime',
        'passenger_count' => 'integer',
    ];

    // Relationships
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function vehicle(): BelongsTo
    {
        return $this->belongsTo(Vehicle::class);
    }

    public function departmentApprover(): BelongsTo
    {
        return $this->belongsTo(User::class, 'department_approved_by');
    }

    public function directorApprover(): BelongsTo
    {
        return $this->belongsTo(User::class, 'director_approved_by');
    }

    // Attributes
    public function getStatusTextAttribute()
    {
        return match($this->status) {
            'pending' => 'Chờ phê duyệt',
            'dept_approved' => 'Trưởng phòng đã duyệt',
            'approved' => 'Đã phê duyệt',
            'rejected' => 'Bị từ chối',
            default => 'Không xác định'
        };
    }

    public function getWorkflowStatusTextAttribute()
    {
        return match($this->workflow_status) {
            'submitted' => 'Đã gửi',
            'dept_review' => 'Trưởng phòng đang xem xét',
            'director_review' => 'Giám đốc đang xem xét',
            'approved' => 'Đã hoàn tất',
            'rejected' => 'Bị từ chối',
            default => 'Không xác định'
        };
    }

    public function canBeApprovedByDepartment()
    {
        return $this->status === 'pending' && $this->workflow_status === 'submitted';
    }

    public function canBeApprovedByDirector()
    {
        return $this->status === 'dept_approved' && $this->workflow_status === 'director_review';
    }
}
