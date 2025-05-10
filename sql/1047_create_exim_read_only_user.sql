/*
 * @script     1047_create_exim_read_only_user.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
DROP USER IF EXISTS @user_exim_name @localhost;

CREATE USER @user_exim_name @localhost IDENTIFIED BY @user_exim_pass;

GRANT
SELECT
  ON email_accounts.user_name_domains TO @user_exim_name @localhost;
