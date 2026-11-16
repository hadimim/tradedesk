<?php
declare(strict_types=1);
require dirname(__DIR__).'/private/app/bootstrap.php';

$pdo=db();
$pdo->beginTransaction();
try {
    $roles=[['system_admin','مدیر سیستم'],['company_admin','مدیر شرکت'],['trade_manager','مدیر بازرگانی'],['trade_operator','کارشناس بازرگانی'],['viewer','مشاهده‌گر']];
    $insert=$pdo->prepare('INSERT IGNORE INTO roles(code,name,is_system_role,created_at,updated_at) VALUES(?,?,1,NOW(),NOW())');
    foreach($roles as $row)$insert->execute($row);

    $modules=['dashboard','opportunities','products','companies','contacts','tasks','prices','quotations','transport','insurance','documents','reports','settings','users','audit','references','regulatory','trade_statistics','trade_leads','files'];
    $operations=['view','create','edit','archive','delete','approve','export','import','issue','manage_settings'];
    $insert=$pdo->prepare('INSERT IGNORE INTO permissions(code,name,module,created_at) VALUES(?,?,?,NOW())');
    foreach($modules as $module)foreach($operations as $operation)$insert->execute(["$module.$operation","$module: $operation",$module]);

    $roleId=static fn(string $code):int=>(int)$pdo->query('SELECT id FROM roles WHERE code='.$pdo->quote($code))->fetchColumn();
    foreach(['system_admin','company_admin'] as $role)$pdo->exec('INSERT IGNORE INTO permission_role(role_id,permission_id) SELECT '.$roleId($role).',id FROM permissions');
    foreach(['viewer'=>['view'],'trade_operator'=>['view','create','edit','import'],'trade_manager'=>['view','create','edit','archive','approve','export','import','issue']] as $role=>$allowed){
        foreach($allowed as $operation)$pdo->exec('INSERT IGNORE INTO permission_role(role_id,permission_id) SELECT '.$roleId($role).",id FROM permissions WHERE code LIKE '%.$operation'");
    }

    $password=getenv('ADMIN_PASSWORD')?:bin2hex(random_bytes(12));
    $email=getenv('ADMIN_EMAIL')?:'admin@localhost';
    $insert=$pdo->prepare("INSERT INTO users(name,email,username,password,status,created_at,updated_at) VALUES('مدیر سیستم',?,'admin',?,'active',NOW(),NOW()) ON DUPLICATE KEY UPDATE updated_at=updated_at");
    $insert->execute([$email,password_hash($password,PASSWORD_ARGON2ID)]);
    $userId=(int)$pdo->query("SELECT id FROM users WHERE username='admin'")->fetchColumn();
    $pdo->prepare('INSERT IGNORE INTO role_user(user_id,role_id) VALUES(?,?)')->execute([$userId,$roleId('system_admin')]);

    $stages=['initial_review'=>'بررسی اولیه','information_gathering'=>'تکمیل اطلاعات','sourcing'=>'تأمین‌یابی','quotation'=>'استعلام و پیشنهاد','negotiation'=>'مذاکره','documents'=>'اسناد','payment'=>'پرداخت','logistics'=>'لجستیک','completed'=>'تکمیل','cancelled'=>'لغو'];
    $insert=$pdo->prepare('INSERT IGNORE INTO opportunity_stages(code,name,sort_order,is_terminal,is_active,created_at,updated_at) VALUES(?,?,?,?,1,NOW(),NOW())');
    $sort=10;foreach($stages as $code=>$name){$insert->execute([$code,$name,$sort,in_array($code,['completed','cancelled'],true)?1:0]);$sort+=10;}

    $referenceSets=[
        ['countries','INSERT IGNORE INTO countries(iso2,iso3,name_fa,name_en,is_active,created_at,updated_at) VALUES(?,?,?,?,1,NOW(),NOW())',[['IR','IRN','ایران','Iran'],['CN','CHN','چین','China'],['AE','ARE','امارات متحده عربی','UAE'],['TR','TUR','ترکیه','Turkey']]],
        ['currencies','INSERT IGNORE INTO currencies(code,name_fa,name_en,symbol,decimal_places,is_active,created_at,updated_at) VALUES(?,?,?,?,?,1,NOW(),NOW())',[['IRR','ریال','Iranian Rial','﷼',0],['USD','دلار آمریکا','US Dollar','$',2],['EUR','یورو','Euro','€',2],['AED','درهم امارات','UAE Dirham','د.إ',2]]],
        ['units','INSERT IGNORE INTO units(code,name_fa,name_en,dimension,is_active,created_at,updated_at) VALUES(?,?,?,?,1,NOW(),NOW())',[['kg','کیلوگرم','Kilogram','mass'],['ton','تن','Tonne','mass'],['pcs','عدد','Piece','count'],['ltr','لیتر','Litre','volume']]],
        ['transport','INSERT IGNORE INTO transport_methods(code,name_fa,name_en,is_active,created_at,updated_at) VALUES(?,?,?,1,NOW(),NOW())',[['road','جاده‌ای','Road'],['sea','دریایی','Sea'],['air','هوایی','Air'],['rail','ریلی','Rail']]],
    ];
    foreach($referenceSets as [, $sql, $rows]){$insert=$pdo->prepare($sql);foreach($rows as $row)$insert->execute($row);}
    $pdo->exec("INSERT INTO company_settings(setting_key,setting_value,updated_at) VALUES('company_name_fa','شرکت بازرگانی',NOW()),('company_name_en','Trade Company',NOW()),('timezone','Asia/Tehran',NOW()),('opportunity_prefix','OPP',NOW()),('document_prefix','DOC',NOW()),('trade_provider_mode','manual_import',NOW()) ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value),updated_at=NOW()");
    $pdo->commit();
    echo "Seed completed.\n";
} catch(Throwable $error){$pdo->rollBack();throw $error;}
