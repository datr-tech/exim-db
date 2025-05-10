/*
 * @script     1006_create_table_users.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  user_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_group_id TINYINT UNSIGNED NOT NULL,
  user_status_id TINYINT UNSIGNED NOT NULL,
  user_type_id TINYINT UNSIGNED NOT NULL,
  ref VARCHAR(100) NOT NULL,
  uid MEDIUMINT UNSIGNED NULL,
  gid MEDIUMINT UNSIGNED NULL,
  password VARCHAR(40) NOT NULL,
  @created TIMESTAMP NOT NULL DEFAULT CURRENT_DATE(),
  modified TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_group_id) REFERENCES user_groups (user_group_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (user_status_id) REFERENCES user_statuses (user_status_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (user_type_id) REFERENCES user_types (user_type_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT unique_ref_password UNIQUE (ref, password)
) ENGINE = InnoDB;
