docker create -v /config --name config busybox; docker cp vault.hcl config:/config/;
docker run -d --name consul -p 8500:8500 consul:v0.6.4 agent -dev -client=0.0.0.0
docker run -d --name vault-dev --link consul:consul -p 8200:8200 --volumes-from config cgswong/vault:0.
5.3 server -config=/config/vault.hcl
