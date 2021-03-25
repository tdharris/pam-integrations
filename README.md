# Dockerized PAM Integrations

## How to use this
### Docker Images
- [OpenLDAP](https://hub.docker.com/r/osixia/openldap)
- [MySQL](https://hub.docker.com/_/mysql)
- [MariaDB](https://hub.docker.com/_/mariadb)
- [Postgres](https://hub.docker.com/_/postgres)
- [MSSQL](https://hub.docker.com/_/microsoft-mssql-server)
- [Oracle](https://github.com/oracle/docker-images/blob/master/OracleDatabase/SingleInstance/README.md) (build image locally)

### Pre-requisites
- docker
- docker-compose
- `.env` file (see `.env.example`)
- Manually created certificates: see [pre-requisite certificate steps](#pre-requisite-certificate-steps).

### Start & Initialize
```
docker-compose up [-d]
docker-compose up [-d] <containerName>
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
Any executable `*.sql`, `*.sql.gz`, `*.sh` scripts contained in appropriate `./init/{dbtype}/` folders will be ran to do further initialization before starting the respective service. This should be the case for most of the containers, exceptions listed below in Manual init section.

### Default init
3 users are created and given all privileges to the appropriate initialized db (i.e. `example`): `dbuser{1-3}`. According to the default `Environment Variables`, the default admin user created is `dbadmin`.

### Manual init
Initialization of data should happen automatically with the db containers when created for the first time, except for the following containers which will need to be performed manually due to limitations of the provider's images.
#### Oracle
```
docker exec -it oracle /bin/sh
/opt/oracle/runUserScripts.sh /opt/oracle/scripts/setup/
```

## SSL / TLS
### Pre-requisite certificate steps
I have mapped over a locally generated certificate for consistency between containers.
- Containers that use the manually created certificate: `MySQL, MariaDB, Postgres`.
- Containers that automatically generate their own self-signed certificate: `MSSQL`
- Currently unknown SSL default state: `Oracle`
#### To generate the self-signed certificate with a provided utility script:
```
./init/certs/generate-certs.sh
```
Note: Automatically creates certificates within default data directory: `.data/certs/` - this directory is mounted by dependent containers. If the `DATA_DIRECTORY` from `.env` is changed from the default `./.data/`, then please move the generated certs to the relevant `<data-path>/certs/`.

Creates the following certificate files in `.data/certs/`:
```
root-ca-key.pem
root-ca.pem
server-cert.pem
server-key.pem
server-req.pem
client-cert.pem
client-key.pem
client-req.pem
```

### Databases
#### MySQL
Dependent on the manually created certificate (see [pre-requisite certificate steps](#pre-requisite-certificate-steps)).

Otherwise, self-signed certificates would be automatically created during initialization by `mysql_ssl_rsa_setup`. For more information, see vendor's documentation - [Section 4.4.5, “mysql_ssl_rsa_setup — Create SSL/RSA Files”](https://dev.mysql.com/doc/refman/5.7/en/mysql-ssl-rsa-setup.html).

- Validate:
```
docker exec -it mysql /bin/sh
mysql -uroot -p -h 127.0.0.1
mysql> SHOW VARIABLES LIKE '%ssl%';
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| have_openssl  | YES             |
| have_ssl      | YES             |
| ssl_ca        | ca.pem          |
| ssl_capath    |                 |
| ssl_cert      | server-cert.pem |
| ssl_cipher    |                 |
| ssl_crl       |                 |
| ssl_crlpath   |                 |
| ssl_key       | server-key.pem  |
+---------------+-----------------+
9 rows in set (0.00 sec)
mysql> \s
--------------
...
SSL:                    Cipher in use is DHE-RSA-AES256-SHA
...
--------------
```

- To manually create certificates with vendor's helper script:
```
docker exec -it mysql /bin/bash
mysql_ssl_rsa_setup --uid=mysql
exit
docker restart mysql
```

### MariaDB
Dependent on the manually created certificate (see [pre-requisite certificate steps](#pre-requisite-certificate-steps)).

For more information, see [Securing Connections for Client and Server](https://mariadb.com/kb/en/securing-connections-for-client-and-server/).

Validate:
```
docker exec -it mariadb /bin/sh
mysql -uroot -p -h 127.0.0.1 --ssl
MariaDB [(none)]> SHOW VARIABLES LIKE '%ssl%';
+---------------------+----------------------------+
| Variable_name       | Value                      |
+---------------------+----------------------------+
| have_openssl        | YES                        |
| have_ssl            | YES                        |
| ssl_ca              | /etc/certs/root-ca.pem     |
| ssl_capath          |                            |
| ssl_cert            | /etc/certs/server-cert.pem |
| ssl_cipher          |                            |
| ssl_crl             |                            |
| ssl_crlpath         |                            |
| ssl_key             | /etc/certs/server-key.pem  |
| version_ssl_library | OpenSSL 1.1.1  11 Sep 2018 |
+---------------------+----------------------------+
10 rows in set (0.00 sec)
MariaDB [(none)]> \s
--------------
...
SSL:                    Cipher in use is TLS_AES_256_GCM_SHA384
...
--------------
```

### Postgres
Dependent on the manually created certificate (see [pre-requisite certificate steps](#pre-requisite-certificate-steps)).

Validate: See https://jdbc.postgresql.org/documentation/head/ssl-client.html.

### MSSQL
Self-signed cert is created automatically by the container.

Validate (see `encrypt_option` column with value as `TRUE`):
```
docker exec -it mssql /bin/sh
/opt/mssql-tools/bin/sqlcmd -S localhost,1234 -U dbadmin -P "Novell123" -d example -Q "select encrypt_option from sys.dm_exec_connections where session_id = @@spid;" -N -C
encrypt_option
----------------------------------------
TRUE
```

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
ORACLE_CONTAINER_NAME=oracle
ORACLE_VERSION=12.2.0.1-se2
ORACLE_DB_PORT=1521
ORACLE_WEB_PORT=5500
ORACLE_SID=ORCLCDB
ORACLE_PDB=ORCLPDB1
ORACLE_PWD=mypassword
ORACLE_EDITION=standard
ORACLE_CHARACTERSET=AL32UTF8
ORACLE_DATABASE=example
ORACLE_USER=dbadmin
ORACLE_PASSWORD=mypassword

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

# Microsoft SQL Server
MSSQL_CONTAINER_NAME=mssql
MSSQL_VERSION=2017-latest
MSSQL_TCP_PORT=1234
MSSQL_SA_PASSWORD=mypassword
MSSQL_PID=Express
```
