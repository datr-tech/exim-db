/*
 * @script     1001_create_table_user_groups.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

DROP TABLE IF EXISTS user_groups;

CREATE TABLE user_groups (
  user_group_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_group VARCHAR(40) NOT NULL,
  @created TIMESTAMP NOT NULL DEFAULT CURRENT_DATE(),
  modified TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT unique_user_group UNIQUE (user_group)
) ENGINE = InnoDB;
