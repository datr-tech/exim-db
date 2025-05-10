/*
 * @script     1021_insert_user_name_alias_abuse.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

INSERT INTO
  user_names (user_name_type_id, user_name)
VALUES
  (
    (
      SELECT
        user_name_type_id
      FROM
        user_name_types
      WHERE
        user_name_type = 'alias'
    ),
    'abuse'
  );
