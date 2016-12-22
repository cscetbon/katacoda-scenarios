The first script launches the Consul and Vault containers 
./start-vault.sh{{execute}}

The Vault starts sealed meaning you can read/write data. Use the helper script to unseal the vault 
./unseal-vault.sh{{execute}}. 
If this errors, it's because Vault is still initialising.

The final stage is to obtain the access token; this is outputted when we initialised and unsealed the vault.

export VAULT_TOKEN=$(grep 'Initial Root Token:' keys.txt | awk '{print substr($NF, 1, length($NF)-1)}'){{execute}}

By logging in we can now start storing and persisting data 
vault auth -address=${VAULT_ADDR} ${VAULT_TOKEN}{{execute}}

After running the commands Vault and your environment have been configured.
