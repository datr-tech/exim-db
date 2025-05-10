/*
 * @script     1016_insert_email_domain_statuses.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

INSERT INTO
  email_domain_statuses (email_domain_status)
VALUES
  ('active'),
  ('inactive');
