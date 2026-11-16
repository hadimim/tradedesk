# TradeDesk

سامانه عملیاتی فارسی و RTL برای دانش کالا و اجرای پرونده‌های بازرگانی، بر پایه PHP 8.3 و MariaDB.

ورودی برنامه `public_html/index.html` و API در `/api` است. راهنمای استقرار و rollback در [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)، معماری در [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) و schema تکمیلی در [docs/SCHEMA.md](docs/SCHEMA.md) قرار دارد.

```bash
php database/migrate.php
php database/seed.php
php tests/smoke.php
```

هوش مصنوعی، پیام‌رسان، scraping و آمار ساختگی جزو این محصول نیستند.
