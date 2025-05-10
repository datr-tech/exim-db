/*
 * @script     1004_create_table_user_statuses.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

DROP TABLE IF EXISTS user_statuses;

CREATE TABLE user_statuses (
  user_status_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_status VARCHAR(40) NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_DATE(),
  modified TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT unique_status UNIQUE (user_status)
) ENGINE = InnoDB;
