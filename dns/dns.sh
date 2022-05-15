# udp
echo -n www.kernel.org | perl -e 'printf("%04x",int(rand(65536)));printf("%020b",266240);foreach$s(split(/\./,<STDIN>)){printf("%02x",length($s));foreach$c(split(//,$s)){printf("%x",ord($c))}}printf("%010b",17)' | xxd -ps -r | socat - udp-connect:1.1.1.1:53 | xxd

# tcp
echo -n www.kernel.org | perl -e '$i=<STDIN>;printf("%04x",length($i)+18);printf("%04x",int(rand(65536)));printf("%020b",266240);foreach$s(split(/\./,$i)){printf("%02x",length($s));foreach$c(split(//,$s)){printf("%x",ord($c))}}printf("%010b",17)' | xxd -ps -r | socat - tcp-connect:1.1.1.1:53 | xxd

# dot
echo -n www.kernel.org | perl -e '$i=<STDIN>;printf("%04x",length($i)+18);printf("%04x",int(rand(65536)));printf("%020b",266240);foreach$s(split(/\./,$i)){printf("%02x",length($s));foreach$c(split(//,$s)){printf("%x",ord($c))}}printf("%010b",17)' | bash -c 'xxd -ps -r; sleep 1' | socat - OPENSSL:1.1.1.1:853,capath=/etc/ssl/certs/ | xxd
echo -n www.google.com | perl -e '$i=<STDIN>;printf("%04x",length($i)+18);printf("%04x",int(rand(65536)));printf("%020b",266240);foreach$s(split(/\./,$i)){printf("%02x",length($s));foreach$c(split(//,$s)){printf("%x",ord($c))}}printf("%010b",17)' | bash -c 'xxd -ps -r; sleep 1' | socat - OPENSSL:1.1.1.1:853,capath=/etc/ssl/certs/ | xxd

# doh
# POST
echo -n www.kernel.org | perl -e 'printf("%04x",int(rand(65536)));printf("%020b",266240);foreach$s(split(/\./,<STDIN>)){printf("%02x",length($s));foreach$c(split(//,$s)){printf("%x",ord($c))}}printf("%010b",17)' | xxd -ps -r | curl -s -H 'Content-Type: application/dns-message' --data-binary @- https://1.1.1.1/dns-query -o - | xxd
echo -n www.google.com | perl -e 'printf("%04x",int(rand(65536)));printf("%020b",266240);foreach$s(split(/\./,<STDIN>)){printf("%02x",length($s));foreach$c(split(//,$s)){printf("%x",ord($c))}}printf("%010b",17)' | xxd -ps -r | curl -s -H 'Content-Type: application/dns-message' --data-binary @- https://1.1.1.1/dns-query -o - | xxd
# GET
echo -n www.kernel.org | perl -e 'printf("%04x",int(rand(65536)));printf("%020b",266240);foreach$s(split(/\./,<STDIN>)){printf("%02x",length($s));foreach$c(split(//,$s)){printf("%x",ord($c))}}printf("%010b",17)' | xxd -ps -r | base64 | sed -e 's/+/-/g' -e 's|/|_|g' -e 's/=//g' -e 's|^|https://1.1.1.1/dns-query?dns=|g' | xargs curl -s -H 'Accept: application/dns-message' -o - | xxd
echo -n www.google.com | perl -e 'printf("%04x",int(rand(65536)));printf("%020b",266240);foreach$s(split(/\./,<STDIN>)){printf("%02x",length($s));foreach$c(split(//,$s)){printf("%x",ord($c))}}printf("%010b",17)' | xxd -ps -r | base64 | sed -e 's/+/-/g' -e 's|/|_|g' -e 's/=//g' -e 's|^|https://1.1.1.1/dns-query?dns=|g' | xargs curl -s -H 'Accept: application/dns-message' -o - | xxd

# dot+json
# cloudflare
curl -s -H 'Accept: application/dns-json' 'https://1.1.1.1/dns-query?name=www.kernel.org&type=A' | perl -e 'use JSON;use Net::IP;$o=decode_json(<stdin>)->{Answer};foreach$e(@$o){$i=$e->{data};new Net::IP($i)&&break;}print$i'
curl -s -H 'Accept: application/dns-json' 'https://1.1.1.1/dns-query?name=www.google.com&type=A' | perl -e 'use JSON;use Net::IP;$o=decode_json(<stdin>)->{Answer};foreach$e(@$o){$i=$e->{data};new Net::IP($i)&&break;}print$i'
# google
curl -s -H 'Accept: application/dns-json' 'https://8.8.8.8/resolve?name=www.kernel.org&type=A' | perl -e 'use JSON;use Net::IP;$o=decode_json(<stdin>)->{Answer};foreach$e(@$o){$i=$e->{data};new Net::IP($i)&&break;}print$i'
curl -s -H 'Accept: application/dns-json' 'https://8.8.8.8/resolve?name=www.google.com&type=A' | perl -e 'use JSON;use Net::IP;$o=decode_json(<stdin>)->{Answer};foreach$e(@$o){$i=$e->{data};new Net::IP($i)&&break;}print$i'
