/*
 * @script    1048_select_maildir_root.sql
 *
 * purpose    Select a single, active 'maildir' from 'email_domains'
 *
 * @created   15th February 2025
 * @author    Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

SELECT
  ed.maildir_root AS maildir_root
FROM
  email_domains AS ed
  JOIN email_domain_statuses AS eds ON ed.email_domain_status_id = eds.email_domain_status_id
WHERE
  ed.email_domain = 'datr.tech'
  AND eds.email_domain_status = 'active';
