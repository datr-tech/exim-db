/*
 * script     1020_insert_user_strachan.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 *
 * update     20th February 2025 - The existing UID and GID has been replaced with those for the 'dovecot_imap_service' user and the 'mail' group
 */
USE email_accounts;

INSERT INTO users (
	user_group_id		,
	user_status_id	,
	user_type_id		,
	ref							,
	uid							,
	gid							,
	password
)
VALUES
(
	( SELECT user_group_id  FROM user_groups   WHERE user_group  = 'default' ) ,
	( SELECT user_status_id FROM user_statuses WHERE user_status = 'active'  ) ,
	( SELECT user_type_id   FROM user_types    WHERE user_type   = 'system'  ) ,
	'joealdersonstrachan'																											 ,
  2000																																			 ,
	8																																			     ,
	MD5('Titania09')
);
