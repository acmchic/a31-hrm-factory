<?php

// Bootstrap Laravel
require __DIR__ . '/../vendor/autoload.php';
$app = require __DIR__ . '/../bootstrap/app.php';

/** @var \Illuminate\Contracts\Console\Kernel $kernel */
$kernel = $app->make(\Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Illuminate\Support\Facades\DB;
use App\Models\User;
use App\Models\Employee;
use App\Models\Position;
use App\Models\Timeline;

// Load JSON
$jsonPath = storage_path('app/public/troops/quanso.json');
if (!file_exists($jsonPath)) {
    fwrite(STDERR, "JSON not found: {$jsonPath}\n");
    exit(1);
}
$data = json_decode(file_get_contents($jsonPath), true);
if (!is_array($data)) {
    fwrite(STDERR, "Invalid JSON structure.\n");
    exit(1);
}

$positionNameToId = Position::query()->pluck('id', 'name')->toArray();

$updatedEmployees = 0;
$updatedTimelines = 0;
$missingUsers = 0;
$positionsCreated = 0;

$members = [];
foreach ($data['departments'] ?? [] as $department) {
    foreach ($department['members'] ?? [] as $member) {
        $members[] = $member;
    }
    foreach ($department['teams'] ?? [] as $team) {
        foreach ($team['members'] ?? [] as $member) {
            $members[] = $member;
        }
    }
}

DB::beginTransaction();
try {
    foreach ($members as $member) {
        $username = $member['username'] ?? null;
        $positionName = trim((string)($member['position'] ?? ''));
        if (!$username || $positionName === '') {
            continue;
        }

        // Find or create position by name
        if (!isset($positionNameToId[$positionName])) {
            $position = Position::firstOrCreate(['name' => $positionName], ['code' => null]);
            $positionNameToId[$positionName] = $position->id;
            $positionsCreated++;
        }
        $positionId = $positionNameToId[$positionName];

        // Find user and employee
        $user = User::where('username', $username)->first();
        if (!$user) {
            $missingUsers++;
            continue;
        }
        $employee = Employee::where('user_id', $user->id)->first();
        if (!$employee) {
            $missingUsers++;
            continue;
        }

        // Update employee position_id
        if ($employee->position_id !== $positionId) {
            $employee->position_id = $positionId;
            $employee->save();
            $updatedEmployees++;
        }

        // Update latest/present timeline position
        $timeline = Timeline::where('employee_id', $employee->id)
            ->orderByRaw('CASE WHEN end_date IS NULL THEN 0 ELSE 1 END, id DESC')
            ->first();
        if ($timeline && $timeline->position_id !== $positionId) {
            $timeline->position_id = $positionId;
            $timeline->save();
            $updatedTimelines++;
        }
    }

    DB::commit();
} catch (\Throwable $e) {
    DB::rollBack();
    fwrite(STDERR, "Error: " . $e->getMessage() . "\n");
    exit(1);
}

echo json_encode([
    'updated_employees' => $updatedEmployees,
    'updated_timelines' => $updatedTimelines,
    'positions_created' => $positionsCreated,
    'missing_users_or_employees' => $missingUsers,
], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";



