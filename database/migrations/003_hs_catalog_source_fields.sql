ALTER TABLE product_categories
  ADD COLUMN IF NOT EXISTS source_name VARCHAR(190) NULL AFTER description,
  ADD COLUMN IF NOT EXISTS source_code VARCHAR(60) NULL AFTER source_name,
  ADD COLUMN IF NOT EXISTS source_parent_code VARCHAR(60) NULL AFTER source_code,
  ADD COLUMN IF NOT EXISTS standard_unit_abbr VARCHAR(30) NULL AFTER source_parent_code,
  ADD COLUMN IF NOT EXISTS translation_status ENUM('machine_draft','reviewed') NOT NULL DEFAULT 'machine_draft' AFTER standard_unit_abbr,
  ADD INDEX IF NOT EXISTS idx_product_categories_source (source_name, source_code);

ALTER TABLE products
  ADD COLUMN IF NOT EXISTS source_name VARCHAR(190) NULL AFTER full_description,
  ADD COLUMN IF NOT EXISTS source_code VARCHAR(60) NULL AFTER source_name,
  ADD COLUMN IF NOT EXISTS standard_unit_abbr VARCHAR(30) NULL AFTER source_code,
  ADD COLUMN IF NOT EXISTS translation_status ENUM('machine_draft','reviewed') NOT NULL DEFAULT 'machine_draft' AFTER standard_unit_abbr,
  ADD INDEX IF NOT EXISTS idx_products_source (source_name, source_code);
