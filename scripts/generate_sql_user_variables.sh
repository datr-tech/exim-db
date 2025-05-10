#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

#####################################################################
#                                                                   #
#                                                                   #
# Script:  generate_sql_user_variables.sh                           #
#                                                                   #
#                                                                   #
# Purpose: Generate the '0000_define_user_variables.sql' file       #
#          the ROOT/sql dir, and do so based upon the following     #
#          template:                                                #
#                                                                   #
#          'ROOT/sql/0000_define_user_variables.sql.TEMPLATE'       #
#                                                                   #
#          The generated file will be populated with user vars      #
#          from 'ROOT/.env', assuming that the env vars identified  #
#          within the 'required_env_vars' array (see section 1.4    #
#          below) have been updated and that they are not           #
#          associated with the default empty values.                #
#                                                                   #
#                                                                   #
# Date:    10th May 2025                                            #
# Author:  admin <admin@datr.tech>                                  #
#                                                                   #
#                                                                   #
#####################################################################

#####################################################################
#                                                                   #
#                                                                   #
# CORE SECTIONS (within the code below)                             #
# =====================================                             #
#                                                                   #
#                                                                   #
# 1 DEFINITIONS                                                     #
# -------------                                                     #
#                                                                   #
# 1.1  Common vars                                                  #
# 1.2  Paths                                                        #
# 1.3  Required env vars                                            #
# 1.4  Required script dependencies (for the current file)          #
# 1.5  Dates and timestamps                                         #
#                                                                   #
#                                                                   #
# 2 DEPENDENCY AND PATH CHECKS                                      #
# ----------------------------                                      #
#                                                                   #
# 2.1  Check required dependencies (for the current file)           #
# 2.2  Check the dot env file path                                  #
# 2.3  Check the sql dir path                                       #
# 2.4  Check that the sql template file exists                      #
# 2.5  Check that the sql destination file does not exist           #
#                                                                   #
#                                                                   #
# 3 LOAD AND CHECK ENV VARS                                         #
# -------------------------                                         #
#                                                                   #
# 3.1 Load end vars                                                 #
# 3.2 Check the required env vars                                   #
#                                                                   #
#                                                                   #
# 4 GENERATE THE SQL FILE                                           #
# -----------------------                                           #
#                                                                   #
# 4.1 Access the contents of sql template file path                 #
# 4.2 Parse the accessed template                                   #
# 4.3 Populate the parsed template                                  #
# 4.4 Add a new header and write the populate template              #
#                                                                   #
#                                                                   #
#####################################################################

#####################################################################
#####################################################################
#                                                                   #
#                                                                   #
# 1 DEFINITIONS                                                     #
#                                                                   #
#                                                                   #
#####################################################################
#####################################################################

#####################################################################
#                                                                   #
# 1.1  Common vars                                                  #
#                                                                   #
#####################################################################

declare -r current_file_name="generate_sql_user_variables.sh"
declare -r dot_env_file_name=".env"
declare -r scripts_dir_name="scripts"
declare -r sql_destination_file_name="0000_define_user_variables.sql"
declare -r sql_dir_name="sql"
declare -r sql_template_file_name="${sql_destination_file_name}.TEMPLATE"

#####################################################################
#                                                                   #
# 1.2  Required env vars                                            #
#                                                                   #
#####################################################################

declare -a -r required_env_vars=(
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
# 1.3  Paths                                                        #
#                                                                   #
#####################################################################

scripts_dir_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
readonly scripts_dir_path

root_dir_path="${scripts_dir_path/\/${scripts_dir_name}/}"
readonly root_dir_path

dot_env_file_path="${root_dir_path}/${dot_env_file_name}"
readonly dot_env_file_path

sql_dir_path="${root_dir_path}/${sql_dir_name}"
readonly sql_dir_path

sql_destination_file_path="${sql_dir_path}/${sql_destination_file_name}"
readonly sql_destination_file_path

sql_template_file_path="${sql_dir_path}/${sql_template_file_name}"
readonly sql_template_file_path

#####################################################################
#                                                                   #
# 1.4  Required script dependencies (for the current file)          #
#                                                                   #
#####################################################################

declare -a -r current_file_required_dependencies=("grep")

#####################################################################
#                                                                   #
# 1.5  Dates and timestamps                                         #
#                                                                   #
#####################################################################

formatted_date=$(date +%F)
readonly formatted_date

timestamp=$(date +%s)
readonly timestamp


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
# 2.1  Check the required dependencies (for the current file)       #
#                                                                   #
#####################################################################

declare required_dependency

for required_dependency in "${current_file_required_dependencies[@]}"; do
  if ! command -v "${required_dependency}" > /dev/null 2>&1; then
    echo "${current_file_name}: ${required_dependency}: not found" >&2
    exit 1
  fi
done


#####################################################################
#                                                                   #
# 2.2  Check the dot env file path                                  #
#                                                                   #
#####################################################################

echo "${dot_env_file_path}"

if [ ! -s "${dot_env_file_path}" ]; then
  echo "dot_env_file_path: invalid"
  exit 1
fi


#####################################################################
#                                                                   #
# 2.3  Check the sql dir path                                       #
#                                                                   #
#####################################################################

if [ ! -d "${sql_dir_path}" ]; then
  echo "sql_dir_path: invalid"
  exit 1
fi

#####################################################################
#                                                                   #
# 2.4  Check that the sql template file exists                      #
#                                                                   #
#####################################################################

if [ ! -f "${sql_template_file_path}" ]; then
  echo "sql_template_file_path: not exists"
fi

#####################################################################
#                                                                   #
# 2.5  Check that the sql destination file does not exist           #
#                                                                   #
#####################################################################

if [ -f "${sql_destination_file_path}" ]; then
	mv "${sql_destination_file_path}" "${sql_destination_file_path}.${timestamp}.bak"
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
# 3.1  Load env vars                                                #
#                                                                   #
#####################################################################

# shellcheck source=.env
set -a            
source "${dot_env_file_path}"
set +a

#####################################################################
#                                                                   #
# 3.2  Check the required env vars                                  #
#                                                                   #
#####################################################################

declare required_env_var

for required_env_var in "${required_env_vars[@]}"; do
  if [ -z "${!required_env_var}" ]; then
    echo "${current_file_name}: ${required_env_var}: not found" >&2
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

#####################################################################
#                                                                   #
# 4.1  Access the contents of sql template file path                #
#                                                                   #
#####################################################################

template=$(cat "${sql_template_file_path}")

#####################################################################
#                                                                   #
# 4.2  Parse the accessed template                                  #
#                                                                   #
#####################################################################

parsed_template="${template}"

parsed_template=$(echo "${parsed_template}" | grep -v "*")
parsed_template="${parsed_template//\$\{/}"
parsed_template="${parsed_template//\}/}"

#####################################################################
#                                                                   #
# 4.3  Populate the parsed template                                 #
#                                                                   #
#####################################################################

populated_template="${parsed_template}"

for required_env_var in "${required_env_vars[@]}"; do
	populated_template="${populated_template/${required_env_var}/${!required_env_var}}"
done

#####################################################################
#                                                                   #
# 4.4  Add a new header and write the populate template             #
#                                                                   #
#####################################################################

#shellcheck source=/sql/0000_define_user_variables.sql
cat << EOF > "${sql_destination_file_path}"
/*
 * @script     0000_define_user_variables.sql
 *
 * @created    ${formatted_date}
 * @author     Datr.Tech Admin <admin@datr.tech>
 */
  ${populated_template}
EOF
