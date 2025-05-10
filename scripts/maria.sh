#!/usr/bin/env bash

set -o pipefail -o errtrace -o errexit -o nounset

export DEBIAN_FRONTEND=noninteractive

######################################################################
#                                                                    #
# NAME  maria.sh                                                     #
# DESC  Install or remove a local instance of MariaDB                #
# DATE  23th January 2025                                            #
#                                                                    #
# AUTHOR J.A.Strachan                                                #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# USAGE                                                              #
#                                                                    #
# sudo ./maria.sh [action_type]                                      #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# ARGS                                                               #
#                                                                    #
# Arg 1                                                              #
#   - name: action_type                                              #
#   - type: string [required]                                        #
#   - possible values: 'install' and 'remove'                        #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# EXAMPLE                                                            #
#                                                                    #
# sudo ./maria.sh install                                            #
# sudo ./maria.sh remove                                             #
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
#                                                                    #
# 1 SETUP                                                            #
# -------                                                            #
#                                                                    #
# 1.1 CONSTANTS                                                      #
#                                                                    #
#   1.1.1  Define root_dir                                           #
#   1.1.2  Define the core pkg (to be installed or removed)          #
#   1.1.3  Derive the full path (of the current script)              #
#   1.1.4  Define the required dependencies (of the current script)  #
#   1.1.5  Define all pkgs to be either installed                    #
#   1.1.6  Define all pkgs to be either removed                      #
#   1.1.7  Define all pkgs to be either purged                       #
#   1.1.8  Define service statuses (for the core pkg)                #
#   1.1.9  Define allowed values for the action_type arg             #
#   1.1.10 Define MariaDB root password                              #
#                                                                    #
# 1.2 VARS                                                           #
#                                                                    #
#   1.2.1 Validity vars                                              #
#   1.2.2 Working vars                                               #
#   1.2.3 Debconf properties                                         #
#                                                                    #
# 1.3 ARGS                                                           #
#                                                                    #
#   1.3.1 Populate action_type with the received value (arg 1)       #
#   1.3.2 Ensure that action_type contains one of the allowed types  #
#                                                                    #
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
# 2.2 COMMON SERVICE CHECKS                                          #
#                                                                    #
#   2.2.1 Check for an existing active service                       #
#                                                                    #
# 2.3 PRE-INSTALLATION CHECKS                                        #
#                                                                    #
#   2.3.1 Check for an existing inactive service                     #
#   2.3.2 Check for the absence of an existing CMD installation      #
#                                                                    #
# 2.4 PRE-REMOVE CHECKS                                              #
#                                                                    #
#   2.4.1 Check for the presence of an existing CMD installation     #
#                                                                    #
#                                                                    #
#                                                                    #
# 3 ACTION                                                           #
# --------                                                           #
#                                                                    #
# 3.1 INSTALL PKGS                                                   #
# 3.2 REMOVE PKGS                                                    #
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

#
# 1.1.2 Define the core pkg (to be installed or removed)
#
declare -r core_pkg_common_name="maria"
declare -r core_pkg="${core_pkg_common_name}db"
declare -r core_pkg_server="${core_pkg}-server"

#
# 1.1.3 Derive the full path (of the current script)
#
declare -r script_name="install-${core_pkg_common_name}.sh"
declare -r script_path="${scripts_dir}/${script_name}"

#
# 1.1.4 Define the required dependencies (of the current script)
#
declare -a -r required_script_dependencies=(
  "apt"
  "apt-get"
	"debconf-set-selections"
	"debconf-get-selections"
  "grep"
  "service"
)

#
# 1.1.5 Define all pkgs to be installed
#
declare -a -r pkgs_to_install=(
  "${core_pkg_server}"
)

#
# 1.1.6 Define all pkgs to be removed
#
declare -a -r pkgs_to_remove=(
  "${core_pkg_server}"
	"${core_pkg}-plugin*"
	"${core_pkg}*"
	"mysql*"
)

#
# 1.1.7 Define all pkgs to be purged
#
declare -a -r pkgs_to_purge=(
  "${core_pkg_server}"
	"${core_pkg}-plugin*"
	"${core_pkg}*"
	"mysql*"
)

#
# 1.1.8 Define service statuses (for the core pkg)
#
declare -r service_status_active="Active: active"
declare -r service_status_inactive="Active: inactive"

#
# 1.1.9 Define allowed values for the action_type arg
#
declare -r action_type_install="install"
declare -r action_type_remove="remove"

declare -a -r allowed_action_types=(
  "${action_type_install}"
  "${action_type_remove}"
)

#
# 1.1.10 Define MariaDB root password
#
declare -r mariadb_root_passwd="Ed1nb@rgh135*"


######################################################################
#                                                                    #
# 1.2 VARS                                                           #
#                                                                    #
######################################################################

#
# 1.2.1 Validity vars
#
declare is_action_type_valid=false

#
# 1.2.2 Working vars
#
declare allowed_action_type=""
declare pkg_to_install""
declare required_script_dependency=""


######################################################################
#                                                                    #
# 1.3 ARGS                                                           #
#                                                                    #
######################################################################

#
# 1.3.1 Populate action_type with the received value (arg 1)
#
declare -r action_type="$1"


#
# 1.3.2 Ensure that action_type contains one of the allowed types
#
for allowed_action_type in "${allowed_action_types[@]}"
do
  if [ "${action_type}" = "${allowed_action_type}" ]; then
    is_action_type_valid=true
  fi
done

if [ "${is_action_type_valid}" = false ]; then
  echo "action_type: invalid" >&2
  exit 1
fi


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
#                                                                    #
# 2.2 COMMON SERVICE CHECKS                                          #
#                                                                    #
######################################################################

#
# 2.2.1 Check for an existing active service
#
if [ "$(service "${core_pkg}" status \
    | grep -c "${service_status_active}")" -gt 0 ]; then

  echo "${core_pkg}: installed and active" >&2
  exit 1
fi


######################################################################
#                                                                    #
# 2.3 PRE-INSTALLATION CHECKS                                        #
#                                                                    #
######################################################################


if [ "${action_type}" = "${action_type_install}" ]; then

  #
  # 2.3.1 Check for an existing inactive service
  #
  if [ "$(service "${core_pkg}" status \
      | grep -c "${service_status_inactive}")" -gt 0 ]; then

    echo "${core_pkg}: installed, but inctive" >&2
    exit 1
  fi

	#
  # 2.3.2 Check for the absence of an existing CMD installation
  #
  if command -v "${core_pkg}" > /dev/null 2>&1; then
    echo "${core_pkg}: existiing installation" >&2
    exit 1
  fi
fi


######################################################################
#                                                                    #
# 2.4 PRE-REMOVAL CHECKS                                             #
#                                                                    #
######################################################################


if [ "${action_type}" = "${action_type_remove}" ]; then

  #
  # 2.4.1 Check for the presence of an existing CMD installation
  #
  if ! command -v "${core_pkg}" > /dev/null 2>&1; then
    echo "${core_pkg}: not found" >&2
    exit 1
  fi
fi


######################################################################
######################################################################
#                                                                    #
# 3 ACTION                                                           #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 3.1 INSTALL PKGS                                                   #
#                                                                    #
######################################################################

if [ "${action_type}" = "${action_type_install}" ]; then

	echo PURGE |debconf-communicate mariadb-server
	echo PURGE |debconf-communicate mysql-server

  debconf-set-selections <<< "mariadb-server mysql-server/root_password password $mariadb_root_passwd"
  debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $mariadb_root_passwd" 

	debconf-get-selections | grep mariadb

	for pkg_to_install in "${pkgs_to_install[@]}"
  do
	  apt install "${pkg_to_install}" -y
	done
fi


######################################################################
#                                                                    #
# 3.2 REMOVE PKGS                                                    #
#                                                                    #
######################################################################

if [ "${action_type}" = "${action_type_remove}" ]; then
	
	for pkg in "${pkgs_to_remove[@]}"
  do
	  apt remove "${pkg}" -y
	done

	for pkg in "${pkgs_to_purge[@]}"
  do
	  apt-get purge "${pkg}" -y
	done

  sudo rm -rf /etc/mysql /var/lib/mysql

	apt-get autoremove -y
	apt autoclean -y
fi
