/*
 * @script     1008_create_table_email_domains.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

DROP TABLE IF EXISTS email_domains;

CREATE TABLE email_domains (
  email_domain_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  email_domain_status_id TINYINT UNSIGNED NOT NULL,
  email_domain VARCHAR(100) NOT NULL,
  email_domain_path VARCHAR(200) NOT NULL,
  maildir_root VARCHAR(200) NOT NULL,
  @created TIMESTAMP NOT NULL DEFAULT CURRENT_DATE(),
  modified TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (email_domain_status_id) REFERENCES email_domain_statuses (email_domain_status_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT unique_email_domain UNIQUE (email_domain)
) ENGINE = InnoDB;
