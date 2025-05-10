/*
 * script     1014_insert_user_statuses.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

INSERT INTO user_statuses (user_status) VALUES ('active'), ('inactive');
