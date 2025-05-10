/*
 * script     1044_insert_user_email_address__strachan_alias_joe_strachan.sql
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
VALUES
(
	( SELECT user_id         FROM users         WHERE ref          = 'joealdersonstrachan' ),
	( SELECT user_name_id    FROM user_names    WHERE user_name    = 'joe'                 ),
	( SELECT email_domain_id FROM email_domains WHERE email_domain = 'strachan.email'      )
),
(
	( SELECT user_id         FROM users         WHERE ref          = 'joealdersonstrachan' ),
	( SELECT user_name_id    FROM user_names    WHERE user_name    = 'joe'                 ),
	( SELECT email_domain_id FROM email_domains WHERE email_domain = 'localhost'           )
);
