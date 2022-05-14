#!/usr/bin/bash
# bash cat ln mkdir openssl touch xxd
mkdir ./pki/{,certs/,crl/,newcerts/,private/,reqs/}
touch ./pki/{index.txt,index.txt.attr}
cat << EOF > ./pki/openssl.cnf
[ ca ]
default_ca=CA_default

[ CA_default ]
dir=./pki/
certs=./pki/certs/
crl_dir=./pki/crl/
database=./pki/index.txt
unique_subject=yes
new_certs_dir=./pki/newcerts/
certificate=./pki/cacert.pem
serial=./pki/serial
crlnumber=./pki/crlnumber
crl=./pki/crl.pem
private_key=./pki/private/cakey.pem
crl_extensions=crl_ext
default_days=365
default_crl_days=365
default_md=sha256
preserve=no
policy=policy_anything

[ policy_anything ]
countryName=optional
stateOrProvinceName=optional
localityName=optional
organizationName=optional
organizationalUnitName=optional
commonName=supplied
name=optional
emailAddress=optional

[ req ]
default_bits=4096
default_keyfile=privkey.pem
default_md=sha256
distinguished_name=req_distinguished_name
x509_extensions=v3_ca

[ req_distinguished_name ]
commonName=CN
commonName_max=64

[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
basicConstraints=critical,CA:true
keyUsage=cRLSign,keyCertSign

[ crl_ext ]
authorityKeyIdentifier=keyid:always,issuer:always

[ server ]
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
extendedKeyUsage=serverAuth

[ client ]
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
extendedKeyUsage=clientAuth
EOF
xxd -ps -u -l 20 /dev/urandom ./pki/serial
ln -s $(cat ./pki/serial).pem ./pki/private/cakey.pem
ln -s $(cat ./pki/serial).pem ./pki/reqs/cacsr.pem
ln -s $(cat ./pki/serial).pem ./pki/certs/cacert.pem
ln -s certs/cacert.pem ./pki/cacert.pem
openssl genrsa -out ./pki/private/cakey.pem 4096
openssl req -config ./pki/openssl.cnf -new -subj /CN=ca -key ./pki/private/cakey.pem -out ./pki/reqs/cacsr.pem
openssl ca -config ./pki/openssl.cnf -selfsign -extensions v3_ca -batch -notext -in ./pki/reqs/cacsr.pem -out ./pki/cacert.pem

xxd -ps -u -l 20 /dev/urandom ./pki/crlnumber
ln -f -s crl/$(cat ./pki/crlnumber).pem ./pki/crl.pem
openssl ca -config ./pki/openssl.cnf -gencrl -out ./pki/crl.pem
openssl verify -crl_check -CAfile ./pki/cacert.pem -CRLfile ./pki/crl.pem ./pki/cacert.pem

xxd -ps -u -l 20 /dev/urandom ./pki/serial
ln -s $(cat ./pki/serial).pem ./pki/private/serverkey.pem
ln -s $(cat ./pki/serial).pem ./pki/reqs/servercsr.pem
ln -s $(cat ./pki/serial).pem ./pki/certs/servercert.pem
openssl genrsa -out ./pki/private/serverkey.pem 4096
openssl req -config ./pki/openssl.cnf -new -subj /CN=server -key ./pki/private/serverkey.pem -out ./pki/reqs/servercsr.pem
openssl ca -config ./pki/openssl.cnf -extensions server -batch -notext -in ./pki/reqs/servercsr.pem -out ./pki/certs/servercert.pem
openssl verify -crl_check -CAfile ./pki/cacert.pem -CRLfile ./pki/crl.pem ./pki/certs/servercert.pem

xxd -ps -u -l 20 /dev/urandom ./pki/serial
ln -f -s $(cat ./pki/serial).pem ./pki/private/clientkey.pem
ln -f -s $(cat ./pki/serial).pem ./pki/reqs/clientcsr.pem
ln -f -s $(cat ./pki/serial).pem ./pki/certs/clientcert.pem
openssl genrsa -out ./pki/private/$(cat ./pki/serial).pem 4096
openssl req -config ./pki/openssl.cnf -new -subj /CN=$(cat ./pki/serial) -key ./pki/private/$(cat ./pki/serial).pem -out ./pki/reqs/$(cat ./pki/serial).pem
openssl ca -config ./pki/openssl.cnf -extensions client -batch -notext -in ./pki/reqs/$(cat ./pki/serial).pem -out ./pki/certs/$(cat ./pki/serial).pem
openssl verify -crl_check -CAfile ./pki/cacert.pem -CRLfile ./pki/crl.pem ./pki/certs/$(cat ./pki/serial.old).pem

# openssl ca -config ./pki/openssl.cnf -revoke ./pki/certs/clientcert.pem
# xxd -ps -u -l 20 /dev/urandom ./pki/crlnumber
# ln -f -s crl/$(cat ./pki/crlnumber).pem ./pki/crl.pem
# openssl ca -config ./pki/openssl.cnf -gencrl -out ./pki/crl.pem
# openssl verify -crl_check -CAfile ./pki/cacert.pem -CRLfile ./pki/crl.pem ./pki/certs/clientcert.pem
