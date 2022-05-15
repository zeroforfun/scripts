openssl req -x509 -newkey rsa -nodes -keyout /dev/shm/server.key -out /dev/shm/server.crt -subj "/CN=server" 2>/dev/null
openssl req -x509 -newkey rsa -nodes -keyout /dev/shm/client.key -out /dev/shm/client.crt -subj "/CN=client" 2>/dev/null

openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout /dev/shm/server.key -out /dev/shm/server.crt -subj "/CN=server" 2>/dev/null
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout /dev/shm/client.key -out /dev/shm/client.crt -subj "/CN=client" 2>/dev/null

openssl req -x509 -utf8 -newkey rsa:4096 -days 365 -addext extendedKeyUsage=serverAuth -nodes -keyout /dev/shm/server.key -out /dev/shm/server.crt -subj "/CN=server" 2>/dev/null
openssl req -x509 -utf8 -newkey rsa:4096 -days 365 -addext extendedKeyUsage=clientAuth -nodes -keyout /dev/shm/client.key -out /dev/shm/client.crt -subj "/CN=client" 2>/dev/null

openssl rsa -text -in ./pki/private/cakey.pem
openssl req -text -in ./pki/reqs/cacsr.pem
openssl x509 -text -in ./pki/certs/cacert.pem
openssl crl -text -crlnumber -in ./pki/crl.pem
