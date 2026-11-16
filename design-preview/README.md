# TradeDesk v3 — Prototype فهرست و جزئیات

Prototype مستقل، RTL و بدون API/دیتابیس است. داده‌ها ساختگی‌اند و در رابط با عبارت «نمونه آزمایشی / تأییدنشده» مشخص می‌شوند. فونت Vazirmatn به‌صورت self-hosted و تحت مجوز OFL در `assets/fonts/` قرار دارد.

## اجرا

از ریشه مخزن:

```bash
php -S 127.0.0.1:8090 -t design-preview
```

سپس `http://127.0.0.1:8090` را باز کنید. در اتصال Remote VS Code پورت 8090 را Forward کنید.

## قرارداد route

- فهرست: `#products`، `#companies`، `#contacts`، `#opportunities` و مانند آن.
- جزئیات: `#product?id=prd-ldpe`، `#company?id=co-anatolia`، `#opportunity?id=op-241`.
- refresh روی route جزئیات همان رکورد را نگه می‌دارد.
- منوی اصلی فقط فهرست‌ها را باز می‌کند؛ رکورد از جدول فهرست انتخاب می‌شود.

## فهرست‌های قابل بررسی

`products`، `companies`، `contacts`، `opportunities`، `tasks`، `quotes`، `prices`، `documents`، `routes`، `insurance`، `categories`، `industries`، `countries` و `hsCodes`.

هرکدام detail مستقل دارند و رابطه‌های درون صفحات به شناسه مقصد وصل‌اند. فرصت `TD-0241` دو قلم کالا دارد تا مسیر چندقلمی قابل بررسی باشد.

## state و محدودیت

ایجاد/ویرایش نمایشی فقط `localStorage` مرورگر را تغییر می‌دهد. صدور سند، تأیید واقعی، API، AI، جست‌وجوی بیرونی و پیام‌رسان متصل نیستند. فایل‌های `prototype.js` و `prototype-v2.js` تاریخچه نسخه قبلی‌اند و دیگر توسط `index.html` بارگذاری نمی‌شوند؛ رابط فعال از `app-v3.js` تولید می‌شود.

Screenshotهای QA جدید در `screenshots/v3-*.png` هستند.
