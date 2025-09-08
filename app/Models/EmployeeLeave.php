<?php

namespace App\Models;

use App\Traits\CreatedUpdatedDeletedBy;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class EmployeeLeave extends Model
{
    use CreatedUpdatedDeletedBy, HasFactory, SoftDeletes;

    protected $table = 'employee_leave';

    protected $fillable = [
        'id',
        'employee_id',
        'leave_id',
        'from_date',
        'to_date',
        'start_at',
        'end_at',
        'note',
        'is_authorized',
        'is_checked',
        'status',
        'approved_by',
        'approved_at',
        'rejection_reason',
        'digital_signature',
        'signature_certificate',
        'signed_pdf_path',
        'template_pdf_path',
        'workflow_status',
        'reviewer_id',
        'reviewed_at',
    ];

    protected $hidden = [
        'is_authorized',
        'is_checked',
        'deleted_by',
        'deleted_at',
    ];

    protected $casts = [
        'from_date' => 'date',
        'to_date' => 'date',
        'approved_at' => 'datetime',
        'reviewed_at' => 'datetime',
    ];

    // Relationships
    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }

    public function leave()
    {
        return $this->belongsTo(Leave::class);
    }

    public function approvedBy()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    public function reviewer()
    {
        return $this->belongsTo(User::class, 'reviewer_id');
    }

    // Accessors
    public function getStatusTextAttribute()
    {
        return match($this->status) {
            'pending' => 'Chờ phê duyệt',
            'approved' => 'Đã phê duyệt',
            'rejected' => 'Bị từ chối',
            default => 'Không xác định'
        };
    }

    public function getWorkflowStatusTextAttribute()
    {
        return match($this->workflow_status) {
            'draft' => 'Bản nháp',
            'submitted' => 'Đã gửi',
            'under_review' => 'Đang xem xét',
            'approved' => 'Đã phê duyệt',
            'rejected' => 'Bị từ chối',
            default => 'Không xác định'
        };
    }

    public function getIsPendingAttribute()
    {
        return $this->status === 'pending';
    }

    public function getIsApprovedAttribute()
    {
        return $this->status === 'approved';
    }

    public function getIsRejectedAttribute()
    {
        return $this->status === 'rejected';
    }
}
