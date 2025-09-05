<?php

require __DIR__ . '/../vendor/autoload.php';
$app = require __DIR__ . '/../bootstrap/app.php';
/** @var \Illuminate\Contracts\Console\Kernel $kernel */
$kernel = $app->make(\Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;

$json = storage_path('app/public/troops/quanso.json');
if (!file_exists($json)) {
    fwrite(STDERR, "JSON not found: {$json}\n");
    exit(1);
}
$data = json_decode(file_get_contents($json), true);
if (!is_array($data)) {
    fwrite(STDERR, "Invalid JSON structure.\n");
    exit(1);
}

$usernames = [];
foreach ($data['departments'] ?? [] as $dept) {
    foreach ($dept['members'] ?? [] as $m) {
        if (!empty($m['username'])) $usernames[$m['username']] = true;
    }
    foreach ($dept['teams'] ?? [] as $team) {
        foreach ($team['members'] ?? [] as $m) {
            if (!empty($m['username'])) $usernames[$m['username']] = true;
        }
    }
}

$missing = [];
foreach (array_keys($usernames) as $username) {
    if (!User::where('username', $username)->exists()) {
        $missing[] = $username;
    }
}

echo json_encode([
    'missing_count' => count($missing),
    'missing' => $missing,
], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";



