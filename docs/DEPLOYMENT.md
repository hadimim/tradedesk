# نصب و استقرار TradeDesk

وب‌روت `public_html` است. فایل `private/.env` با دسترسی `0640` باید شامل `APP_NAME`، `APP_ENV`، `APP_DEBUG`، `APP_TIMEZONE`، `DB_HOST`، `DB_PORT`، `DB_DATABASE`، `DB_USERNAME`، `DB_PASSWORD`، `ADMIN_EMAIL` و `ADMIN_PASSWORD` باشد. سپس با کاربر سرویس وب اجرا کنید:

```bash
php database/migrate.php
php database/seed.php
php tests/smoke.php
```

هسته و تنظیمات در `private/app` و `private/config`، فایل‌های غیرعمومی در `private/storage` و schema در `database/migrations` هستند. secret واقعی در مستندات نیست؛ اطلاعات مدیر اولیه همین استقرار در `private/admin-credentials.txt` با دسترسی `0600` قرار دارد و باید پس از اولین ورود تغییر کند.

## پشتیبان‌گیری

```bash
mariadb-dump --single-transaction --routines --triggers DB_NAME > tradedesk.sql
tar -czf tradedesk-uploads.tar.gz private/storage/uploads
```

برای بازیابی، dump را در دیتابیس خالی و uploads را با همان مسیر و مالکیت بازیابی کنید؛ سپس migration را اجرا کنید. `.env` را جداگانه و رمزگذاری‌شده نگه دارید. `GET /api/health` سلامت برنامه را بررسی می‌کند.

## وابستگی‌های تنظیم‌نشده

- adapter و secret سرویس AI تنظیم نشده؛ پنل AI نمایش داده نمی‌شود.
- crawler، داده بیرونی و پیام‌رسان مطابق محدوده محصول عمداً وجود ندارند.
- وابستگی PDF سمت سرور نصب نیست؛ خروجی فعلی HTML چاپ‌پذیر/PDF مرورگر است.
