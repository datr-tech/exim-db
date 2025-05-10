/*
 * @script		 0000_create_user_variables.sql.TEMPLATE
 *
 * @created    10th May 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

DROP TABLE IF EXISTS user_env_vars;

CREATE TABLE user_env_vars (
  user_env_var_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_env_var_name VARCHAR(40) NOT NULL,
  user_env_var_value VARCHAR(100) NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_DATE(),
  modified TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT unique_user_env_var_name UNIQUE (user_env_var_name)
) ENGINE = InnoDB;
