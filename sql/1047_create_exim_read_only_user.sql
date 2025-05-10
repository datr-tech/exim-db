/*
 * @script     1047_create_exim_read_only_user.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
SET @user_name=(SELECT CONCAT(user_env_var_value, "@localhost") FROM user_env_vars WHERE user_env_var_name='EXIM_DB_USER_EXIM_MTA_NAME');
SET @user_pass=(SELECT user_env_var_value FROM user_env_vars WHERE user_env_var_name='EXIM_DB_USER_EXIM_MTA_PASS');

DROP USER IF EXISTS @user_name;

CREATE USER @user_name IDENTIFIED BY @user_pass;

GRANT
SELECT                                                                                
  ON email_accounts.user_name_domains TO @user_name;
