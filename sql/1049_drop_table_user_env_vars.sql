/*
 * @script    1049_drop_table_user_env_vars.sql
 *
 * purpose    Drop the user env var table, which was populated
 *            by 0000_create_table_user_env_vars.sql, and which
 *            contained user creation values from .env.
 *
 * @created   11th May 2025
 * @author    Datr.Tech Admin <admin@datr.tech>
 */
USE email_accounts;

DROP TABLE IF EXISTS user_env_vars;
