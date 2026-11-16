# استقرار، پشتیبان و بازگشت

وب‌روت دامنه باید `public_html` باشد و PHP 8.3 با PDO MySQL و MariaDB در دسترس باشد. `private/.env` موجود را overwrite نکنید؛ دسترسی پیشنهادی `0640` و مالک آن کاربر سرویس وب است. کل `private` و به‌ویژه `storage` نباید از وب قابل سرو باشد.

## نصب/ارتقا

1. از DB با `mariadb-dump --single-transaction --routines --triggers` و از `private/storage` پشتیبان بگیرید.
2. کد شاخه `rebuild/tradedesk-v2` را deploy کنید.
3. با کاربر سرویس اجرا کنید:

```bash
php database/migrate.php
php database/seed.php
php tests/smoke.php
```

4. وب‌روت، `/api/health`، ورود، یک فهرست و refresh یک صفحه جزئیات را بررسی کنید. پوشه‌ها `0750`/`0755` و فایل خصوصی `.env` و backupها `0640`/`0600` باشند.

Seed فقط نقش/مجوز، مراحل، کشور، ارز، واحد، روش حمل و تنظیمات پایه ایجاد می‌کند؛ شرکت، HS، قیمت یا آمار واقعی نمونه نمی‌سازد. مدیر اولیه از `ADMIN_EMAIL` و `ADMIN_PASSWORD` محیط ساخته می‌شود و باید رمز را در اولین ورود تغییر دهد.

## Rollback

قبل از rollback ترافیک نوشتن را متوقف کنید. کد را به commit قبلی برگردانید و dump پیش از migration را در DB بازیابی کنید؛ سپس snapshot همان زمان `private/storage` را restore کنید. migration 002 عمداً destructive نیست، اما حذف دستی جدول‌ها روش rollback نیست چون ممکن است داده عملیاتی جدید داشته باشند. فایل `.env` مستقل و رمزگذاری‌شده نگهداری شود.

## وابستگی بیرونی

بدون credential، import استاندارد CSV فعال است. XLSX به‌صورت امن ثبت می‌شود اما parser/provider مجاز باید تنظیم شود. provider API فقط از `credential_env_key` محیط استفاده می‌کند؛ scraping وجود ندارد. PDF سروری نصب نشده و خروجی سند، HTML چاپ‌پذیر/Save as PDF مرورگر است.
