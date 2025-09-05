<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class ExportDatabase extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'db:export {--path=storage/db/} {--format=sql}';

    /**
     * The description of the console command.
     *
     * @var string
     */
    protected $description = 'Export toàn bộ database ra file SQL';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $path = $this->option('path');
        $format = $this->option('format');
        
        // Ensure directory exists
        $fullPath = storage_path($path);
        if (!file_exists($fullPath)) {
            mkdir($fullPath, 0755, true);
        }

        $this->info('Bắt đầu export database...');

        try {
            if ($format === 'sql') {
                $this->exportToSQL($fullPath);
            } else {
                $this->exportToJSON($fullPath);
            }

            $this->info('Export database hoàn thành!');
        } catch (\Exception $e) {
            $this->error('Lỗi export database: ' . $e->getMessage());
        }
    }

    private function exportToSQL($path)
    {
        // Fix path issue - remove duplicate storage
        $filename = str_replace('storage/storage/', 'storage/', $path) . '/hrms_database_' . date('Y_m_d_H_i_s') . '.sql';
        $sql = '';

        // Get database name
        $database = env('DB_DATABASE');
        
        // Add header
        $sql .= "-- HRMS Database Export\n";
        $sql .= "-- Generated on: " . date('Y-m-d H:i:s') . "\n";
        $sql .= "-- Database: {$database}\n\n";
        $sql .= "SET FOREIGN_KEY_CHECKS = 0;\n\n";

        // Get all tables
        $tables = DB::select('SHOW TABLES');
        $tableKey = 'Tables_in_' . $database;

        foreach ($tables as $table) {
            $tableName = $table->$tableKey;
            
            $this->info("Exporting table: {$tableName}");

            // Get table structure
            $createTable = DB::select("SHOW CREATE TABLE `{$tableName}`")[0];
            $sql .= "-- Structure for table `{$tableName}`\n";
            $sql .= "DROP TABLE IF EXISTS `{$tableName}`;\n";
            $sql .= $createTable->{'Create Table'} . ";\n\n";

            // Get table data
            $rows = DB::table($tableName)->get();
            
            if ($rows->count() > 0) {
                $sql .= "-- Data for table `{$tableName}`\n";
                
                foreach ($rows as $row) {
                    $values = [];
                    foreach ((array)$row as $value) {
                        if (is_null($value)) {
                            $values[] = 'NULL';
                        } else {
                            $values[] = "'" . addslashes($value) . "'";
                        }
                    }
                    
                    $sql .= "INSERT INTO `{$tableName}` VALUES (" . implode(', ', $values) . ");\n";
                }
                
                $sql .= "\n";
            }
        }

        $sql .= "SET FOREIGN_KEY_CHECKS = 1;\n";

        file_put_contents($filename, $sql);
        $this->info("SQL file saved: {$filename}");
    }

    private function exportToJSON($path)
    {
        // Fix path issue - remove duplicate storage
        $filename = str_replace('storage/storage/', 'storage/', $path) . '/hrms_database_' . date('Y_m_d_H_i_s') . '.json';
        $data = [];

        // Get database name
        $database = env('DB_DATABASE');
        
        // Get all tables
        $tables = DB::select('SHOW TABLES');
        $tableKey = 'Tables_in_' . $database;

        foreach ($tables as $table) {
            $tableName = $table->$tableKey;
            
            $this->info("Exporting table: {$tableName}");

            // Get table data
            $rows = DB::table($tableName)->get();
            $data[$tableName] = $rows->toArray();
        }

        // Add metadata
        $export = [
            'metadata' => [
                'database' => $database,
                'exported_at' => date('Y-m-d H:i:s'),
                'total_tables' => count($data),
                'total_records' => array_sum(array_map('count', $data))
            ],
            'data' => $data
        ];

        file_put_contents($filename, json_encode($export, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
        $this->info("JSON file saved: {$filename}");
    }
}
