/*
 * script     1027_insert_user_name_username_admin.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

INSERT INTO user_names (
	user_name_type_id ,
	user_name
)
VALUES (
	( SELECT user_name_type_id FROM user_name_types WHERE user_name_type = 'username' ),
	'admin'
);
