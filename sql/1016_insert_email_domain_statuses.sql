/*
 * script     1016_insert_email_domain_statuses.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

INSERT INTO email_domain_statuses (email_domain_status) VALUES ('active'), ('inactive');
