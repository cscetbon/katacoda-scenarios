echo 'listener "tcp" {' >> vault.hcl
echo '  address = "0.0.0.0:8200"' >> vault.hcl
echo '  tls_disable = 1' >> vault.hcl
echo '}' >> vault.hcl
echo >> vault.hcl
echo 'backend "consul" {' >> vault.hcl
echo '  path = "vault/"' >> vault.hcl
echo '  address = "consul:8500"' >> vault.hcl
echo '  tls_skip_verify = 0' >> vault.hcl
echo '}' >> vault.hcl
echo >> vault.hcl
echo 'disable_mlock = true' >> vault.hcl
echo '' >> vault.hcl
echo 'default_lease_ttl = "720h"' >> vault.hcl
echo >> vault.hcl
echo 'max_lease_ttl = "720h"' >> vault.hcl
echo 'docker create -v /config --name config busybox; docker cp vault.hcl config:/config/' >> start-vault.sh
echo 'docker run -d --name consul -p 8500:8500 consul:0.7.1 agent -dev -client=0.0.0.0' >> start-vault.sh
echo 'docker run -d --name vault-dev --link consul:consul -p 8200:8200 --volumes-from config vault:0.6.4 server -config=/config/vault.hcl' >> start-vault.sh
echo 'export VAULT_ADDR=http://127.0.0.1:8200' >> unseal-vault.sh
echo 'alias vault=\'docker exec -it vault-dev vault "$@"\'' >> unseal-vault.sh
echo 'docker exec -it vault-dev vault init -address=${VAULT_ADDR} > keys.txt' >> unseal-vault.sh
echo 'docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 1:' keys.txt | awk "{print $NF}")' >> unseal-vault.sh
echo 'docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 2:' keys.txt | awk "{print $NF}")' >> unseal-vault.sh
echo 'docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 3:' keys.txt | awk "{print $NF}")' >> unseal-vault.sh
chmod u+x *.sh
