/*
 * @script     1036_insert_user_email_address__admin_alias_webmaster_datr.tech.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

INSERT INTO
  user_email_addresses (user_id, user_name_id, email_domain_id)
VALUES
  (
    (
      SELECT
        user_id
      FROM
        users
      WHERE
        ref = 'admin'
    ),
    (
      SELECT
        user_name_id
      FROM
        user_names
      WHERE
        user_name = 'webmaster'
    ),
    (
      SELECT
        email_domain_id
      FROM
        email_domains
      WHERE
        email_domain = 'datr.tech'
    )
  );
