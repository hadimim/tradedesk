# Inventory رابط و موجودیت‌های TradeDesk

## پیش از این مرحله

| بخش | تولیدکننده رابط | وضعیت قبلی |
|---|---|---|
| shell و منو | `design-preview/index.html` | بعضی منوها مستقیم detail ثابت را باز می‌کردند |
| صفحات اصلی | `assets/prototype.js` | opportunity/product/company عمدتاً hardcode |
| صفحات تکمیلی و state | `assets/prototype-v2.js` | فهرست و detail برای همه موجودیت‌ها جدا نبود |
| ظاهر | `prototype.css` + `prototype-v2.css` | overrideهای متعدد و متن‌های ۸ تا ۱۱px |
| اپ اجرایی | `public_html/assets/app.js` + `private/app/api.php` | CRUD جدا از Prototype؛ در این مرحله دست‌نخورده |
| مدل داده | `database/migrations/001_initial_schema.sql` | منبع inventory موجودیت‌ها؛ بدون تغییر |

## پس از این مرحله

| لایه | فایل فعال | مسئولیت |
|---|---|---|
| shell | `design-preview/index.html` | منوی collection-first و containerهای مشترک |
| Design System | `assets/design-system.css` | توکن، Vazirmatn، type scale، component و responsive |
| route/data/render | `assets/app-v3.js` | dataset رابطه‌دار، list/detail، search/filter/sort و local state |
| فونت/مجوز | `assets/fonts/Vazirmatn.woff2` و `OFL.txt` | فونت فارسی self-hosted |
| CSS قبلی | `prototype.css` و `prototype-v2.css` | پایه بصری حفظ‌شده؛ Design System نهایی روی آن اعمال می‌شود |
| JS قبلی | `prototype.js` و `prototype-v2.js` | legacy، دیگر در HTML بارگذاری نمی‌شود |

## موجودیت‌های برگرفته از schema

موجودیت‌های سطح محصول که در Prototype list/detail دارند: Product، Company، Contact، Opportunity، Task، Quotation، Price Observation، Document، Transport Route/Quote، Insurance Quote، Product Category، Industry، Country و Product HS Code.

جداول پشتیبان مانند currency، unit، role، permission، activity، file و template در UI مستقل اصلی نمایش داده نشده‌اند؛ آن‌ها داده پایه یا جزء داخلی موجودیت‌های بالا هستند. گزارش و تنظیمات صفحه utility هستند، نه رکورد دامنه‌ای.

## صحت روابط نمونه

تمام رابطه‌ها با ID سازگار ذخیره شده‌اند؛ برای مثال `op-241` به دو `OpportunityItem`، سه طرف، دو پیشنهاد، یک مسیر، یک بیمه، یک سند و یک وظیفه وصل است. متن‌های رابطه‌ای در detailها به route مقصد پیوند دارند. رکورد سیانید سدیم عمداً فاقد کشور، شرکت، قیمت و HS است و empty state نشان می‌دهد تا داده بی‌پشتوانه اختراع نشود.
