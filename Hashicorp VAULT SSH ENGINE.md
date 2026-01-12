# Hashicorp VAULT SSH ENGINE

`
### SSH ENGINE: Vault Configuration and Usage

#### Prerequisites (On Target Machine)

```bash
useradd -m -s /bin/bash sachin
```

### Vault Server Configuration

#### Enable SSH Secrets Engine
```bash
vault secrets enable -path=test_ssh ssh
```

#### Configure SSH Role (`my-role`)

```bash
vault write test_ssh/roles/my-role -<<EOH
{
  "algorithm_signer": "rsa-sha2-256",
  "allow_user_certificates": true,
  "allowed_users": "*",
  "allowed_extensions": "permit-pty,permit-port-forwarding",
  "default_extensions": {
    "permit-pty": ""
  },
  "key_type": "ca",
  "default_user": "one97",
  "ttl": "2h"
}
EOH
```

### Configure Remote Machines

#### Retrieve and Trust the CA Public Key

On all remote machines:

```curl
curl -H "X-Vault-Token: <VAULT_TOKEN>" \
     -o /etc/ssh/trusted-user-ca-keys.pem \
     http://<VAULT_ADDR>:8200/v1/test_ssh/public_key
```

#### Update `sshd` Configuration

Add the trusted CA key to the SSH daemon configuration.

cat /etc/ssh/sshd_config.d/vault.conf
TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem


#### Restart SSH Daemon

sshd -t
systemctl restart sshd

### On Local Machine

#### Generate Local SSH Key Pair


ssh-keygen -t ed25519 -f ~/.ssh/id_vault


#### Generate Short-Lived Signed Certificate (Using `my-role`)


vault write test_ssh/sign/my-role \
    public_key=@~/.ssh/id_vault.pub

or curl

PUB_KEY=$(cat ~/.ssh/id_vault.pub)

curl -X POST \
  -H "X-Vault-Token: $VAULT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"public_key\":\"$PUB_KEY\"}" \
  $VAULT_ADDR/v1/test_ssh/sign/my-role



The output will include the signed certificate.

#### Save the Signed Certificate

Example command to save the certificate (note: the provided `echo` command saves a specific example cert, the actual command should capture the output of the `vault write` above):

Example provided in original doc, capturing the actual output is better:

vault write test_ssh/sign/my-role public_key=@~/.ssh/id_vault.pub 

Original document's specific echo command:
echo "ssh-ed25519-cert-v01@openssh.com AAAAIHNzaC1lZDI1NTE5LWNlcnQtdjAxQG9wZW5zc2guY29tAAAAIMNo/YT6czlmn0/K08nusilSzmnjL5Qo2/sXc10JrNwFAAAAIAm2ODhdhVJmF1A/Ob2ylsyKF4HJ2R3wH7WrYCF/77llfjvSE5k5CVwAAAABAAAAS3ZhdWx0LXJvb3QtODhhZGM3YTJjOWE0ZmRjZTM1MGY5NWQ0ZTE2NjE2YmE3M2EwMmZkYmNkNDNhYjczMzUwYmI1ODZkYTMwY2JjZAAAAAkAAAAFb25lOTcAAAAAaWQ4vAAAAABpZFT6AAAAAAAAABIAAAAKcGVybWl0LXB0eQAAAAAAAAAAAAACFwAAAAdzc2gtcnNhAAAAAwEAAQAAAgEA3Hk0cOh1ZRMumBhKDNmdXtMYAoirKkGJyRJU6mRp33T4F1NYCKFHR44LO0NszDzLLZNBNCtQHEqkUro5pfsxt/lLQAVsq3kzN7s9NMK8BqaYRbTd1zlG64VeF7uqRWscE3ivVAALWSoL16XgPxrDjmGOrDNdC0ginphL8V/r9C0iI2axASQsGW4beM9vaYe+KTwCz2FkVj6RterNqsRsnGn6RftLCMUZNb4FoKWSLMbm9Mvkt+fcpL7KkgrMQ8+B9idz8d1sACHq5I10fyGR5qRzl5uraGVvXbsqxuBY8F+PhavwZZ0eqXvGU6atokITXhpF3d5mlbCr/B36UHWex3+Dj1AqkDi4PraUklLSsRGX3xziZDADQUnYPTjTT4aeAa7DPDT7ZBoz2XcQKc1scB+2JzHdv/UNdwFDIaijrusWP1jxMZKFTncquz6FbttGwKb5MvcTHRn2lWTqzupxa6hYGoiG30SZmHWsVNfWIcVt8sGR22my3Dceo/Esvv4AU4cKy+Tr2tlHUlwhwUOfixXcAZ9+3nVo4m7ZOvQX4AMvc+F94TQ4Se7vA2UxANL+jbBiuzdZnaU7NCxtBbpe3BoFt9JD4zKJGOQVntfgfj3dukGRFZ+pz81T0SKQz1nBjnUPICwE9xBG/dD6ccD3ExAMSH4dzXlTzd2FZa5BS4EAAAIUAAAADHJzYS1zaGEyLTI1NgAAAgCyUI52Nn+qgn3obriUbx1ZCJ7Tsbd5TH20GrOf0QOpQfYno6mGX8svVgx6Kn7gz4sHE4/lxpjY9r03Gsd531T1XBMkdx/GBFzpIfBkIkXsaZoQqCSOYHegKJgfDzG0qbvDZhVcqDvlZwVbO2t6Yq/YkKbYc35Dmog3ssVvfHy8YjeIA1qXG/MRdMubKu6IcLiFIvi1Evb7Eft4Yblfm9UvCncO3SQ+W1x5BVdyi91wakxbVE4ZkvjAOQz1Qgb06K/tt5qpZjyXjan6COznsBvuFafkZeEvS5sVByGg1AvVYHFtrIxHtDup2ZO+w1x7bwxmRhZ0UVF6MqYq5jkSFg3ockbI3WWNwf29OFKSMBOZRdLUfz/rF3HJMeI3f1TLaz+LNhBsehvKpi4bkI5MtO0gLWVrzBsLMlhuxJWMDst/q8XdKGYdGxtJhTsOv7VpYzSyybLr6J44m5if1G+c2c8lDz5tF3UMaW1BPRuRkRxx+S/nKnqBcKFCfOY7vIZc9a4mTekWpSBooWEoZqrWcRhH9XskiWf0skZwXAcHLp9OPnVi9byt68VCrGnOw5BjJ0RjpjR9iwdLOpj1BaPpczOBTzwCOKkfx+zpuyXdXfDk6KHD/ljoYgVAW25KKZsTiCzcnmaCEtmIVDHtnAe927zP9BvMYmQXGb6nOO/bX3/TsTw==" \
> ~/.ssh/id_vault-cert.pub


#### Generate Short-Lived Signed Certificate (Using `ca_test` role, if needed)

The original document repeats the vault write command for a role named `ca_test`:


vault write test_ssh/sign/ca_test public_key=@~/.ssh/id_vault.pub > ~/.ssh/id_vault-cert.pub


#### Set Permissions


chmod 600 ~/.ssh/id_vault-cert.pub


### SSH Access
Use the private key and the signed certificate to authenticate.

ssh -i ~/.ssh/id_vault -i ~/.ssh/id_vault-cert.pub one97@10.18.0.27

**Note:** OpenSSH usually detects the corresponding `-cert.pub` file automatically if the private key is specified, so the following might also work:


ssh -i ~/.ssh/id_vault one97@10.18.0.27
```
