The first script launches the Consul and Vault containers 
`
./start-vault.sh
`{{execute}}

The Vault starts sealed meaning you can read/write data. Use the helper script to unseal the vault 
`
./unseal-vault.sh
`{{execute}}. 
If this errors, it's because Vault is still initialising.

The final stage is to obtain the access token; this is outputted when we initialised and unsealed the vault.

`
export VAULT_TOKEN=$(grep 'Initial Root Token:' keys.txt | awk '{print substr($NF, 1, length($NF)-1)}')
`{{execute}}

Now we need to authenticate using the root token we just grabbed
`
export VAULT_ADDR=http://127.0.0.1:8200
alias vault='docker exec -it vault-dev vault "$@"'
vault auth -address=${VAULT_ADDR} ${VAULT_TOKEN}
`{{execute}}

After running the commands Vault and your environment have been configured.
