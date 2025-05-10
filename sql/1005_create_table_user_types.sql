/*
 * script     1005_create_table_user_types.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

DROP TABLE IF EXISTS user_types;

CREATE TABLE user_types (

  user_type_id  TINYINT       UNSIGNED  NOT NULL            AUTO_INCREMENT PRIMARY KEY ,
  user_type     VARCHAR(40)             NOT NULL                                       ,
  created       TIMESTAMP               NOT NULL  DEFAULT   CURRENT_DATE()             ,
  modified      TIMESTAMP                   NULL  ON UPDATE CURRENT_TIMESTAMP          ,

  CONSTRAINT unique_user_type UNIQUE (user_type)

) ENGINE=InnoDB;
