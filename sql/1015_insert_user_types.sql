/*
 * @script     1015_insert_user_types.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

INSERT INTO
  user_types (user_type)
VALUES
  ('system'),
  ('virtual');
