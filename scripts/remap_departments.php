<?php

// Bootstrap Laravel
require __DIR__ . '/../vendor/autoload.php';
$app = require __DIR__ . '/../bootstrap/app.php';

/** @var \Illuminate\Contracts\Console\Kernel $kernel */
$kernel = $app->make(\Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use App\Models\User;
use App\Models\Employee;
use App\Models\Department;
use App\Models\Timeline;

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

// Build username => department name
$usernameToDepartmentName = [];
foreach ($data['departments'] ?? [] as $dept) {
    $deptName = trim((string)($dept['name'] ?? ''));
    foreach ($dept['members'] ?? [] as $member) {
        if (!empty($member['username'])) {
            $usernameToDepartmentName[$member['username']] = $deptName;
        }
    }
    foreach ($dept['teams'] ?? [] as $team) {
        foreach ($team['members'] ?? [] as $member) {
            if (!empty($member['username'])) {
                $usernameToDepartmentName[$member['username']] = $deptName;
            }
        }
    }
}

// Build normalized department name => id mapping
$deptNameToId = [];
foreach (Department::query()->pluck('id', 'name') as $name => $id) {
    $norm = Str::lower(Str::ascii(trim($name)));
    $deptNameToId[$norm] = $id;
}

$updatedEmployees = 0;
$updatedTimelines = 0;
$missingUsers = 0;
$departmentsCreated = 0;

DB::beginTransaction();
try {
    foreach ($usernameToDepartmentName as $username => $deptName) {
        // Ensure department exists (normalize for matching "Ban Chính trị" vs variants)
        $normName = Str::lower(Str::ascii($deptName));
        if (!isset($deptNameToId[$normName])) {
            $dept = Department::firstOrCreate(['name' => $deptName], [
                'created_by' => 'System',
                'updated_by' => 'System',
            ]);
            $deptNameToId[$normName] = $dept->id;
            $departmentsCreated++;
        }
        $deptId = $deptNameToId[$normName];

        // Find user and employee by username
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

        if ($employee->department_id !== $deptId) {
            $employee->department_id = $deptId;
            $employee->save();
            $updatedEmployees++;
        }

        // Update latest/present timeline department
        $timeline = Timeline::where('employee_id', $employee->id)
            ->orderByRaw('CASE WHEN end_date IS NULL THEN 0 ELSE 1 END, id DESC')
            ->first();
        if ($timeline && $timeline->department_id !== $deptId) {
            $timeline->department_id = $deptId;
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
    'departments_created' => $departmentsCreated,
    'missing_users_or_employees' => $missingUsers,
], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";


