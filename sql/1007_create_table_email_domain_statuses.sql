/*
 * script     1007_create_table_email_domain_statuses.sql
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
USE email_accounts;

DROP TABLE IF EXISTS email_domain_statuses;

CREATE TABLE email_domain_statuses (

  email_domain_status_id  TINYINT      UNSIGNED   NOT NULL            AUTO_INCREMENT PRIMARY KEY ,
  email_domain_status     VARCHAR(100)            NOT NULL                                       ,
  created                 TIMESTAMP               NOT NULL  DEFAULT   CURRENT_DATE()             ,
  modified                TIMESTAMP                   NULL  ON UPDATE CURRENT_TIMESTAMP          ,

  CONSTRAINT unique_email_domain_status
    UNIQUE (email_domain_status)

) ENGINE=InnoDB;
