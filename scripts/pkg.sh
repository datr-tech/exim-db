#!/usr/bin/env bash

set -o pipefail -o errtrace -o errexit -o nounset

######################################################################
#                                                                    #
# NAME  pkg.sh                                                       #
# DESC  Perform an action on the pkg identified by arg 1             #
# DATE  20th January 2025                                            #
#                                                                    #
# AUTHOR J.A.Strachan                                                #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# USAGE                                                              #
#                                                                    #
# ./pkg.sh [pkg_name_common] [action_type] [show_type]               #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# ARGS                                                               #
#                                                                    #
# Arg 1                                                              #
#   - name: pkg_name_common                                          #
#   - type: string [required]                                        #
#   - possible values: bind, dovecot, exim, ldap and maria           #
#                                                                    #
# Arg 2                                                              #
#   - name: action_type                                              #
#   - type: string [required]                                        #
#   - possible values: show, start and stop                          #
#                                                                    #
# Arg 3                                                              #
#   - name: show_type                                                #
#   - type: string [optional, but required when action_type is show] #
#   - possible values: pid and status                                #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# EXAMPLE pkg_name = bind                                            #
#                                                                    #
# ./pkg.sh bind start                                                #
# ./pkg.sh bind stop                                                 #
# ./pkg.sh bind show pid                                             #
# ./pkg.sh bind show status                                          #
#                                                                    #
# EXAMPLE pkg_name = ldap                                            #
#                                                                    #
# ./pkg.sh ldap start                                                #
# ./pkg.sh ldap stop                                                 #
# ./pkg.sh ldap show pid                                             #
# ./pkg.sh ldap show status                                          #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# CODE SECTIONS                                                      #
#                                                                    #
# 1     CONSTANTS                                                    #
#                                                                    #
# 1.1   Define root_dir                                              #
# 1.2   Define allowed values for required arg 1: pkg_name_common    #
# 1.3   Define allowed values for required arg 2: action_type        #
# 1.4   Define allowed values for optional arg 3: show_type          #
# 1.5   Define the complete names of the allowed pkgs                #
# 1.6   Define a default value for the optional show_type arg        #
# 1.7   Deifne required script dependencies                          #
# 1.8   Define pkg service statuses                                  #
# 1.9   Define arg labels                                            #
# 1.10  Define error labels                                          #
# 1.11  Define pkg Labels                                            #
# 1.12  Define script path                                           #
#                                                                    #
# 2     ARGS                                                         #
#                                                                    #
# 2.1   Required args                                                #
# 2.2   Optional args                                                #
#                                                                    #
# 3     VARS                                                         #
#                                                                    #
# 3.1   Validity flags                                               #
# 3.2   Working vars                                                 #
#                                                                    #
# 4     PRE-ACTION CHECKS                                            #
#                                                                    #
# 4.1   Check script permissions                                     #
# 4.2   Check if pkg_name_common is valid                            #
# 4.3   Check action_type is valid                                   #
# 4.4   Check show_type is valid                                     #
# 4.5   Check if pkg_name is valid                                   #
# 4.6   Check required script dependencies                           #
# 4.7   Check pkg has been installed                                 #
#                                                                    #
# 5     PERFORM ACTION                                               #
#                                                                    #
# 5.1   Action: start pkg                                            #
# 5.2   Action: stop pkg                                             #
# 5.3   Action: show pkg PID                                         #
# 5.4   Action: show pkg service status summary                      #
#                                                                    #
######################################################################

######################################################################
#                                                                    #
# PKG NAMES AND ASSOCIATIVE ARRAYS                                   #
#                                                                    #
# A user should pass one of the allowed common names, as the value   #
# of the first arg, in order to begin to successfully call this      #
# script. The script's actions, however, only make use of the assoc- #
# -iated complete pkg name.                                          #
#                                                                    #
# The relationship between pairs of common and complete names is     #
# defined via the COMPLETE_PKG_NAMES associative array, whose        #
# complete name values are keyed by allowed common names.            #
#                                                                    #
# It is hoped this appraoch will simplify usage. A user need not     #
# know potentially intricate pkg names. Instead, they only need to   #
# use common names.                                                  #
#                                                                    #
# Less positively, if pkgs are added or removed from the script,     #
# BOTH the COMMON_PKG_NAMES and the COMPLETE_PKG_NAMES arrays will   #
# require updating.                                                  #
#                                                                    #
######################################################################


######################################################################
######################################################################
#                                                                    #
# 1     CONSTANTS                                                    #
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
# 1.2   Define allowed values for required arg 1: pkg_name_common    #
#                                                                    #
#       The ALLOWED_COMMON_PKG_NAMES array (directly below) defines  #
#       the common name of each pkgs which this script can act upon. #
#                                                                    #
######################################################################

declare -r PKG_NAME_BIND_COMMON="bind"
declare -r PKG_NAME_DOVE_COMMON="dove"
declare -r PKG_NAME_EXIM_COMMON="exim"
declare -r PKG_NAME_LDAP_COMMON="ldap"
declare -r PKG_NAME_MARIA_COMMON="maria"

declare -r -a ALLOWED_COMMON_PKG_NAMES=(
  "${PKG_NAME_BIND_COMMON}"
  "${PKG_NAME_DOVE_COMMON}"
  "${PKG_NAME_EXIM_COMMON}"
  "${PKG_NAME_LDAP_COMMON}"
  "${PKG_NAME_MARIA_COMMON}"
)


######################################################################
#                                                                    #
# 1.3   Define allowed values for required arg 2: action_type        #
#                                                                    #
######################################################################

declare -r ACTION_TYPE_SHOW="show"
declare -r ACTION_TYPE_START="start"
declare -r ACTION_TYPE_STOP="stop"

declare -a -r ALLOWED_ACTION_TYPES=(
  "${ACTION_TYPE_SHOW}"
  "${ACTION_TYPE_START}"
  "${ACTION_TYPE_STOP}"
)


######################################################################
#                                                                    #
# 1.4   Define allowed values for optional arg 3: show_type          #
#                                                                    #
######################################################################

declare -r SHOW_TYPE_PID="pid"
declare -r SHOW_TYPE_STATUS="status"

declare -a -r ALLOWED_SHOW_TYPES=(
  "${SHOW_TYPE_PID}"
  "${SHOW_TYPE_STATUS}"
)


######################################################################
#                                                                    #
# 1.5   Define the complete names of the allowed pkgs                #
#                                                                    #
#       Each entry in the COMMON_PKG_NAMES associative array is      #
#       keyed by one of the common pkg names (defined in 1.2),       #
#       linking each common name with an associated complete name.   #
#                                                                    #
######################################################################

declare -r PKG_NAME_BIND="named"
declare -r PKG_NAME_DOVE="dovecot"
declare -r PKG_NAME_EXIM="exim4"
declare -r PKG_NAME_LDAP="slapd"
declare -r PKG_NAME_MARIA="mariadb"

declare -Ar COMPLETE_PKG_NAMES=(
  ["${PKG_NAME_BIND_COMMON}"]="${PKG_NAME_BIND}"
  ["${PKG_NAME_DOVE_COMMON}"]="${PKG_NAME_DOVE}"
  ["${PKG_NAME_EXIM_COMMON}"]="${PKG_NAME_EXIM}"
  ["${PKG_NAME_LDAP_COMMON}"]="${PKG_NAME_LDAP}"
  ["${PKG_NAME_MARIA_COMMON}"]="${PKG_NAME_MARIA}"
)


######################################################################
#                                                                    #
# 1.6   Define a default value for the optional 'show_type' arg      #
#                                                                    #
######################################################################

declare -r SHOW_TYPE_ARG_DEFAULT="SHOW_TYPE_ARG_DEFAULT"


######################################################################
#                                                                    #
# 1.7   Deifne required script dependencies                          #
#                                                                    #
######################################################################

declare -r REQUIRED_SCRIPT_DEPENDENCY_GREP="grep"
declare -r REQUIRED_SCRIPT_DEPENDENCY_INVOKE="invoke-rc.d"
declare -r REQUIRED_SCRIPT_DEPENDENCY_NETSTAT="netstat"
declare -r REQUIRED_SCRIPT_DEPENDENCY_SERVICE="service"
declare -r REQUIRED_SCRIPT_DEPENDENCY_SYSTEMCTL="systemctl"

declare -a -r REQUIRED_SCRIPT_DEPENDENCIES=(
  "${REQUIRED_SCRIPT_DEPENDENCY_GREP}"
  "${REQUIRED_SCRIPT_DEPENDENCY_INVOKE}"
  "${REQUIRED_SCRIPT_DEPENDENCY_NETSTAT}"
  "${REQUIRED_SCRIPT_DEPENDENCY_SERVICE}"
  "${REQUIRED_SCRIPT_DEPENDENCY_SYSTEMCTL}"
)


######################################################################
#                                                                    #
# 1.8   Define pkg service statuses                                  #
#                                                                    #
######################################################################

declare -r PKG_SERVICE_STATUS_ACTIVE="Active: active"
declare -r PKG_SERVICE_STATUS_INACTIVE="Active: inactive"


######################################################################
#                                                                    #
# 1.9   Define arg labels                                            #
#                                                                    #
######################################################################

declare -r LABEL_ARG_1="arg 1"
declare -r LABEL_ARG_2="arg 2"
declare -r LABEL_ARG_3="arg 3"

declare -r LABEL_ARG_ACTION_TYPE="action_type"
declare -r LABEL_ARG_PKG_NAME_COMMON="pkg_name_common"
declare -r LABEL_ARG_SHOW_TYPE="show_type"


######################################################################
#                                                                    #
# 1.10  Define error labels                                          #
#                                                                    #
######################################################################

declare -r LABEL_ERR_EMPTY="empty"
declare -r LABEL_ERR_INSTALLED_ACTIVE="installed and active"
declare -r LABEL_ERR_INSTALLED_INACTIVE="installed, but inactive"
declare -r LABEL_ERR_INVALID="invalid"
declare -r LABEL_ERR_NOT_FOUND="not found"


######################################################################
#                                                                    #
# 1.11  Define pkg Labels                                            #
#                                                                    #
######################################################################

declare -r LABEL_PKG_NAME="pkg_name"


######################################################################
#                                                                    #
# 1.11  Define script path                                           #
#                                                                    #
######################################################################

declare -r PKG_SCRIPT_NAME="pkg.sh"
declare -r PKG_SCRIPT_PATH="${root_dir}./scripts/${PKG_SCRIPT_NAME}"


######################################################################
######################################################################
#                                                                    #
# 2     ARGS                                                         #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 2.1   Required args                                                #
#                                                                    #
######################################################################

declare -r pkg_name_common="${1}"
declare -r action_type="${2}"


######################################################################
#                                                                    #
# 2.2   Optional args                                                #
#                                                                    #
######################################################################

declare -r show_type="${3:-"${SHOW_TYPE_ARG_DEFAULT}"}"


######################################################################
######################################################################
#                                                                    #
# 3     VARS                                                         #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 3.1   Validity vars                                                #
#                                                                    #
######################################################################

declare action_type_is_valid=false
declare pkg_name_common_is_valid=false
declare show_type_is_valid=false


######################################################################
#                                                                    #
# 3.2   Working vars                                                 #
#                                                                    #
######################################################################

declare allowed_action_type=""
declare allowed_common_pkg_name=""
declare allowed_show_type=""
declare pkg_name=""
declare required_script_dependency=""


######################################################################
######################################################################
#                                                                    #
# 4     PRE ACTION CHECKS                                            #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 4.1   Check script permissions                                     #
#                                                                    #
######################################################################

if [[ "${EUID}" -ne 0 ]]; then
  echo "use: sudo ${PKG_SCRIPT_PATH}" >&2
  exit 1
fi


######################################################################
#                                                                    #
# 4.2   Check if pkg_name_common is valid                            #
#                                                                    #
######################################################################

for allowed_common_pkg_name in "${ALLOWED_COMMON_PKG_NAMES[@]}"
do
  if [ "${pkg_name_common}" = "${allowed_common_pkg_name}" ]; then
    pkg_name_common_is_valid=true
  fi
done

if [ "${pkg_name_common_is_valid}" = false ]; then
  echo "${LABEL_ARG_1}: ${LABEL_ARG_PKG_NAME_COMMON}: ${LABEL_ERR_INVALID}" >&2
  exit 1
fi


######################################################################
#                                                                    #
# 4.3   Check if pkg_name is valid                                   #
#                                                                    #
######################################################################

pkg_name="${COMPLETE_PKG_NAMES["$pkg_name_common"]}"

if [ -z "${pkg_name}" ]; then
  echo "${LABEL_PKG_NAME}: ${LABEL_ERR_INVALID}" >&2
  exit 1
fi


######################################################################
#                                                                    #
# 4.4   Check if action_type is valid                                #
#                                                                    #
######################################################################

for allowed_action_type in "${ALLOWED_ACTION_TYPES[@]}"
do
  if [ "${action_type}" = "${allowed_action_type}" ]; then
    action_type_is_valid=true
  fi
done

if [ "${action_type_is_valid}" = false ]; then
  echo "${LABEL_ARG_2}: ${LABEL_ARG_ACTION_TYPE}: ${LABEL_ERR_INVALID}" >&2
  exit 1
fi


######################################################################
#                                                                    #
# 4.5   Check if show_type is valid                                  #
#                                                                    #
######################################################################

if [ "${action_type}" = "${ACTION_TYPE_SHOW}" ]; then

  if [ "${show_type}" = "${SHOW_TYPE_ARG_DEFAULT}" ]; then
    echo "${LABEL_ARG_3}: ${LABEL_ARG_SHOW_TYPE}: ${LABEL_ERR_EMPTY}" >&2
    exit 1
  fi

  for allowed_show_type in "${ALLOWED_SHOW_TYPES[@]}"
  do
    if [ "${show_type}" = "${allowed_show_type}" ]; then
      show_type_is_valid=true
    fi
  done

  if [ "${show_type_is_valid}" = false ]; then
    echo "${LABEL_ARG_3}: ${LABEL_ARG_SHOW_TYPE}: ${LABEL_ERR_INVALID}" >&2
    exit 1
  fi
fi


######################################################################
#                                                                    #
# 4.6   Check required script dependencies                           #
#                                                                    #
######################################################################

for required_script_dependency in "${REQUIRED_SCRIPT_DEPENDENCIES[@]}"
do
  if ! command -v "${required_script_dependency}" > /dev/null 2>&1; then
    echo "${required_script_dependency}: ${LABEL_ERR_NOT_FOUND}" >&2
    exit 1
  fi
done


######################################################################
#                                                                    #
# 4.7   Check pkg has been installed                                 #
#                                                                    #
######################################################################

if ! command -v "${pkg_name}" > /dev/null 2>&1; then
  echo "${pkg_name}: ${LABEL_ERR_NOT_FOUND}" >&2
  exit 1
fi


######################################################################
######################################################################
#                                                                    #
# 5     PERFORM ACTION                                               #
#                                                                    #
######################################################################
######################################################################


######################################################################
#                                                                    #
# 5.1   Action: start pkg                                            #
#                                                                    #
######################################################################

if [ "${action_type}" = "${ACTION_TYPE_START}" ]; then

  if [ "$(service "${pkg_name}" status | grep -c "${PKG_SERVICE_STATUS_ACTIVE}")" -gt 0 ]; then
    echo "${pkg_name_common}: ${LABEL_ERR_INSTALLED_ACTIVE}" >&2
    exit 1
  fi

	if [ "${pkg_name_common}" != "${PKG_NAME_LDAP_COMMON}" ]; then
    systemctl enable "${pkg_name}"
	fi

  systemctl start "${pkg_name}"
fi


######################################################################
#                                                                    #
# 5.2   Action: stop pkg                                             #
#                                                                    #
######################################################################

if [ "${action_type}" = "${ACTION_TYPE_STOP}" ]; then

  if [ "$(service "${pkg_name}" status | grep -c "${PKG_SERVICE_STATUS_INACTIVE}")" -gt 0 ]; then
    echo "${pkg_name_common}: ${LABEL_ERR_INSTALLED_INACTIVE}" >&2
    exit 1
  fi

	if [ "${pkg_name_common}" != "${PKG_NAME_LDAP_COMMON}" ]; then
    systemctl disable "${pkg_name}"
	fi
  
	systemctl stop "${pkg_name}"
fi


######################################################################
#                                                                    #
# 5.3   Action: show pkg PID                                         #
#                                                                    #
######################################################################

if [ "${action_type}" = "${ACTION_TYPE_SHOW}" ] && [ "${show_type}" = "${SHOW_TYPE_PID}" ]; then

  if [ "$(service "${pkg_name}" status | grep -c "${PKG_SERVICE_STATUS_ACTIVE}")" -eq 0 ]; then
    echo "${pkg_name}: inactive" >&2 
    exit 1
  fi

  netstat -plnt | grep "${pkg_name}"
fi


######################################################################
#                                                                    #
# 5.3   Action: show pkg service status summary                      #
#                                                                    #
######################################################################

if [ "${action_type}" = "${ACTION_TYPE_SHOW}" ] && [ "${show_type}" = "${SHOW_TYPE_STATUS}" ]; then
  systemctl status "${pkg_name}"
fi
