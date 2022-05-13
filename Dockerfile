
FROM nginx

# Import the encrypted certificates and the encrypted key used
# to decrypt them.
COPY $PWD/certificates.tar.enc /usr/share/nginx/certs.tar.enc
COPY $PWD/key.bin.enc /usr/share/nginx

# Import our nginx config into the ngingx config directory.
COPY $PWD/nginx/ /etc/nginx/conf.d/
COPY decrypt.sh /docker-entrypoint.d/

# Add the script that reads the secret from the swarm and uses it
# to decrypt the certificates
RUN chmod 0700 /docker-entrypoint.d/decrypt.sh

RUN sed -i 's/worker\_connections[[:space:]]*[0-9]*/worker_connections 65536/g' /etc/nginx/nginx.conf
RUN cat /etc/nginx/nginx.conf

# This can be used to test the configuration of nginx,
# please note that since the certificates are not available
# in plain in the container during building, it will always
# fail
# RUN nginx -t