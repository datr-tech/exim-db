#!/usr/bin/env bash

set -o pipefail -o errtrace -o errexit -o nounset

export DEBIAN_FRONTEND=noninteractive

######################################################################
#                                                                    #
# NAME   sql.sh                                                      #
#                                                                    #
# DESC   Process each *.sql file from ../sql                         #
#                                                                    #
# DATE   4th February 2025                                           #
#                                                                    #
# AUTHOR J.A.Strachan                                                #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# USAGE                                                              #
#                                                                    #
# sudo ./sql.sh                                                      #
# sudo make install-sql (from root dir)                              #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# SCRIPT CONTENTS                                                    #
# ===============                                                    #
#                                                                    #
# The code within this script (see further below) contains the       #
# following numerically ordered sections.                            #
#                                                                    #
#                                                                    #
# 1 SETUP                                                            #
# -------                                                            #
#                                                                    #
# 1.1 CONSTANTS                                                      #
#                                                                    #
#   1.1.1  Define root_dir                                           #
#   1.1.2  Derive the full path (of the current script)              #
#   1.1.3  Define the required dependencies (of the current script)  #
#                                                                    #
# 1.2 VARS                                                           #
#                                                                    #
#   1.2.1 sql file path vars                                         #
#                                                                    #
#                                                                    #
# 2 PRE-ACTION CHECKS                                                #
# -------------------                                                #
#                                                                    #
# 2.1 SCRIPT CHECKS                                                  #
#                                                                    #
#   2.1.1 Check script permissions                                   #
#   2.1.2 Check required script dependencies                         #
#                                                                    #
#                                                                    #
# 3 ACTION                                                           #
# --------                                                           #
#                                                                    #
# 3.1 PROCESS EACH SQL FILE IN ../sql                                #
#                                                                    #
#                                                                    #
######################################################################


######################################################################
######################################################################
#                                                                    #
# 1 SETUP                                                            #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 1.1 CONSTANTS                                                      #
#                                                                    #
######################################################################

#
# 1.1.1 Define common dirs
#
root_dir="$(dirname "${BASH_SOURCE[0]}")/.."
declare -r root_dir
declare -r scripts_dir="${root_dir}/scripts"
declare -r sql_dir="${root_dir}/sql"

#
# 1.1.2 Derive the full path (of the current script)
#
declare -r script_name="maria-sql.sh"
declare -r script_path="${scripts_dir}/${script_name}"

#
# 1.1.3 Define the required dependencies (of the current script)
#
declare -a -r required_script_dependencies=(
  "find"
  "mariadb"
	"readlink"
	"sort"
)


######################################################################
#                                                                    #
# 1.2 VARS                                                           #
#                                                                    #
######################################################################

#
# 1.2.1 sql file path vars
#
declare    sql_file_path=""
declare -a sql_file_paths=( )


######################################################################
######################################################################
#                                                                    #
# 2 PRE-ACTION CHECKS                                                #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 2.1 SCRIPT CHECKS                                                  #
#                                                                    #
######################################################################

#
# 2.1.1 Check script permissions
#
if [[ "${EUID}" -ne 0 ]]; then
  echo "use: sudo ${script_path}" >&2
  exit 1
fi

#
# 2.1.2 Check required script dependencies
#
for required_script_dependency in "${required_script_dependencies[@]}"
do
  if ! command -v "${required_script_dependency}" > /dev/null 2>&1; then
    echo "${required_script_dependency}: not found" >&2
    exit 1
  fi
done


######################################################################
######################################################################
#                                                                    #
# 3 ACTION                                                           #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 3.1 PROCESS EACH SQL FILE IN ../sql                                #
#                                                                    #
######################################################################

sql_file_paths=( "${sql_dir}"/*.sql )

for sql_file_path in "${sql_file_paths[@]}"
do	
  
	if [ -z "${sql_file_path}" ]; then
    echo "sql_file_path: empty" >&2
	  exit 1	
	fi

	if [ -f "${sql_file_path}" ]; then
    echo "${sql_file_path/${sql_dir}/}"
    mariadb < "${sql_file_path}"
	fi

done
