/*
 * script     1003_create_table_user_names.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

DROP TABLE IF EXISTS user_names;

CREATE TABLE user_names (

  user_name_id        MEDIUMINT     UNSIGNED  NOT NULL            AUTO_INCREMENT PRIMARY KEY ,
  user_name_type_id   TINYINT       UNSIGNED  NOT NULL                                       ,
  user_name           VARCHAR(40)             NOT NULL                                       ,
  created             TIMESTAMP               NOT NULL  DEFAULT   CURRENT_DATE()             ,
  modified            TIMESTAMP                   NULL  ON UPDATE CURRENT_TIMESTAMP          ,

  FOREIGN KEY (user_name_type_id)
    REFERENCES user_name_types(user_name_type_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT                                                                       ,

  CONSTRAINT unique_user_name UNIQUE (user_name)

) ENGINE=InnoDB;
