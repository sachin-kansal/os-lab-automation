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
  address = "{{ ansible_default_ipv4.address }}:8200"
  tls_disable = 1
}
