-- TradeDesk domain completion. Additive only; no production rows are deleted.
CREATE TABLE IF NOT EXISTS product_origin_countries(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,product_id BIGINT UNSIGNED NOT NULL,country_id BIGINT UNSIGNED NOT NULL,
 country_role ENUM('producer','exporter','consumer','transaction_origin','other') NOT NULL,source_name VARCHAR(190) NOT NULL,source_url VARCHAR(500),
 verification_status ENUM('unverified','under_review','verified','rejected','expired') NOT NULL DEFAULT 'unverified',checked_at DATETIME,verified_by BIGINT UNSIGNED,
 valid_from DATE,valid_until DATE,notes TEXT,created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 UNIQUE(product_id,country_id,country_role,source_name),INDEX(country_id,country_role),INDEX(verification_status,checked_at),
 FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE RESTRICT,FOREIGN KEY(country_id) REFERENCES countries(id) ON DELETE RESTRICT,
 FOREIGN KEY(verified_by) REFERENCES users(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS company_products(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,company_id BIGINT UNSIGNED NOT NULL,product_id BIGINT UNSIGNED NOT NULL,
 trade_role ENUM('buyer','seller','manufacturer','distributor','intermediary','service_provider','other') NOT NULL,
 source_name VARCHAR(190) NOT NULL,source_url VARCHAR(500),verification_status ENUM('unverified','under_review','verified','rejected','expired') DEFAULT 'unverified',
 checked_at DATETIME,verified_by BIGINT UNSIGNED,valid_from DATE,valid_until DATE,notes TEXT,created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 UNIQUE(company_id,product_id,trade_role,source_name),INDEX(product_id,trade_role),INDEX(verification_status),
 FOREIGN KEY(company_id) REFERENCES companies(id) ON DELETE RESTRICT,FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE RESTRICT,
 FOREIGN KEY(verified_by) REFERENCES users(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS company_industries(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,company_id BIGINT UNSIGNED NOT NULL,industry_id BIGINT UNSIGNED NOT NULL,
 source_name VARCHAR(190) NOT NULL,source_url VARCHAR(500),verification_status ENUM('unverified','under_review','verified','rejected','expired') DEFAULT 'unverified',
 checked_at DATETIME,verified_by BIGINT UNSIGNED,valid_from DATE,valid_until DATE,created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 UNIQUE(company_id,industry_id,source_name),INDEX(industry_id),FOREIGN KEY(company_id) REFERENCES companies(id) ON DELETE RESTRICT,
 FOREIGN KEY(industry_id) REFERENCES industries(id) ON DELETE RESTRICT,FOREIGN KEY(verified_by) REFERENCES users(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS regulatory_requirements(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,country_id BIGINT UNSIGNED,hs_code VARCHAR(30),category_id BIGINT UNSIGNED,
 requirement_type VARCHAR(100) NOT NULL,title VARCHAR(255) NOT NULL,description TEXT NOT NULL,source_name VARCHAR(190) NOT NULL,source_url VARCHAR(500),
 verification_status ENUM('unverified','under_review','verified','rejected','expired') DEFAULT 'unverified',checked_at DATETIME,verified_by BIGINT UNSIGNED,
 valid_from DATE,valid_until DATE,status ENUM('active','archived') DEFAULT 'active',created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 INDEX(country_id,hs_code),INDEX(category_id,status),INDEX(verification_status,checked_at),FOREIGN KEY(country_id) REFERENCES countries(id) ON DELETE RESTRICT,
 FOREIGN KEY(category_id) REFERENCES product_categories(id) ON DELETE RESTRICT,FOREIGN KEY(verified_by) REFERENCES users(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS product_regulatory_requirements(
 product_id BIGINT UNSIGNED NOT NULL,requirement_id BIGINT UNSIGNED NOT NULL,compliance_status ENUM('unknown','required','in_progress','compliant','non_compliant','not_applicable') DEFAULT 'unknown',
 evidence_file_id BIGINT UNSIGNED,notes TEXT,checked_at DATETIME,verified_by BIGINT UNSIGNED,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 PRIMARY KEY(product_id,requirement_id),FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE RESTRICT,
 FOREIGN KEY(requirement_id) REFERENCES regulatory_requirements(id) ON DELETE RESTRICT,FOREIGN KEY(evidence_file_id) REFERENCES files(id) ON DELETE RESTRICT,
 FOREIGN KEY(verified_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS product_documents(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,product_id BIGINT UNSIGNED NOT NULL,file_id BIGINT UNSIGNED,
 document_type ENUM('sds','msds','coa','analysis','manufacturer_spec','catalogue','certificate','other') NOT NULL,title VARCHAR(255) NOT NULL,version VARCHAR(80),
 issuer_name VARCHAR(190),issue_date DATE,expires_at DATE,source_name VARCHAR(190) NOT NULL,source_url VARCHAR(500),
 verification_status ENUM('unverified','under_review','verified','rejected','expired') DEFAULT 'unverified',checked_at DATETIME,verified_by BIGINT UNSIGNED,
 status ENUM('active','archived') DEFAULT 'active',created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 INDEX(product_id,document_type,status),INDEX(expires_at),FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE RESTRICT,
 FOREIGN KEY(file_id) REFERENCES files(id) ON DELETE RESTRICT,FOREIGN KEY(verified_by) REFERENCES users(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS product_analysis_reports(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,product_id BIGINT UNSIGNED NOT NULL,product_document_id BIGINT UNSIGNED,file_id BIGINT UNSIGNED,
 report_number VARCHAR(100),sample_number VARCHAR(100),laboratory_name VARCHAR(190),analysis_date DATE,source_name VARCHAR(190) NOT NULL,
 verification_status ENUM('unverified','under_review','verified','rejected','expired') DEFAULT 'unverified',checked_at DATETIME,verified_by BIGINT UNSIGNED,
 notes TEXT,created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 INDEX(product_id,analysis_date),FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE RESTRICT,
 FOREIGN KEY(product_document_id) REFERENCES product_documents(id) ON DELETE RESTRICT,FOREIGN KEY(file_id) REFERENCES files(id) ON DELETE RESTRICT,
 FOREIGN KEY(verified_by) REFERENCES users(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS product_analysis_results(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,report_id BIGINT UNSIGNED NOT NULL,parameter_name VARCHAR(190) NOT NULL,
 value_text VARCHAR(255),value_decimal DECIMAL(24,8),unit_id BIGINT UNSIGNED,test_method VARCHAR(190),specification_min DECIMAL(24,8),specification_max DECIMAL(24,8),
 result_status ENUM('unknown','pass','fail','not_applicable') DEFAULT 'unknown',notes TEXT,created_at DATETIME NOT NULL,
 INDEX(report_id,parameter_name),FOREIGN KEY(report_id) REFERENCES product_analysis_reports(id) ON DELETE RESTRICT,FOREIGN KEY(unit_id) REFERENCES units(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS opportunity_decisions(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,opportunity_id BIGINT UNSIGNED NOT NULL,subject VARCHAR(255) NOT NULL,options_json JSON,
 selected_option VARCHAR(255),decision ENUM('selected','rejected','deferred','needs_information') NOT NULL,reason TEXT NOT NULL,decided_by BIGINT UNSIGNED NOT NULL,decided_at DATETIME NOT NULL,
 created_at DATETIME NOT NULL,INDEX(opportunity_id,decided_at),FOREIGN KEY(opportunity_id) REFERENCES opportunities(id) ON DELETE RESTRICT,FOREIGN KEY(decided_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS quote_comparison_sets(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,opportunity_id BIGINT UNSIGNED NOT NULL,title VARCHAR(255) NOT NULL,basis_currency_id BIGINT UNSIGNED,
 assumptions TEXT,exchange_rate_snapshot_json JSON,result_summary TEXT,created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 INDEX(opportunity_id,created_at),FOREIGN KEY(opportunity_id) REFERENCES opportunities(id) ON DELETE RESTRICT,
 FOREIGN KEY(basis_currency_id) REFERENCES currencies(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS quote_comparison_items(
 comparison_set_id BIGINT UNSIGNED NOT NULL,quotation_id BIGINT UNSIGNED NOT NULL,quotation_snapshot_json JSON NOT NULL,
 comparable BOOLEAN NOT NULL DEFAULT 0,incompatibility_reason TEXT,normalized_total DECIMAL(24,8),rank_number INT,decision_status ENUM('considering','selected','rejected') DEFAULT 'considering',
 PRIMARY KEY(comparison_set_id,quotation_id),FOREIGN KEY(comparison_set_id) REFERENCES quote_comparison_sets(id) ON DELETE RESTRICT,
 FOREIGN KEY(quotation_id) REFERENCES quotations(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS document_approvals(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,document_version_id BIGINT UNSIGNED NOT NULL,reviewer_id BIGINT UNSIGNED NOT NULL,
 decision ENUM('pending','approved','rejected','changes_requested') NOT NULL DEFAULT 'pending',reason TEXT,decided_at DATETIME,created_at DATETIME NOT NULL,
 UNIQUE(document_version_id,reviewer_id),INDEX(decision,decided_at),FOREIGN KEY(document_version_id) REFERENCES document_versions(id) ON DELETE RESTRICT,
 FOREIGN KEY(reviewer_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS trade_data_sources(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,code VARCHAR(80) NOT NULL UNIQUE,name VARCHAR(190) NOT NULL,provider_type ENUM('csv','xlsx','api') NOT NULL,
 access_method VARCHAR(190),license_name VARCHAR(190),license_url VARCHAR(500),base_url VARCHAR(500),credential_env_key VARCHAR(120),is_active BOOLEAN DEFAULT 1,
 notes TEXT,created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS trade_data_import_batches(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,source_id BIGINT UNSIGNED NOT NULL,file_id BIGINT UNSIGNED,original_filename VARCHAR(255),mapping_json JSON,
 status ENUM('uploaded','validating','failed','imported','cancelled') DEFAULT 'uploaded',rows_total INT DEFAULT 0,rows_valid INT DEFAULT 0,rows_invalid INT DEFAULT 0,
 error_report_json JSON,imported_by BIGINT UNSIGNED NOT NULL,started_at DATETIME,completed_at DATETIME,created_at DATETIME NOT NULL,
 INDEX(source_id,status,created_at),FOREIGN KEY(source_id) REFERENCES trade_data_sources(id) ON DELETE RESTRICT,
 FOREIGN KEY(file_id) REFERENCES files(id) ON DELETE RESTRICT,FOREIGN KEY(imported_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS trade_statistics(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,source_id BIGINT UNSIGNED NOT NULL,import_batch_id BIGINT UNSIGNED,period_year SMALLINT NOT NULL,period_month TINYINT,
 hs_code VARCHAR(30) NOT NULL,reporter_country_id BIGINT UNSIGNED NOT NULL,partner_country_id BIGINT UNSIGNED,flow ENUM('import','export') NOT NULL,
 trade_value DECIMAL(24,4),currency_id BIGINT UNSIGNED,net_weight DECIMAL(24,8),quantity DECIMAL(24,8),unit_id BIGINT UNSIGNED,
 source_record_id VARCHAR(190),retrieved_at DATETIME NOT NULL,verification_status ENUM('unverified','under_review','verified','rejected','expired') DEFAULT 'unverified',
 checked_at DATETIME,verified_by BIGINT UNSIGNED,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 UNIQUE(source_id,source_record_id),INDEX(hs_code,period_year,flow),INDEX(reporter_country_id,partner_country_id),INDEX(verification_status),
 FOREIGN KEY(source_id) REFERENCES trade_data_sources(id) ON DELETE RESTRICT,FOREIGN KEY(import_batch_id) REFERENCES trade_data_import_batches(id) ON DELETE RESTRICT,
 FOREIGN KEY(reporter_country_id) REFERENCES countries(id) ON DELETE RESTRICT,FOREIGN KEY(partner_country_id) REFERENCES countries(id) ON DELETE RESTRICT,
 FOREIGN KEY(currency_id) REFERENCES currencies(id) ON DELETE RESTRICT,FOREIGN KEY(unit_id) REFERENCES units(id) ON DELETE RESTRICT,FOREIGN KEY(verified_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS company_leads(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,raw_name VARCHAR(255) NOT NULL,country_id BIGINT UNSIGNED,probable_role VARCHAR(100),product_id BIGINT UNSIGNED,hs_code VARCHAR(30),
 activity_period VARCHAR(100),source_id BIGINT UNSIGNED NOT NULL,source_url VARCHAR(500),evidence_text TEXT,retrieved_at DATETIME NOT NULL,
 review_status ENUM('new','under_review','approved','rejected','linked') DEFAULT 'new',reviewed_by BIGINT UNSIGNED,reviewed_at DATETIME,linked_company_id BIGINT UNSIGNED,
 notes TEXT,created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,updated_at DATETIME NOT NULL,
 INDEX(review_status,retrieved_at),INDEX(country_id,probable_role),INDEX(hs_code),FOREIGN KEY(country_id) REFERENCES countries(id) ON DELETE RESTRICT,
 FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE RESTRICT,FOREIGN KEY(source_id) REFERENCES trade_data_sources(id) ON DELETE RESTRICT,
 FOREIGN KEY(reviewed_by) REFERENCES users(id) ON DELETE RESTRICT,FOREIGN KEY(linked_company_id) REFERENCES companies(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS file_links(
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,file_id BIGINT UNSIGNED NOT NULL,entity_type VARCHAR(80) NOT NULL,entity_id BIGINT UNSIGNED NOT NULL,purpose VARCHAR(100),
 visibility ENUM('team','restricted') DEFAULT 'team',created_by BIGINT UNSIGNED NOT NULL,created_at DATETIME NOT NULL,
 UNIQUE(file_id,entity_type,entity_id,purpose),INDEX(entity_type,entity_id),FOREIGN KEY(file_id) REFERENCES files(id) ON DELETE RESTRICT,FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

ALTER TABLE exchange_rates ADD COLUMN IF NOT EXISTS verification_status ENUM('unverified','under_review','verified','rejected','expired') NOT NULL DEFAULT 'unverified';
ALTER TABLE exchange_rates ADD COLUMN IF NOT EXISTS checked_at DATETIME NULL;
ALTER TABLE exchange_rates ADD COLUMN IF NOT EXISTS verified_by BIGINT UNSIGNED NULL;
ALTER TABLE exchange_rates ADD INDEX IF NOT EXISTS idx_exchange_verification(verification_status,rate_date);
