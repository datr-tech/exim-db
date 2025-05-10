/*
 * script     1031_insert_user_email_address__admin_username_strachan.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

INSERT INTO user_email_addresses (
	user_id					,
	user_name_id		,
	email_domain_id
)
VALUES (
	( SELECT user_id         FROM users         WHERE ref          = 'admin'          ),
	( SELECT user_name_id    FROM user_names    WHERE user_name    = 'admin'          ),
	( SELECT email_domain_id FROM email_domains WHERE email_domain = 'strachan.email' )
);
