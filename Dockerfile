FROM mariadb:lts-noble

ARG EXIM_DB_AUTHOR
ARG EXIM_DB_SQL_PATH

LABEL authors="${EXIM_DB_AUTHOR}"
COPY ${EXIM_DB_SQL_PATH}/*.sql /docker-entrypoint-initdb.d

CMD ["mariadbd"]
