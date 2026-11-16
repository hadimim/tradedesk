# Schema v2

`001_initial_schema.sql` بدون تغییر باقی مانده و `002_trade_domain_completion.sql` به‌صورت افزایشی اجرا می‌شود.

جداول افزوده: `product_origin_countries`, `company_products`, `company_industries`, `regulatory_requirements`, `product_regulatory_requirements`, `product_documents`, `product_analysis_reports`, `product_analysis_results`, `opportunity_decisions`, `quote_comparison_sets`, `quote_comparison_items`, `document_approvals`, `trade_data_sources`, `trade_data_import_batches`, `trade_statistics`, `company_leads`, `file_links`.

همچنین exchange rate دارای `verification_status`, `checked_at`, `verified_by` شده است. مبالغ/مقادیر DECIMAL هستند، تاریخچه و رکورد عملیاتی cascade-delete نمی‌شود، داده منبع‌حساس دارای منبع/اعتبار/بازبین است و JSON فقط برای snapshot و payload متغیر به کار می‌رود.
