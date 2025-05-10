/*
 * @script     1014_insert_user_statuses.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

INSERT INTO
  user_statuses (user_status)
VALUES
  ('active'),
  ('inactive');
