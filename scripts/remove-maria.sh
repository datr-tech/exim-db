#!/usr/bin/env bash

set -o pipefail -o errtrace -o errexit -o nounset

######################################################################
#                                                                    #
# NAME  remove-maria.sh                                              #
# DESC  Remove the local MariaDB installation.                       #
# DATE  23th January 2025                                            #
#                                                                    #
# AUTHOR J.A.Strachan                                                #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# USAGE                                                              #
#                                                                    #
# sudo ./remove-maria.sh                                             #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# CODE SECTIONS                                                      #
#                                                                    #
#                                                                    #
# 1 CONSTANTS                                                        #
#                                                                    #
# 1.1   Define root_dir                                              #
# 1.2   Define the name of the core pkg_to_remove                    #
# 1.3   Define the path of the current script                        #
# 1.4   Define service statuses for the pkg_to_remove                #
# 1.5   Define required dependencies (of the current script)         #
# 1.6   Define all pkgs_to_remove                                    #
#                                                                    #
#                                                                    #
# 2 VARS                                                             #
#                                                                    #
# 2.1   Working vars                                                 #
#                                                                    #
#                                                                    #
# 3 PRE REMOVAL CHECKS                                               #
#                                                                    #
# 3.1.  Check script permissions                                     #
# 3.2   Check required script dependencies                           #
# 3.3   Check for an existing installation                           #
# 3.4   Check for an active service status                           #
#                                                                    #
#                                                                    #
# 4.    REMOVE PKGS                                                  #
#                                                                    #
######################################################################


######################################################################
######################################################################
#                                                                    #
# 1.    CONSTANTS                                                    #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 1.1   Define root_dir                                              #
#                                                                    #
######################################################################

root_dir="$(dirname "${BASH_SOURCE[0]}")/.."
declare -r root_dir


######################################################################
#                                                                    #
# 1.2   Define the name of the core pkg_to_remove                    #
#                                                                    #
######################################################################

declare -r core_pkg_to_remove_common_name="maria"
declare -r core_pkg_to_remove="${core_pkg_to_remove_common_name}db"


######################################################################
#                                                                    #
# 1.3   Define the path of the current script                        #
#                                                                    #
######################################################################

declare -r script_name="install-${core_pkg_to_remove_common_name}.sh"
declare -r script_path="${root_dir}/scripts/${script_name}"


######################################################################
#                                                                    #
# 1.4   Define an erroneous service status for the pkg_to_remove     #
#                                                                    #
######################################################################

declare -r err_service_status_active="Active: active"


######################################################################
#                                                                    #
# 1.5   Define required dependencies (of the current script)         #
#                                                                    #
######################################################################

declare -a -r required_script_dependencies=(
  "apt"
	"dpkg"
	"grep"
	"service"
)


######################################################################
#                                                                    #
# 1.6   Define all pkgs_to_remove                                    #
#                                                                    #
######################################################################

declare -a -r pkgs_to_remove=(
  "${core_pkg_to_remove}"
  "${core_pkg_to_remove}-server"
)


######################################################################
######################################################################
#                                                                    #
# 2.    VARS                                                         #
#                                                                    #
######################################################################
######################################################################

######################################################################
#                                                                    #
# 2.1   Working vars                                                 #
#                                                                    #
######################################################################

declare pkg_to_remove=""
declare required_script_dependency=""


######################################################################
######################################################################
#                                                                    #
# 3.    PRE REMOVAL CHECKS                                           #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 3.1.  Check script permissions                                     #
#                                                                    #
######################################################################

if [[ "${EUID}" -ne 0 ]]; then
  echo "use: sudo ${script_path}" >&2
  exit 1
fi

######################################################################
#                                                                    #
# 3.2   Check required script dependencies                           #
#                                                                    #
######################################################################

for required_script_dependency in "${required_script_dependencies[@]}"
do
  if ! command -v "${required_script_dependency}" > /dev/null 2>&1; then
    echo "${required_script_dependency}: not found" >&2
    exit 1
  fi
done

######################################################################
#                                                                    #
# 3.3   Check for an existing installation                           #
#                                                                    #
######################################################################

if ! command -v "${core_pkg_to_remove}" > /dev/null 2>&1; then
	echo "${core_pkg_to_remove}: not found" >&2
	exit 1
fi


######################################################################
#                                                                    #
# 3.4   Check for an active service status                           #
#                                                                    #
######################################################################

if [ "$(service "${core_pkg_to_remove}" status | grep -c "${err_service_status_active}")" -gt 0 ]; then
  echo "${core_pkg_to_remove}: installed and active" >&2
  exit 1
fi


######################################################################
######################################################################
#                                                                    #
# 4.    REMOVE PKGS                                                  #
#                                                                    #
######################################################################
######################################################################

for pkg_to_remove in "${pkgs_to_remove[@]}"
do
  apt remove "${pkg_to_remove}" -y
done
