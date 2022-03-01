
cat /run/secrets/privkey
ls -la /usr/share/nginx/

file_name=/usr/share/nginx/certs.tar

openssl rsautl -decrypt -inkey /run/secrets/privkey -in /usr/share/nginx/key.bin.enc -out /usr/share/nginx/key.bin
openssl aes-256-cbc -d -a -pbkdf2 -in $file_name.enc -out $file_name -kfile /usr/share/nginx/key.bin

#mkdir /usr/share/nginx/certs/
echo 'tar'
tar -xf /usr/share/nginx/certs.tar -C /usr/share/nginx/

mv /usr/share/nginx/letsencrypt/ /usr/share/nginx/certs/
ls -la /usr/share/nginx/
ls -la /usr/share/nginx/certs/