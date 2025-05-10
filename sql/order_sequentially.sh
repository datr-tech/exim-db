#!/usr/bin/env bash

set -euo pipefail

declare -i count=1000
declare    sql_description
declare    sql_path
declare    sql_path_reordered

for sql_path in "$(pwd)"/*.sql
do
	sql_description=$(echo "${sql_path}" | cut -d "_" -f 3-)
  sql_path_reordered="${count}_${sql_description}"
	mv "${sql_path}" "${sql_path_reordered}"

	count=$((count+1))
done

