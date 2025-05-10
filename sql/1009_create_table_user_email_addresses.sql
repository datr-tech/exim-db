/*
 * @script     1009_create_table_user_email_addresses.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

DROP TABLE IF EXISTS user_email_addresses;

CREATE TABLE user_email_addresses (
  user_email_address_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id MEDIUMINT UNSIGNED NOT NULL,
  user_name_id MEDIUMINT UNSIGNED NOT NULL,
  email_domain_id MEDIUMINT UNSIGNED NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_DATE(),
  modified TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (user_name_id) REFERENCES user_names (user_name_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (email_domain_id) REFERENCES email_domains (email_domain_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT unique_user_name_domain UNIQUE (user_id, user_name_id, email_domain_id)
) ENGINE = InnoDB;
