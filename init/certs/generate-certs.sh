DATA_DIRECTORY="$PWD/.data"
mkdir -pv "$DATA_DIRECTORY/certs"

OPENSSL_SUBJ="/C=US/ST=Utah/L=Provo"
OPENSSL_ROOT_CA="${OPENSSL_SUBJ}/CN=pam-integrations-CA"
OPENSSL_SERVER="${OPENSSL_SUBJ}/CN=pam-integrations-server"
OPENSSL_CLIENT="${OPENSSL_SUBJ}/CN=pam-integrations-client"

# 1) Root
# Generate new CA certificate root-ca.pem file.
docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl genrsa 2048 > "$DATA_DIRECTORY/certs/root-ca-key.pem"

docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl req -new -x509 -nodes -days 3600 \
        -subj "${OPENSSL_ROOT_CA}" \
        -key /certs/root-ca-key.pem -out /certs/root-ca.pem

# 2) Server
# Create the server-side certificates
docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl req -newkey rsa:2048 -days 3600 -nodes \
        -subj "${OPENSSL_SERVER}" \
        -keyout /certs/server-key.pem -out /certs/server-req.pem

docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl rsa -in /certs/server-key.pem -out /certs/server-key.pem

docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl x509 -req -in /certs/server-req.pem -days 3600 \
        -CA /certs/root-ca.pem -CAkey /certs/root-ca-key.pem \
        -set_serial 01 -out /certs/server-cert.pem

# Verify the certificates are correct
docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl verify -CAfile /certs/root-ca.pem /certs/server-cert.pem

# 3) Client (optional)
# Create the client-side certificates
docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl req -newkey rsa:2048 -days 3600 -nodes \
        -subj "${OPENSSL_CLIENT}" \
        -keyout /certs/client-key.pem -out /certs/client-req.pem

docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl rsa -in /certs/client-key.pem -out /certs/client-key.pem

docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl x509 -req -in /certs/client-req.pem -days 3600 \
        -CA /certs/root-ca.pem -CAkey /certs/root-ca-key.pem \
        -set_serial 01 -out /certs/client-cert.pem

# Verify the certificates are correct
docker run --rm -v ${DATA_DIRECTORY}/certs:/certs -it nginx \
    openssl verify -CAfile /certs/root-ca.pem /certs/client-cert.pem
