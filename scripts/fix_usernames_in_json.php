<?php

// Normalize duplicate usernames in quanso.json by appending birth year (last 2 digits) for duplicates.

$jsonPath = __DIR__ . '/../storage/app/public/troops/quanso.json';
$backupPath = $jsonPath . '.bak';

if (!file_exists($jsonPath)) {
    fwrite(STDERR, "JSON not found: {$jsonPath}\n");
    exit(1);
}

$raw = file_get_contents($jsonPath);
$data = json_decode($raw, true);
if (!is_array($data)) {
    fwrite(STDERR, "Invalid JSON structure.\n");
    exit(1);
}

// Helper: get year and last two digits
$getYear = function ($dob) {
    if (!$dob) return null;
    $dob = trim((string)$dob);
    // Formats: YYYY, DD/MM/YYYY, D/M/YY, etc.
    if (preg_match('/^\d{4}$/', $dob)) {
        return (int)$dob;
    }
    if (preg_match('/^(\d{1,2})\/(\d{1,2})\/(\d{2,4})$/', $dob, $m)) {
        $y = $m[3];
        if (strlen($y) === 2) {
            $y = (int)('19' . $y);
        }
        return (int)$y;
    }
    // MM/YY style enlist might slip in; ignore
    return null;
};

$seen = [];
$changed = [];

foreach ($data['departments'] ?? [] as &$dept) {
    foreach (['members','teams'] as $groupKey) {
        if ($groupKey === 'teams') {
            foreach ($dept['teams'] ?? [] as &$team) {
                foreach ($team['members'] ?? [] as &$member) {
                    $u = $member['username'] ?? null;
                    if (!$u) continue;
                    if (!isset($seen[$u])) { $seen[$u] = 1; continue; }
                    // duplicate: append birth year last 2 digits
                    $year = $getYear($member['dob']);
                    $suffix = $year ? substr((string)$year, -2) : '00';
                    $newU = $u . $suffix;
                    // ensure unique if still exists
                    $seq = 2;
                    while (isset($seen[$newU])) {
                        $newU = $u . $suffix . $seq;
                        $seq++;
                    }
                    $changed[] = [$u, $newU];
                    $member['username'] = $newU;
                    $seen[$newU] = 1;
                }
                unset($member);
            }
            unset($team);
        } else {
            foreach ($dept['members'] ?? [] as &$member) {
                $u = $member['username'] ?? null;
                if (!$u) continue;
                if (!isset($seen[$u])) { $seen[$u] = 1; continue; }
                $year = $getYear($member['dob']);
                $suffix = $year ? substr((string)$year, -2) : '00';
                $newU = $u . $suffix;
                $seq = 2;
                while (isset($seen[$newU])) {
                    $newU = $u . $suffix . $seq;
                    $seq++;
                }
                $changed[] = [$u, $newU];
                $member['username'] = $newU;
                $seen[$newU] = 1;
            }
            unset($member);
        }
    }
}
unset($dept);

// Backup and write
if (!copy($jsonPath, $backupPath)) {
    fwrite(STDERR, "Failed to create backup at {$backupPath}\n");
}

file_put_contents($jsonPath, json_encode($data, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));

echo json_encode([
    'backup' => basename($backupPath),
    'changes' => count($changed),
    'changed_examples' => array_slice($changed, 0, 10),
], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";



