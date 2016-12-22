docker pull consul:0.7.1
docker pull vault:0.6.4
docker pull postgres:9.6

cat > vault.hcl <<EOF
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

backend "consul" {
  path = "vault/"
  address = "consul:8500"
  tls_skip_verify = 0
}

disable_mlock = true

default_lease_ttl = "720h"

max_lease_ttl = "720h"
EOF

cat > start-vault.sh <<EOF
docker create -v /config --name config busybox; docker cp vault.hcl config:/config/
docker run -d --name consul -p 8500:8500 consul:0.7.1 agent -dev -client=0.0.0.0
docker run -d --name vault-dev --link consul:consul -p 8200:8200 --volumes-from config vault:0.6.4 server -config=/config/vault.hcl
EOF

cat > unseal-vault.sh <<EOF
export VAULT_ADDR=http://127.0.0.1:8200
docker exec -it vault-dev vault init -address=${VAULT_ADDR} > keys.txt
docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 1:' keys.txt | awk '{print $NF}')
docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 2:' keys.txt | awk '{print $NF}')
docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 3:' keys.txt | awk '{print $NF}')
EOF
