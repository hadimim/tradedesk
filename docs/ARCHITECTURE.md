# معماری TradeDesk v2

TradeDesk یک برنامه PHP 8.3/MariaDB با وب‌روت `public_html` است. `index.html` پوسته RTL و router مبتنی بر History API را بار می‌کند؛ rewrite سرور همه مسیرهای غیر فایل را به آن برمی‌گرداند و `/api/*` به `public_html/api/index.php` و سپس `private/app/api_v2.php` می‌رود. برنامه نهایی به `design-preview` وابسته نیست.

API نشست‌محور است: ورود با throttling، regeneration نشست، CSRF برای mutation، Argon2id، RBAC در هر endpoint، prepared statement و audit دارد. فهرست‌ها search/filter/sort/pagination سمت سرور دارند. عملیات چندجدولی فرصت، مقایسه، نسخه سند و import تراکنشی‌اند. فایل‌ها با نام تصادفی و hash خارج از وب‌روت در `private/storage/uploads` نگهداری می‌شوند.

## نقشه لایه‌ها

| صفحه/دامنه | API | جداول اصلی |
|---|---|---|
| کالا و مقررات | `/api/products`, `/api/hs-codes`, `/api/regulations` | products، aliases، attributes، product_hs_codes، product_* |
| شرکت و اشخاص | `/api/companies`, `/api/contacts`, `/api/company-leads` | companies، company_roles/products/industries، contacts، leads |
| پرونده معامله | `/api/opportunities` و actionهای stage/decision/activity | opportunities، items، parties، tasks، activities، history |
| پیشنهاد و قیمت | `/api/quotations`, `/api/prices`, `/api/quotations/compare` | quotations/items، price_observations، quote_comparison_* |
| حمل و بیمه | `/api/routes`, `/api/transport-quotes`, `/api/insurance-*` | transport_*، insurance_* |
| سند | `/api/documents` و versions/approve/issue | documents، versions، approvals، files |
| آمار تجارت | `/api/trade-*`, `/api/trade-imports/*` | sources، import_batches، statistics، company_leads |

جدول‌های قدیمی AI فقط میراث schema 001 هستند و هیچ route، UI یا endpoint فعال ندارند. پیام‌رسان، scraping و داده ساختگی نیز وجود ندارد.
