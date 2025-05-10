#!/usr/bin/env bash

set -euo pipefail

declare    sql_path

for sql_path in "$(pwd)"/*.sql
do

 sql_path=$(echo "${sql_path}" | rev | cut -d "/" -f 1 | rev) 
declare comment_block=$(
cat << HEREDOC
/*
 * script     $sql_path
 *
 * date       15th February 2025
 * author     J.A.Strachan
 */
HEREDOC
)

touch ./tmp
echo "${comment_block}" > ./tmp
cat "${sql_path}" >> ./tmp

mv ./tmp "${sql_path}"
done

