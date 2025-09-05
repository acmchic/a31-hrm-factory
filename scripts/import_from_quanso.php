<?php

require __DIR__ . '/../vendor/autoload.php';
$app = require __DIR__ . '/../bootstrap/app.php';
/** @var \Illuminate\Contracts\Console\Kernel $kernel */
$kernel = $app->make(\Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Employee;
use App\Models\Department;
use App\Models\Position;

function parseDateString(?string $dateString): ?string {
    if (!$dateString) return null;
    $dateString = trim($dateString);
    if ($dateString === '') return null;

    // Remove any non digit and non slash characters
    $clean = preg_replace('/[^0-9\/]/', '', $dateString);
    if ($clean === '') return null;

    // Year only
    if (preg_match('/^\d{4}$/', $clean)) {
        return $clean . '-01-01';
    }

    // d/m/y or m/y
    $parts = explode('/', $clean);
    if (count($parts) === 2) {
        list($m, $y) = $parts;
        $m = (int)$m; $y = (int)$y;
        if ($m < 1 || $m > 12) return null;
        if ($y < 100) $y = 1900 + $y; // assume 19xx
        return sprintf('%04d-%02d-01', $y, $m);
    } elseif (count($parts) === 3) {
        list($d, $m, $y) = $parts;
        $d = (int)$d; $m = (int)$m; $y = (int)$y;
        if ($y < 100) $y = 1900 + $y;
        if ($m < 1 || $m > 12) return null;
        if ($d < 1 || $d > 31) $d = 1;
        return sprintf('%04d-%02d-%02d', $y, $m, $d);
    }

    // Fallback: find three groups of digits
    if (preg_match_all('/\d+/', $clean, $ms) && count($ms[0]) >= 2) {
        $nums = $ms[0];
        if (count($nums) === 2) {
            $m = (int)$nums[0]; $y = (int)$nums[1];
            if ($y < 100) $y = 1900 + $y;
            if ($m < 1 || $m > 12) return null;
            return sprintf('%04d-%02d-01', $y, $m);
        } else {
            $d = (int)$nums[0]; $m = (int)$nums[1]; $y = (int)$nums[2];
            if ($y < 100) $y = 1900 + $y;
            if ($m < 1 || $m > 12) return null;
            if ($d < 1 || $d > 31) $d = 1;
            return sprintf('%04d-%02d-%02d', $y, $m, $d);
        }
    }
    return null;
}

$jsonPath = storage_path('app/public/troops/quanso.json');
if (!file_exists($jsonPath)) {
    fwrite(STDERR, "JSON not found: {$jsonPath}\n");
    exit(1);
}
$data = json_decode(file_get_contents($jsonPath), true);
if (!$data) {
    fwrite(STDERR, "Invalid JSON file.\n");
    exit(1);
}

DB::beginTransaction();
try {
    DB::statement('SET FOREIGN_KEY_CHECKS=0');
    DB::table('employee_leave')->truncate();
    DB::table('employees')->truncate();
    DB::table('users')->truncate();
    DB::statement('SET FOREIGN_KEY_CHECKS=1');

    $imported = 0;
    // Generate unique placeholders where required by NOT NULL or UNIQUE constraints
    $usedPhones = [];
    $phoneCounter = 0;
    $makePhone = function () use (&$usedPhones, &$phoneCounter) {
        do {
            $phoneCounter++;
            $phone = '09' . str_pad((string)$phoneCounter, 8, '0', STR_PAD_LEFT);
        } while (isset($usedPhones[$phone]));
        $usedPhones[$phone] = true;
        return $phone;
    };

    $usedCCCD = [];
    $makeUniqueCCCD = function (?string $base, ?string $dob) use (&$usedCCCD) {
        $cccd = $base ?: 'cc' . substr((string)crc32(uniqid('', true)), 0, 8);
        if (!isset($usedCCCD[$cccd])) { $usedCCCD[$cccd] = true; return $cccd; }
        // append birth year last 2 digits
        $year = null;
        if ($dob) {
            if (preg_match('/^(\d{4})/', $dob, $m)) { $year = $m[1]; }
        }
        $suffix = $year ? substr($year, -2) : '00';
        $try = $cccd . $suffix;
        $i = 2;
        while (isset($usedCCCD[$try])) { $try = $cccd . $suffix . $i; $i++; }
        $usedCCCD[$try] = true;
        return $try;
    };
    foreach ($data['departments'] as $deptData) {
        $department = Department::firstOrCreate(['name' => $deptData['name']], [
            'created_by' => 'System', 'updated_by' => 'System'
        ]);

        $membersGroups = [];
        if (!empty($deptData['members'])) $membersGroups[] = $deptData['members'];
        foreach ($deptData['teams'] ?? [] as $team) {
            if (!empty($team['members'])) $membersGroups[] = $team['members'];
        }

        foreach ($membersGroups as $members) {
            foreach ($members as $member) {
                $position = Position::firstOrCreate(['name' => $member['position'] ?? ''], [
                    'code' => substr($member['position'] ?? '', 0, 10),
                    'description' => $member['position'] ?? '',
                    'vacancies_count' => 1,
                    'created_by' => 'System', 'updated_by' => 'System'
                ]);

                $username = $member['username'] ?? null;
                $email = ($username ?: ('user' . uniqid())) . '@quandoi.local';
                $counter = 1;
                while (User::where('email', $email)->exists()) {
                    $email = ($username ?: ('user' . uniqid())) . '_' . $counter . '@quandoi.local';
                    $counter++;
                }

                $user = User::create([
                    'name' => $member['full_name'] ?? 'No Name',
                    'username' => $username,
                    'email' => $email,
                    'password' => Hash::make('123456'),
                    'date_of_birth' => parseDateString($member['dob'] ?? null),
                    'enlist_date' => parseDateString($member['enlist_td'] ?? null),
                    'email_verified_at' => now(),
                    'created_by' => 'System', 'updated_by' => 'System',
                ]);

                $dobYmd = parseDateString($member['dob'] ?? null);
                $enlistYmd = parseDateString($member['enlist_td'] ?? null);
                Employee::create([
                    'user_id' => $user->id,
                    'name' => $member['full_name'] ?? 'No Name',
                    'date_of_birth' => $dobYmd,
                    'enlist_date' => $enlistYmd,
                    'rank_code' => $member['rank_code'] ?? null,
                    'position_id' => $position->id,
                    'department_id' => $department->id,
                    'is_active' => true,
                    'CCCD' => $makeUniqueCCCD($username, $dobYmd),
                    'phone' => $makePhone(),
                    'address' => '',
                    'gender' => 1,
                    'start_date' => $enlistYmd ?? now()->format('Y-m-d'),
                ]);

                $imported++;
            }
        }
    }

    DB::commit();
    echo json_encode(['imported' => $imported], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";
} catch (\Throwable $e) {
    DB::rollBack();
    fwrite(STDERR, "Error: " . $e->getMessage() . "\n");
    exit(1);
}


