/*
 * @script     1017_insert_email_domain_datr.tech.sql
 *
 * @created    15th February 2025
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

INSERT INTO
  email_domains (
    email_domain,
    email_domain_path,
    maildir_root,
    email_domain_status_id
  )
VALUES
  (
    'datr.tech',
    '/var/mail/datr.tech',
    '/var/mail',
    (
      SELECT
        email_domain_status_id
      FROM
        email_domain_statuses
      WHERE
        email_domain_status = 'active'
    )
  );
