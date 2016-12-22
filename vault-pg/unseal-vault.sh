export VAULT_ADDR=http://127.0.0.1:8200
docker exec -it vault-dev vault init -address=${VAULT_ADDR} > keys.txt
docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 1:' keys.txt | awk '{print $N
F}')
docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 2:' keys.txt | awk '{print $N
F}')
docker exec -it vault-dev vault unseal -address=${VAULT_ADDR} $(grep 'Key 3:' keys.txt | awk '{print $N
F}')
