FROM mariadb:${EXIM_DB_MARIADB_VERSION}

LABEL maintainer=${EXIM_DB_MAINTAINER}

COPY ${EXIM_DB_SQL_PATH} docker-entrypoint-initdb.d

CMD ["mariadbd"]
