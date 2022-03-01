
# Obtain the certificate(s) needed to operate the servers.
docker run --rm \
	-v "$PWD/letsencrypt:/etc/letsencrypt" \
	-v "$PWD/logs:/var/log/letsencrypt" \
	-v "$PWD/credentials.txt:/credentials.txt:ro" \
	certbot/dns-cloudflare:v1.7.0 certonly \
	--dns-cloudflare \
	--dns-cloudflare-credentials /credentials.txt \
	--email "$EMAIL" \
	--agree-tos \
	--noninteractive \
	--verbose \
	-d ws.commishes.com

# Tar the resulting folder
tar -cvhf certificates.tar letsencrypt/

# Generate an encryption key for symmetric encryption
openssl rand -base64 32 > /tmp/symmetric.bin
openssl rsautl -encrypt -pubin -inkey public.pem -in /tmp/symmetric.bin -out key.bin.enc

# Use the symmetric key to generate an encrypted tar file
file_name=certificates.tar
openssl aes-256-cbc -a -pbkdf2 -salt -in  $file_name -out $file_name.enc -kfile /tmp/symmetric.bin

# Delete the temporary files
rm /tmp/symmetric.bin
rm letsencrypt/* -r
rm logs/* -r
rm certificates.tar
