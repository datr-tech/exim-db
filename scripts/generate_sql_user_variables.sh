#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'


#####################################################################
#                                                                   #
# Script:  generate_sql_user_variables.sh                           #
#                                                                   #
# Purpose: Generate ./sql/0000_define_user_variables.sql            #
#          with values from (a populated version of) .env           #
#                                                                   #
# Date:    10th May 2025                                            #
# Author:  admin <admin@datr.tech>                                  #
#                                                                   #
#                                                                   #
# Example: 'npm run sql:generate' to manually run this script.      #
#          It will be trigged automatically by another NPM          #
#          command, namely, 'npm run start'.                        #
#                                                                   #
#                                                                   #
# Note:    An example version of the expected .sql file can         #
#          be found at the following path:                          #
#          ./sql/0000_define_user_variables.example                 #
#                                                                   #
#####################################################################


#####################################################################
#                                                                   #
# CORE SECTIONS (within the code below)                             #
#                                                                   #
#                                                                   #
# 1 ENV VAR AND DEPENDENCY DEFINITIONS                              #
#                                                                   #
# 1.1  SCRIPT CONSTANTS                                             #
# 1.2  DEFINE THE REQUIRED SCRIPT DEPENDENCIES                      #
# 1.3  DEFINE THE REQUIRED ENV VARS                                 #
# 1.4  DEFINE THE DOT ENV FILE PATH                                 #
# 1.5  DEFINE THE SQL FILE PATH                                     #
#                                                                   #
#                                                                   #
# 2 DEPENDENCY AND PATH CHECKS                                      #
#                                                                   #
# 2.1 CHECK THE REQUIRED SCRIPT DEPENDENCIES                        #
# 2.2 CHECK THE DOT ENV FILE PATH                                   #
# 2.3 CHECK THE SQL DIR PATH                                        #
# 2.4 CHECK THAT THE SQL FILE DOES NOT EXIST                        #
#                                                                   #
#                                                                   #
# 3 LOAD AND CHECK ENV VARS                                         #
#                                                                   #
# 3.1 LOAD ENV VARS                                                 #
# 3.2 CHECK THE REQUIRED ENV VARS                                   #
#                                                                   #
#                                                                   #
# 4 GENERATE THE SQL FILE                                           #
#                                                                   #
#####################################################################


#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 1 ENVIRONMENT VARIABLE AND DEPENDENCY DEFINITIONS                 #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################


#####################################################################
#                                                                   #
# 1.1 SCRIPT CONSTANTS                                              #
#                                                                   #
#####################################################################

FORMATTED_DATE=$(date +%F)
readonly FORMATTED_DATE

declare -r SCRIPT_FILE_NAME="prestart.sh"

ROOT_DIR_PATH="$(dirname "${BASH_SOURCE[-1]}")/.."
readonly ROOT_DIR_PATH

SQL_DIR_PATH="${ROOT_DIR_PATH}/sql"
readonly SQL_DIR_PATH


#####################################################################
#                                                                   #
# 1.2 DEFINE THE REQUIRED SCRIPT DEPENDENCIES                       #
#                                                                   #
#####################################################################

declare -a -r SCRIPT_FILE_REQUIRED_DEPENDENCIES=(
  "realpath"
	"sed"
  "source"
)


#####################################################################
#                                                                   #
# 1.3 DEFINE THE REQUIRED ENV VARS                                  #
#                                                                   #
#####################################################################

declare -a -r SCRIPT_FILE_REQUIRED_ENV_VARS=(
  "EXIM_DB_USER_ADMIN_NAME"
  "EXIM_DB_USER_ADMIN_PASS"
  "EXIM_DB_USER_DATR_TECH_NAME"
  "EXIM_DB_USER_DATR_TECH_PASS"
  "EXIM_DB_USER_DOVECOT_NAME"
  "EXIM_DB_USER_DOVECOT_PASS"
  "EXIM_DB_USER_EXIM_MTA_NAME"
  "EXIM_DB_USER_EXIM_MTA_PASS"
)


#####################################################################
#                                                                   #
# 1.4 DEFINE THE DOT ENV FILE PATH                                  #
#                                                                   #
#####################################################################

declare -r DOT_ENV_FILE_PATH="${ROOT_DIR_PATH}/.env"


#####################################################################
#                                                                   #
# 1.5 DEFINE THE SQL FILE PATH                                      #
#                                                                   #
#####################################################################

declare -r SQL_FILE_NAME="0000_define_user_variables.sql"
declare -r SQL_FILE_PATH="${SQL_DIR_PATH}/${SQL_FILE_NAME}"


#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 2 DEPENDENCY AND PATH CHECKS                                      #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################


#####################################################################
#                                                                   #
# 2.1 CHECK THE REQUIRED SCRIPT DEPENDENCIES                        #
#                                                                   #
#####################################################################

declare required_dependency

for required_dependency in "${SCRIPT_FILE_REQUIRED_DEPENDENCIES[@]}"; do
  if ! command -v "${required_dependency}" > /dev/null 2>&1; then
    echo "${SCRIPT_FILE_NAME}: ${required_dependency}: not found" >&2
    exit 1
  fi
done


#####################################################################
#                                                                   #
# 2.2 CHECK THE DOT ENV FILE PATH                                   #
#                                                                   #
#####################################################################

if [ ! -f "${DOT_ENV_FILE_PATH}" ]; then
  echo "DOT_ENV_FILE_PATH: invalid"
  exit 1
fi


#####################################################################
#                                                                   #
# 2.3 CHECK THE SQL DIR PATH                                        #
#                                                                   #
#####################################################################

if [ ! -f "${SQL_DIR_PATH}" ]; then
  echo "DOT_ENV_FILE_PATH: invalid"
  exit 1
fi


#####################################################################
#                                                                   #
# 2.4 CHECK THAT THE SQL FILE DOES NOT EXIST                        #
#                                                                   #
#####################################################################

if [ -f "${SQL_FILE_PATH}" ]; then
  echo "SQL_FILE_PATH: exists"
  rm -f "${SQL_FILE_PATH}"
fi


#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 3 LOAD AND CHECK ENV VARS                                         #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################


#####################################################################
#                                                                   #
# 3.1 LOAD ENV VARS                                                 #
#                                                                   #
#####################################################################

# shellcheck source=.env
source "${DOT_ENV_FILE_PATH}"


#####################################################################
#                                                                   #
# 3.2 CHECK THE REQUIRED ENV VARS                                   #
#                                                                   #
#####################################################################

declare required_env_var

for required_env_var in "${SCRIPT_FILE_REQUIRED_ENV_VARS[@]}"; do
  #
  # Note the use of 'indirect variable expansion' below.
  #
  if [ -z "${!required_env_var}" ]; then
    echo "${SCRIPT_FILE_NAME}: ${required_env_var}: not found" >&2
    exit 1
  fi
done


#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 4 GENERATE THE SQL FILE                                           #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

cat << EOF
	/*
	 * @script     0000_define_user_variables.sql
	 *
	 * @created    ${FORMATTED_DATE}
	 * @author     Datr.Tech Admin <admin@datr.tech>
	 */
	SET @user_admin_name = "${EXIM_DB_USER_ADMIN_NAME}";
	SET @user_admin_pass = "${EXIM_DB_USER_ADMIN_PASS}";
	SET @user_datr_tech_name = "${EXIM_DB_USER_DATR_TECH_NAME}";
	SET @user_datr_tech_pass = "${EXIM_DB_USER_DATR_TECH_PASS}";
	SET @user_dovecot_name = "${EXIM_DB_USER_DOVECOT_NAME}";
	SET @user_dovecot_pass = "${EXIM_DB_USER_DOVECOT_PASS}";
	SET @user_exim_name = "${EXIM_DB_USER_EXIM_MTA_NAME}";
	SET @user_exim_pass = "${EXIM_DB_USER_EXIM_MTA_PASS}";
EOF > "${SQL_FILE_PATH}"

