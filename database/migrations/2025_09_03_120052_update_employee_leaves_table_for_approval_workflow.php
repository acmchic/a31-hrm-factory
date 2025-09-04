<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('employee_leave', function (Blueprint $table) {
            // Trạng thái phê duyệt
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending')->after('note');
            
            // Người phê duyệt
            $table->unsignedBigInteger('approved_by')->nullable()->after('status');
            $table->timestamp('approved_at')->nullable()->after('approved_by');
            
            // Lý do từ chối
            $table->text('rejection_reason')->nullable()->after('approved_at');
            
            // Chữ ký số
            $table->text('digital_signature')->nullable()->after('rejection_reason');
            $table->string('signature_certificate')->nullable()->after('digital_signature');
            
            // Workflow
            $table->enum('workflow_status', ['draft', 'submitted', 'under_review', 'approved', 'rejected'])->default('draft')->after('signature_certificate');
            $table->unsignedBigInteger('reviewer_id')->nullable()->after('workflow_status');
            $table->timestamp('reviewed_at')->nullable()->after('reviewer_id');
            
            // Foreign keys
            $table->foreign('approved_by')->references('id')->on('users')->onDelete('set null');
            $table->foreign('reviewer_id')->references('id')->on('users')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('employee_leave', function (Blueprint $table) {
            $table->dropForeign(['approved_by', 'reviewer_id']);
            $table->dropColumn([
                'status', 'approved_by', 'approved_at', 'rejection_reason',
                'digital_signature', 'signature_certificate', 'workflow_status',
                'reviewer_id', 'reviewed_at'
            ]);
        });
    }
};
