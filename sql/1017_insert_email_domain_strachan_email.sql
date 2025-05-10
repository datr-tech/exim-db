/*
 * script     1017_insert_email_domain_strachan_email.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

INSERT INTO email_domains (email_domain, email_domain_path, maildir_root, email_domain_status_id)
VALUES(
	'strachan.email'           ,
	'/var/mail/strachan_email' ,
	'/var/mail'                ,
	(SELECT email_domain_status_id FROM email_domain_statuses WHERE email_domain_status = 'active')
);
