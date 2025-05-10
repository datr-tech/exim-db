/*
 * @script     1019_insert_user_admin.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

INSERT INTO
  users (
    user_group_id,
    user_status_id,
    user_type_id,
    ref,
    uid,
    gid,
    password
  )
VALUES
  (
    (
      SELECT
        user_group_id
      FROM
        user_groups
      WHERE
        user_group = 'default'
    ),
    (
      SELECT
        user_status_id
      FROM
        user_statuses
      WHERE
        user_status = 'active'
    ),
    (
      SELECT
        user_type_id
      FROM
        user_types
      WHERE
        user_type = 'system'
    ),
    'admin',
    2000,
    8,
    MD5(@user_admin_pass)
  );
