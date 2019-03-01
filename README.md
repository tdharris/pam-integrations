# Dockerized PAM Integrations

## How to use this
### Pre-requisites
- docker
- docker-compose
- `.env` file

### Start & Initialize
```
docker-compose up [-d]
```

### Manage docker containers
```
docker ps <container>
docker start <container>
docker stop <container>
docker logs -f --tail 10 <container>
docker exec -it <container> /bin/bash
```

### Storage
Mapped to local volumes respective to each container. If applicable:
- Data: `./data/{dbcontainer}/data`
- Configuration: `./data/{dbcontainer}/config`

## Initialization scripts
Any executable `*.sql`, `*.sql.gz`, `*.sh` scripts contained in appropriate `./init/{dbtype}/` folders will be ran to do further initialization before starting the respective service.

### Default init
3 users are created and given all privileges to the appropriate initialized db (i.e. `example`): `dbuser{1-3}`. According to the default `Environment Variables`, the default admin user created is `dbadmin`.

## Environment Variables
Example environment variables can be seen below. A `.env` file should be created in the root directory setting the appropriate variables needed to initialize these containers.
```
# Run containers as user
RUN_UID=0
RUN_GID=0

# OpenLDAP
LDAP_CONTAINER_NAME=openldap
LDAP_OPENLDAP_VERSION=latest
LDAP_PORT_UNSECURE=389
LDAP_PORT_SECURE=636
LDAP_ORGANISATION=Example Inc.
LDAP_DOMAIN=example.org
LDAP_ADMIN_PASSWORD=mypassword
LDAP_CONFIG_PASSWORD=mypassword
LDAP_READONLY_USER=True
LDAP_READONLY_USER_USERNAME=readonly
LDAP_READONLY_USER_PASSWORD=mypassword
LDAP_OPENLDAP_UID=0
LDAP_OPENLDAP_GID=0

# Oracle

# MySQL
MYSQL_CONTAINER_NAME=mysql
MYSQL_VERSION=5.7.25
MYSQL_PROTOCOL_MYSQL_PORT=3306
MYSQL_PROTOCOL_MYSQLX_PORT=33060
MYSQL_ROOT_PASSWORD=mypassword
MYSQL_DATABASE=example
MYSQL_USER=dbadmin
MYSQL_PASSWORD=mypassword

# MariaDB
MARIADB_CONTAINER_NAME=mariadb
MARIADB_VERSION=10.2
MARIADB_PROTOCOL_MYSQL_PORT=3307
MARIADB_PROTOCOL_MYSQLX_PORT=33061
MARIADB_ROOT_PASSWORD=mypassword
MARIADB_DATABASE=example
MARIADB_USER=dbadmin
MARIADB_PASSWORD=mypassword

# Postgres
POSTGRES_CONTAINER_NAME=postgres
POSTGRES_VERSION=9.6
POSTGRES_PORT=5432
POSTGRES_DB=example
POSTGRES_USER=dbadmin
POSTGRES_PASSWORD=mypassword
```
