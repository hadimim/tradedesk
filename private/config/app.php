<?php
declare(strict_types=1);
return ['name'=>getenv('APP_NAME')?:'TradeDesk','env'=>getenv('APP_ENV')?:'production','debug'=>filter_var(getenv('APP_DEBUG')?:false,FILTER_VALIDATE_BOOL),'timezone'=>getenv('APP_TIMEZONE')?:'Asia/Tehran','upload_max'=>10485760,'allowed_mimes'=>['application/pdf','image/jpeg','image/png','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','text/csv']];
