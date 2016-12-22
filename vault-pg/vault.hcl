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

