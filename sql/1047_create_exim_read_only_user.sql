/*
 * script     1047_create_exim_read_only_user.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
DROP USER IF EXISTS exim_read_only_user@localhost;

CREATE USER exim_read_only_user@localhost IDENTIFIED BY 'Sc@4land09';

GRANT SELECT ON email_accounts.user_name_domains TO exim_read_only_user@localhost;
