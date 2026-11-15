# پیش‌نویس مفهومی موجودیت‌ها

این سند migration نیست؛ مرزهای محصول و محل مشاهده/ویرایش اطلاعات را مشخص می‌کند.

## هسته پرونده

- **Opportunity**: هویت معامله، نوع، وضعیت، مرحله، مالک، اولویت، محرمانگی و نتیجه.
- **OpportunityItem**: درخواست خاص همین معامله؛ محصول، مقدار، واحد، مشخصات موردنیاز، بسته‌بندی، مبدأ و مقصد. در پرونده فرصت و بخش فرصت‌های پرونده کالا دیده می‌شود.
- **PartyAssignment**: شرکت/شخص + نقش در همین معامله + وضعیت ارتباط. در پرونده فرصت و سوابق شرکت دیده می‌شود.
- **NextAction / Task**: اقدام، مسئول، موعد، وضعیت و نتیجه. Next action می‌تواند projection نزدیک‌ترین task یا انتظار پاسخ باشد، نه متن آزاد جدا.
- **Activity**: تماس، جلسه، دریافت فایل، یادداشت یا رویداد سیستمی. در timeline پرونده و موجودیت مرتبط دیده می‌شود.
- **Decision**: سؤال، گزینه‌های بررسی‌شده، انتخاب، دلیل، تصمیم‌گیر و زمان. در پرونده فرصت و timeline و سند snapshot دیده می‌شود.

## دانش کالا

- **Product / Category / Alias**: داده مرجع قابل استفاده مجدد؛ ویرایش در پرونده کالا.
- **AttributeDefinition / AttributeValue**: مشخصات ساخت‌یافته و تاریخ‌دار؛ پرونده کالا منبع اصلی، پرونده فرصت فقط snapshot/نیاز خاص را نمایش می‌دهد.
- **HsClassificationReview**: کد، نظام کشور، وضعیت، منبع، بازبین و اعتبار. یک Product چند بررسی دارد.
- **RegulatoryRequirement**: کشور، مرجع، نوع، منبع و تاریخ بررسی؛ از پرونده کالا مدیریت و در checklist فرصت مصرف می‌شود.
- **TechnicalDocument**: فایل نسخه‌دار مانند SDS/COA؛ به کالا وصل و در فرصت انتخاب/ارجاع می‌شود.

## شبکه طرف‌ها

- **Company** نقش واحد ندارد؛ با **CompanyCapability/Role** می‌تواند خریدار، فروشنده، تولیدکننده، حمل‌کننده یا بیمه‌گر باشد.
- **Contact** از طریق رابطه تاریخ‌دار به شرکت وصل است.
- **CompanyProduct / CompanyIndustry** دانش رابطه‌ای با منبع و وضعیت بررسی است.
- پرونده شرکت محل ویرایش هویت، نقش‌ها، تماس‌ها و مدارک است؛ فرصت فقط assignment معامله را ویرایش می‌کند.

## قیمت و پیشنهاد

- **Quotation** هدر پیشنهاد، طرف، جهت، ارز، شرایط، تاریخ و اعتبار.
- **QuotationLine** قلم، مقدار، واحد، قیمت واحد، تخفیف و Incoterm.
- **PriceObservation** سابقه قیمت داخلی با منبع؛ می‌تواند از quotation ساخته شود اما جای آن نیست.
- **ComparisonSet** (مفهومی): انتخاب پیشنهادهای قابل مقایسه و نرخ‌های تبدیل تأییدشده؛ نتیجه محاسبه‌شده است، داده مرجع نیست.

## حمل و بیمه

- **Route / RouteLeg** مسیر قابل استفاده مجدد و بخش‌های مرتب آن.
- **TransportQuote** استعلام پرونده‌ای با route، provider، هزینه، ارز، زمان، منبع و اعتبار.
- **InsuranceQuote** پرونده، بیمه‌گر/محصول، ارزش، ارز، مبلغ/نرخ، پوشش، استثنا و اعتبار.
- انتخاب مسیر یا بیمه با Decision ثبت می‌شود.

## سند و فایل

- **FileAsset** metadata، hash، مالک و مسیر امن؛ به‌تنهایی سند تجاری نیست.
- **Document / DocumentVersion** نوع، وضعیت و نسخه snapshot. نسخه صادرشده immutable است.
- **Template** placeholderهای مجاز و schema؛ کد اجرا نمی‌کند.

## AI، اعلان و کنترل

- **AI Session / Output** ورودی، منابع داخلی استفاده‌شده، خروجی و وضعیت تأیید؛ هر mutation پس از تأیید کاربر به موجودیت واقعی تبدیل می‌شود.
- **Notification** projection رویداد/موعد برای کاربر است و منبع حقیقت وظیفه نیست.
- **AuditLog** تاریخچه غیرقابل ویرایش عملیات حساس.

## روابط کلیدی

```text
Opportunity 1──* OpportunityItem *──1 Product
Opportunity 1──* PartyAssignment *──1 Company
PartyAssignment *──0..1 Contact
Opportunity 1──* Task / Activity / Decision
Opportunity 1──* Quotation 1──* QuotationLine *──1 Product
Opportunity 1──* TransportQuote *──1 Route 1──* RouteLeg
Opportunity 1──* InsuranceQuote
Opportunity 1──* Document 1──* DocumentVersion
Product 1──* AttributeValue / HsClassificationReview / TechnicalDocument
Company *──* Product, Company *──* Industry, Company *──* Contact
```

قاعده مالکیت: داده مرجع در پرونده کالا/شرکت ویرایش می‌شود؛ داده معامله در پرونده فرصت؛ snapshot سند فقط با نسخه جدید تغییر می‌کند.

## Projectionهای استفاده‌شده در Prototype

Prototype v2 زیرمجموعه‌ای مصنوعی از مدل را به‌صورت objectهای مرورگر نمایش می‌دهد: `Opportunity`، `Task`، رویدادهای `Activity/Decision`، `DocumentVersion` و `RouteLeg`. فرم‌ها رابطه را با شناسه نمایشی مانند `TD-0241` حفظ می‌کنند، اما entity واقعی، کلید خارجی، audit غیرقابل‌تغییر یا permission enforcement ایجاد نمی‌شود.

فهرست‌ها projection هستند: کارهای روز از task/next action، صف اسناد از document status/validity و سلامت پرونده از missing-dataهای نمونه ساخته می‌شود. در پیاده‌سازی اجرایی این projectionها باید از مدل‌های منبع حقیقت بالا محاسبه شوند، نه از state سمت کاربر.
