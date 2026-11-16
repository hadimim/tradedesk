<?php
declare(strict_types=1);
require dirname(__DIR__).'/private/app/bootstrap.php';
if(PHP_SAPI!=='cli'){http_response_code(404);exit;}
$path=$argv[1]??'';
if(!$path||!is_file($path))throw new RuntimeException('Usage: php scripts/import-hs-catalog.php prepared.tsv');
$handle=fopen($path,'rb');$header=fgetcsv($handle,0,"\t");$rows=[];
while(($values=fgetcsv($handle,0,"\t"))!==false){if(count($values)!==count($header))continue;$rows[]=array_combine($header,$values);}fclose($handle);
$pdo=db();$userId=(int)$pdo->query("SELECT id FROM users WHERE status='active' ORDER BY id LIMIT 1")->fetchColumn();
if(!$userId)throw new RuntimeException('No active user is available as import owner.');
$source='UN Comtrade H6';$categories=[];$categoryCount=0;$productCount=0;$hsCount=0;
$pdo->beginTransaction();
try{
    $categoryUpsert=$pdo->prepare("INSERT INTO product_categories(parent_id,code,name_fa,name_en,description,source_name,source_code,source_parent_code,standard_unit_abbr,translation_status,sort_order,is_active,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,'machine_draft',?,1,NOW(),NOW()) ON DUPLICATE KEY UPDATE parent_id=VALUES(parent_id),name_en=VALUES(name_en),name_fa=IF(translation_status='reviewed',name_fa,VALUES(name_fa)),description=VALUES(description),source_name=VALUES(source_name),source_code=VALUES(source_code),source_parent_code=VALUES(source_parent_code),standard_unit_abbr=VALUES(standard_unit_abbr),updated_at=NOW()");
    foreach([2,4] as $level)foreach($rows as $row)if((int)$row['level']===$level){$parent=$level===4?($categories[$row['parent']]??null):null;$categoryUpsert->execute([$parent,$row['code'],$row['name_fa'],$row['name_en'],$row['name_en'],$source,$row['code'],$row['parent'],$row['standard_unit_abbr'],(int)$row['code']]);$id=(int)$pdo->query('SELECT id FROM product_categories WHERE code='.$pdo->quote($row['code']))->fetchColumn();$categories[$row['code']]=$id;$categoryCount++;}
    $productUpsert=$pdo->prepare("INSERT INTO products(internal_code,name_fa,name_en,category_id,short_description,full_description,source_name,source_code,standard_unit_abbr,translation_status,status,created_by,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,'machine_draft','draft',?,NOW(),NOW()) ON DUPLICATE KEY UPDATE name_en=VALUES(name_en),name_fa=IF(translation_status='reviewed',name_fa,VALUES(name_fa)),category_id=VALUES(category_id),short_description=VALUES(short_description),full_description=VALUES(full_description),source_name=VALUES(source_name),source_code=VALUES(source_code),standard_unit_abbr=VALUES(standard_unit_abbr),updated_at=NOW()");
    $findProduct=$pdo->prepare('SELECT id FROM products WHERE internal_code=?');
    $findHs=$pdo->prepare('SELECT id FROM product_hs_codes WHERE product_id=? AND code=? AND source_name=? LIMIT 1');
    $insertHs=$pdo->prepare("INSERT INTO product_hs_codes(product_id,code,code_level,description,classification_status,source_name,notes,created_by,created_at,updated_at) VALUES(?, ?, 6, ?, 'under_review', ?, 'Imported from supplied UN Comtrade H6 workbook; Persian text is machine-translated and requires review.', ?, NOW(), NOW())");
    foreach($rows as $row)if((int)$row['level']===6){$internal='HS6-'.$row['code'];$productUpsert->execute([$internal,$row['name_fa'],$row['name_en'],$categories[$row['parent']]??null,$row['name_fa'],$row['name_en'],$source,$row['code'],$row['standard_unit_abbr'],$userId]);$findProduct->execute([$internal]);$productId=(int)$findProduct->fetchColumn();$findHs->execute([$productId,$row['code'],$source]);if(!$findHs->fetchColumn()){$insertHs->execute([$productId,$row['code'],$row['name_en'],$source,$userId]);$hsCount++;}$productCount++;}
    audit('catalog_import','products',0,null,['source'=>$source,'categories'=>$categoryCount,'products'=>$productCount,'hs_codes_created'=>$hsCount]);
    $pdo->commit();echo json_encode(['categories'=>$categoryCount,'products'=>$productCount,'hs_codes_created'=>$hsCount],JSON_UNESCAPED_UNICODE|JSON_PRETTY_PRINT),"\n";
}catch(Throwable $error){if($pdo->inTransaction())$pdo->rollBack();throw $error;}
