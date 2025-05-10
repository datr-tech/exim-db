/*
 * script     1046_create_dovecot_read_only_user.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
DROP USER IF EXISTS dovecot_read_only_user@localhost;

CREATE USER dovecot_read_only_user@localhost IDENTIFIED BY 'Ed1nb@rgh1357';

GRANT SELECT ON email_accounts.user_name_domains TO dovecot_read_only_user@localhost;
