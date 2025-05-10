/*
 * @script     1046_create_dovecot_read_only_user.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
DROP USER IF EXISTS dovecot_read_only_user @localhost;

CREATE USER dovecot_read_only_user @localhost IDENTIFIED BY @user_dovecot_pass;

GRANT
SELECT
  ON email_accounts.user_name_domains TO dovecot_read_only_user @localhost;
