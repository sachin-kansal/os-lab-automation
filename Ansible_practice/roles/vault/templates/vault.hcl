ui = true

mlock = true

default_lease_ttl = "768h"

log_level= "error"
log_file= "/srv/vault/log/vault.log"

storage "file" {
  path = "/srv/vault/data"
}


#HTTP listener
listener "tcp" {
  address = "192.168.31.50:8200"
  tls_disable = 1
}