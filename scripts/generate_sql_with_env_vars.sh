#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

#####################################################################
#                                                                   #
#                                                                   #
# Script:  generate_sql_with_env_vars.sh                            #
#                                                                   #
#                                                                   #
# Purpose: Generate exim_db.sql by combining the decoded contents   #
#          of exim_db.sql.b64 with SQL user variables dynamically   #
#          created from .env.                                       #
#                                                                   #
# Date:    10th May 2025                                            #
# Author:  datr.tech admin <admin@datr.tech>                        #
#                                                                   #
#                                                                   #
#####################################################################

#####################################################################
#                                                                   #
#                                                                   #
# SECTIONS (within the code below)                                  #
# ================================                                  #
#                                                                   #
#                                                                   #
# 1. DEFINITIONS                                                    #
# --------------                                                    #
#                                                                   #
# 1.1   Primary file names                                          #
# 1.2   Secondary file and dir names                                #
# 1.3   Required env vars                                           #
# 1.4   Required dependencies (for the current file)                #
#                                                                   #
#                                                                   #
# 2. CHECK DEPENDENCIES                                             #
# ---------------------                                             #
#                                                                   #
# 2.1   Check required dependencies (for the current file)          #
#                                                                   #
#                                                                   #
# 3. DIR AND FILE PATHS                                             #
# ---------------------                                             #
#                                                                   #
# 3.1   Dir paths                                                   #
# 3.2   File paths                                                  #
# 3.3   Check ENV_FILE_PATH                                         #
# 3.4   Check IN_FILE_PATH                                          #
#                                                                   #
#                                                                   #
# 4. LOAD AND CHECK ENV VARS                                        #
# -------------------------                                         #
#                                                                   #
# 4.1   Load end vars                                               #
# 4.2   Check the required env vars                                 #
#                                                                   #
#                                                                   #
# 5. READ AND DECODE IN_FILE_PATH                                   #
# -------------------------------                                   #
#                                                                   #
# 5.1  Read the encoded contents of IN_FILE_PATH                    #
# 5.2  Check the encoded contents                                   #
# 5.3  Decode the contents of IN_FILE_PATH                          #
# 5.4  Check the decoded contents                                   #
#                                                                   #
#                                                                   #
# 6. ADD ENV VARS TO THE DECODED FILE CONTENTS                      #
# --------------------------------------------                      #
#                                                                   #
# 6.1  Create a 'header' with a SQL user variable for each env var  #
# 6.2  Add a 'USE DATABASE' statement                               #
# 6.3  Combine the SQL user variables and the decoded file contents #
# 6.4  Add read only users                                          #
#                                                                   #
#                                                                   #
# 7. WRITE TO OUT_FILE_PATH                                         #
# -------------------------                                         #
#                                                                   #
# 7.1  Back up OUT_FILE_PATH (if it exists)                         #
# 7.2  Write to OUT_FILE_PATH                                       #
#                                                                   #
#                                                                   #
#####################################################################

#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 1. DEFINITIONS                                                    #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

#####################################################################
#                                                                   #
# 1.1  Primary file names                                           #
#                                                                   #
#####################################################################

declare -r IN_FILE_NAME="exim_db.sql.b64"
declare -r OUT_FILE_NAME="exim_db.sql"

#####################################################################
#                                                                   #
# 1.2  Secondary file and dir names                                 #
#                                                                   #
#####################################################################

declare -r ENV_FILE_NAME=".env"
declare -r SQL_DIR_NAME="sql"
declare -r SCRIPTS_DIR_NAME="scripts"

#####################################################################
#                                                                   #
# 1.3  Required env vars                                            #
#                                                                   #
#####################################################################

declare -a -r REQUIRED_ENV_VARS=(
  "EXIM_DB_NAME"
  "EXIM_DB_READ_ONLY_USER_EXIM_MTA_NAME"
  "EXIM_DB_READ_ONLY_USER_EXIM_MTA_PASS"
  "EXIM_DB_READ_ONLY_USER_EXIM_IMAP_NAME"
  "EXIM_DB_READ_ONLY_USER_EXIM_IMAP_PASS"
  "EXIM_DB_EMAIL_USER_ADMIN_NAME"
  "EXIM_DB_EMAIL_USER_ADMIN_PASS"
  "EXIM_DB_EMAIL_USER_DATR_TECH_NAME"
  "EXIM_DB_EMAIL_USER_DATR_TECH_PASS"
)

#####################################################################
#                                                                   #
# 1.4  Required dependencies (for the current file)                 #
#                                                                   #
#####################################################################

declare -a -r REQUIRED_DEPENDENCIES=(
  "base64"
  "dirname"
  "grep"
  "source"
  "set"
)

#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 2. CHECK DEPENDENCIES                                             #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

#####################################################################
#                                                                   #
# 2.1  Check the required dependencies (for the current file)       #
#                                                                   #
#####################################################################

declare required_dependency

for required_dependency in "${REQUIRED_DEPENDENCIES[@]}"; do
  if ! command -v "${required_dependency}" > /dev/null 2>&1; then
    echo "${required_dependency}: not found" >&2
    exit 1
  fi
done

#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 3. DIR AND FILE PATHS                                             #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

#####################################################################
#                                                                   #
# 3.1  Dir paths                                                    #
#                                                                   #
#####################################################################

SCRIPTS_DIR_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
readonly SCRIPTS_DIR_PATH

ROOT_DIR_PATH="${SCRIPTS_DIR_PATH/\/${SCRIPTS_DIR_NAME}/}"
readonly ROOT_DIR_PATH

SQL_DIR_PATH="${ROOT_DIR_PATH}/${SQL_DIR_NAME}"
readonly SQL_DIR_PATH

#####################################################################
#                                                                   #
# 3.2  File paths                                                   #
#                                                                   #
#####################################################################

ENV_FILE_PATH="${ROOT_DIR_PATH}/${ENV_FILE_NAME}"
readonly ENV_FILE_PATH

IN_FILE_PATH="${SQL_DIR_PATH}/${IN_FILE_NAME}"
readonly IN_FILE_PATH

OUT_FILE_PATH="${SQL_DIR_PATH}/${OUT_FILE_NAME}"
readonly OUT_FILE_PATH

#####################################################################
#                                                                   #
# 3.3  Check ENV_FILE_PATH                                          #
#                                                                   #
#####################################################################

#shellcheck source=/.env
if [ ! -s "${ENV_FILE_PATH}" ]; then
  echo "ENV_FILE_PATH: invalid"
  exit 1
fi

#####################################################################
#                                                                   #
# 3.4  Check IN_FILE_PATH                                           #
#                                                                   #
#####################################################################

#shellcheck source=/sql/exim_db.sql.b64
if [ ! -s "${IN_FILE_PATH}" ]; then
  echo "IN_FILE_PATH: invalid"
  exit 1
fi

#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 4. LOAD AND CHECK ENV VARS                                        #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

#####################################################################
#                                                                   #
# 4.1  Load env vars                                                #
#                                                                   #
#####################################################################

set -a
# shellcheck source=/.env
source "${ENV_FILE_PATH}"
set +a

#####################################################################
#                                                                   #
# 4.2  Check the required env vars                                  #
#                                                                   #
#####################################################################

declare required_env_var

for required_env_var in "${REQUIRED_ENV_VARS[@]}"; do
  if [ -z "${!required_env_var}" ]; then
    echo "${required_env_var}: not found" >&2
    exit 1
  fi
done

#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 5. READ AND DECODE IN_FILE_PATH                                   #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

#####################################################################
#                                                                   #
# 5.1  Read the encoded contents of IN_FILE_PATH                    #
#                                                                   #
#####################################################################

in_file_contents_encoded=$(cat "${IN_FILE_PATH}")
readonly in_file_contents_encoded

#####################################################################
#                                                                   #
# 5.2  Check the encoded contents                                   #
#                                                                   #
#####################################################################

if [ -z "${in_file_contents_encoded}" ]; then
  echo "${in_file_contents_encoded}: invalid" >&2
  exit 1
fi

#####################################################################
#                                                                   #
# 5.3  Decode the contents of IN_FILE_PATH                          #
#                                                                   #
#####################################################################

in_file_contents_decoded=$(echo "${in_file_contents_encoded}" | base64 -d)
readonly in_file_contents_decoded

#####################################################################
#                                                                   #
# 5.4  Check the decoded contents                                   #
#                                                                   #
#####################################################################

if [ -z "${in_file_contents_decoded}" ]; then
  echo "${in_file_contents_decoded}: invalid" >&2
  exit 1
fi

#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 6. ADD ENV VARS TO THE DECODED FILE CONTENTS                      #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

#####################################################################
#                                                                   #
# 6.1  Create a 'header' with a SQL user variable for each env var  #
#                                                                   #
#####################################################################

out_file_header=""

for required_env_var in "${REQUIRED_ENV_VARS[@]}"; do
  out_file_header="${out_file_header}SET @${required_env_var}='${!required_env_var}';\n"
done

#####################################################################
#                                                                   #
# 6.2  Add a 'USE DATABASE' statement                               #
#                                                                   #
#####################################################################

exim_db_name="${EXIM_DB_NAME:-""}"

if [ -z "${exim_db_name}" ]; then
  echo "exim_db_name: invalid" >&2
  exit 1
fi

out_file_header="${out_file_header}\nUSE ${exim_db_name};\n"

#####################################################################
#                                                                   #
# 6.3  Combine the SQL user variables and the decoded file contents #
#                                                                   #
#####################################################################

out_file_contents="${out_file_header}${in_file_contents_decoded}\n"

#####################################################################
#                                                                   #
# 6.4  Add read only users                                          #
#                                                                   #
#####################################################################

out_file_contents="${out_file_contents}DROP USER IF EXISTS '${EXIM_DB_READ_ONLY_USER_EXIM_IMAP_NAME}'@'localhost';\n"
out_file_contents="${out_file_contents}CREATE USER '${EXIM_DB_READ_ONLY_USER_EXIM_IMAP_NAME}'@'localhost' IDENTIFIED BY '${EXIM_DB_READ_ONLY_USER_EXIM_IMAP_PASS}';\n"
out_file_contents="${out_file_contents}GRANT SELECT ON ${exim_db_name}.user_name_domains TO '${EXIM_DB_READ_ONLY_USER_EXIM_IMAP_NAME}'@'localhost';\n"

out_file_contents="${out_file_contents}DROP USER IF EXISTS '${EXIM_DB_READ_ONLY_USER_EXIM_MTA_NAME}'@'localhost';\n"
out_file_contents="${out_file_contents}CREATE USER '${EXIM_DB_READ_ONLY_USER_EXIM_MTA_NAME}'@'localhost' IDENTIFIED BY '${EXIM_DB_READ_ONLY_USER_EXIM_MTA_PASS}';\n"
out_file_contents="${out_file_contents}GRANT SELECT ON ${exim_db_name}.user_name_domains TO '${EXIM_DB_READ_ONLY_USER_EXIM_MTA_NAME}'@'localhost';\n"

#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 7. WRITE TO OUT_FILE_PATH                                         #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

#####################################################################
#####################################################################
#                                                                   #
# 7.1  Back up OUT_FILE_PATH (if it exists)                         #
#                                                                   #
#####################################################################

if [ -f "${OUT_FILE_PATH}" ]; then
  timestamp=$(date +%s)
  readonly timestamp

  mv "${OUT_FILE_PATH}" "${OUT_FILE_PATH}.${timestamp}.bak"
fi

#####################################################################
#                                                                   #
# 7.2  Write to OUT_FILE_PATH                                       #
#                                                                   #
#####################################################################

echo -e "${out_file_contents}" > "${OUT_FILE_PATH}"
