/*
 * @script     1046_create_dovecot_read_only_user.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
SET @user_name=(SELECT user_env_var_value FROM user_env_vars WHERE user_env_var_name='EXIM_DB_USER_DOVECOT_NAME');
SET @user_pass=(SELECT user_env_var_value FROM user_env_vars WHERE user_env_var_name='EXIM_DB_USER_DOVECOT_PASS');

SHOW USER VARIABLES;

DROP USER IF EXISTS @user_name@localhost;

CREATE USER @user_name@locahost IDENTIFIED BY @user_pass;

GRANT
SELECT
  ON email_accounts.user_name_domains TO @user_name@localhost;
