# وضعیت Prototype و جایگزینی

Prototype موجود در `design-preview` فقط مرجع طراحی است. خروجی عملیاتی از فایل‌های آن import نمی‌کند و سایت اصلی دوم یا مسیر legacy ندارد. رابط قبلی `public_html/index.html`، CSS و JS با shell عملیاتی و routeهای شناسه‌محور جایگزین شده‌اند.

مسیرهای اصلی: `/dashboard`, `/products/{id}`, `/categories/{id}`, `/hs-codes/{id}`, `/regulations/{id}`, `/companies/{id}`, `/contacts/{id}`, `/opportunities/{id}`, `/tasks/{id}`, `/quotations/{id}`, `/prices/{id}`, `/routes/{id}`, `/transport-quotes/{id}`, `/insurance-products/{id}`, `/insurance-quotes/{id}`, `/documents/{id}`, `/countries/{id}`, `/industries/{id}`, `/currencies/{id}`, `/units/{id}`, `/trade-statistics/{id}`, `/trade-imports`, `/company-leads/{id}`, `/reports`, `/users/{id}`, `/audit-logs`, `/settings`.

فهرست‌ها داده واقعی API، فیلتر/صفحه‌بندی و state بازگشت دارند؛ جزئیات با refresh مستقیم باز می‌شوند. قابلیت‌های نمایشی AI/پیام‌رسان حذف شده‌اند.
