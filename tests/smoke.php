<?php
declare(strict_types=1);
require dirname(__DIR__).'/private/app/bootstrap.php';
assert(db()->query('SELECT 1')->fetchColumn() === 1);
foreach (['users','roles','permissions','products','companies','opportunities','documents','audit_logs'] as $table) {
    $q=db()->prepare('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?');
    $q->execute([$table]); assert((int)$q->fetchColumn() === 1, "$table is missing");
}
echo "Smoke tests passed.\n";
