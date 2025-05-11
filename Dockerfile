FROM mariadb:lts-noble

ARG EXIM_DB_AUTHOR
ARG EXIM_DB_SQL_FILE
ARG EXIM_DB_SQL_PATH

LABEL authors=${EXIM_DB_AUTHOR}
COPY ${EXIM_DB_SQL_PATH}/${EXIM_DB_SQL_FILE} /docker-entrypoint-initdb.d

CMD ["mariadbd"]
