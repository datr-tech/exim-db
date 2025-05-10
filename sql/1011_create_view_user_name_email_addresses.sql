/*
 * script     1011_create_view_user_name_email_addresses.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

DROP VIEW IF EXISTS user_name_email_addresses;

CREATE VIEW user_name_email_addresses AS
SELECT
  
	u.user_id																			AS user_id						  ,
	u.ref																					AS user_ref						  ,
  CONCAT(un.user_name, '@', ed.email_domain)    AS email_address        ,
  us.user_status                                AS user_status          ,
  eds.email_domain_status                       AS email_domain_status

FROM        users                  AS u
INNER JOIN  user_groups            AS ug      ON u.user_group_id             = ug.user_group_id
INNER JOIN  user_statuses          AS us      ON u.user_status_id            = us.user_status_id
INNER JOIN  user_types             AS ut      ON u.user_type_id              = ut.user_type_id
INNER JOIN  user_email_addresses   AS uea     ON u.user_id                   = uea.user_id
LEFT  JOIN  user_names             AS un      ON uea.user_name_id            = un.user_name_id
LEFT  JOIN  user_name_types        AS unt     ON un.user_name_type_id        = unt.user_name_type_id
LEFT  JOIN  email_domains          AS ed      ON uea.email_domain_id         = ed.email_domain_id
LEFT  JOIN  email_domain_statuses  AS eds     ON ed.email_domain_status_id   = eds.email_domain_status_id;
