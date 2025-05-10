/*
 * @script     1002_create_table_user_name_types.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

DROP TABLE IF EXISTS user_name_types;

CREATE TABLE user_name_types (
  user_name_type_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_name_type VARCHAR(40) NOT NULL,
  @created TIMESTAMP NOT NULL DEFAULT CURRENT_DATE(),
  modified TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT unique_user_name_type UNIQUE (user_name_type)
) ENGINE = InnoDB;
