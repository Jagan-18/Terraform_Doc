# Dynamic Secrets** in Terraform / Vault. 
---
# 🔑 Dynamic Secrets:
## 1. What are Secrets?

* **Secrets** = sensitive values (DB passwords, API keys, TLS certs).
* Traditionally: stored **statically** in config files or secret managers (e.g., AWS Secrets Manager, HashiCorp Vault).
* Problem: Static secrets may stay valid forever → risk of **leak/exploit**.

---
## 2. What are Dynamic Secrets?
* **Dynamic secrets are generated on-demand, short-lived, and auto-expire.**
* Instead of reusing the same password/key, a **new unique secret** is created every time.
* Example:

  * Developer requests DB access → Vault generates a new DB username/password valid for 1 hour.
  * After TTL (time-to-live), credentials expire → useless if leaked.

---
## 3. How Dynamic Secrets Work (Vault example)
1. App/Dev requests secret from Vault.
2. Vault authenticates request (via token, AWS IAM role, Kubernetes SA, etc.).
3. Vault dynamically **generates credentials** (e.g., MySQL user, AWS IAM key).
4. App uses credentials → TTL countdown starts.
5. Vault **automatically revokes** credentials when TTL ends.

---
## 4. Benefits:
✅ **Least privilege** → secrets created with only needed permissions.
✅ **Short-lived** → reduces impact of leaks.
✅ **Audit-friendly** → each secret is unique per request.
✅ **Automated revocation** → no manual cleanup needed.
---
## 5. Example with HashiCorp Vault:
* **Dynamic DB secret (MySQL)**

```hcl
# Terraform config to enable Vault DB secrets engine
resource "vault_database_secret_backend" "db" {
  backend       = "database"
  path          = "db"
  plugin_name   = "mysql-database-plugin"
  connection_url = "root:password@tcp(mysql.example.com:3306)/"
}

resource "vault_database_secret_backend_role" "app_role" {
  backend             = vault_database_secret_backend.db.path
  name                = "app-role"
  db_name             = "my-db"
  creation_statements = [
    "CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}'; GRANT SELECT ON my-db.* TO '{{name}}'@'%';"
  ]
  default_ttl = "1h"
  max_ttl     = "24h"
}
```
* Now when an app requests a DB secret:

  ```
  vault read db/creds/app-role
  ```

  → Vault returns:

  ```
  username = v-token-abc123
  password = XyZ!456
  ttl      = 1h
  ```

---
## 6. Common Dynamic Secret Types:
* **Databases** → MySQL, PostgreSQL, MSSQL.
* **Cloud providers** → AWS, Azure, GCP IAM credentials.
* **PKI** → TLS certs on the fly.
* **Messaging** → RabbitMQ, Kafka creds.

---
## 7. ASCII Flow Diagram:
```
   App/Dev → Authenticate to Vault → Request secret
       │
       ▼
   Vault → Generate dynamic secret (AWS key / DB user / cert)
       │
       ▼
   App receives secret (with TTL)
       │
       ▼
   Secret auto-expires → Vault revokes access
```

---
✅ In short:
**Dynamic secrets = temporary, auto-expiring secrets generated on-demand**.
Safer than static secrets, reduces risk, and perfect for DevOps + Terraform pipelines.

---
## 👍Herewe can see the step by step on how **Terraform + Vault** can be used to generate **Dynamic AWS credentials** (short-lived IAM keys).

---
# 🌐 Terraform + Vault → Dynamic AWS Credentials:
## 1. Setup Concept

* **Vault** is the secrets manager.
* **Terraform** provisions the Vault configuration.
* When an app/CI pipeline needs AWS access, Vault generates **temporary IAM keys** with TTL (e.g., 1h).

---
## 2. Flow Diagram (ASCII):
```
Terraform → Configures Vault AWS secrets engine
      │
      ▼
Vault AWS Secrets Engine → Talks to AWS IAM
      │
      ▼
App / CI/CD → Requests AWS creds from Vault
      │
      ▼
Vault → Generates temporary IAM keys (Access Key + Secret + TTL)
      │
      ▼
App uses creds → Expire after TTL → Auto revoked
```

---
## 3. Terraform Code Example:
### (a) Enable AWS Secrets Engine

```hcl
resource "vault_auth_backend" "aws" {
  type = "aws"
}

resource "vault_aws_secret_backend" "aws" {
  path       = "aws"
  access_key = "ROOT_AWS_ACCESS_KEY"
  secret_key = "ROOT_AWS_SECRET_KEY"
  region     = "ap-south-1"
}
```

---
### (b) Create IAM Role Mapping:
```hcl
resource "vault_aws_secret_backend_role" "dev_role" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "dev-role"
  credential_type = "iam_user"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]

  default_sts_ttl = 3600   # 1 hour
  max_sts_ttl     = 7200   # 2 hours
}
```
---
### (c) Developer / CI/CD Requests Secret:
Run:

```bash
vault read aws/creds/dev-role
```

Vault will return:

```
lease_id       = aws/creds/dev-role/abc123
access_key     = AKIAIOSFODNN7EXAMPLE
secret_key     = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
security_token = null
lease_duration = 1h
lease_renewable = true
```

---
## 4. Key Points:
* **Short-lived** AWS IAM users generated automatically.
* Expire after **1h TTL** (or as configured).
* Perfect for CI/CD pipelines → no need to store long-term AWS keys.
* Access is automatically revoked by Vault after TTL.
---
## 5. Security Benefits:
✅ No hardcoded AWS keys in Terraform, Git, or Jenkins.
✅ Every request gets **unique credentials**.
✅ If leaked, credentials are useless after TTL.
✅ Easy rotation & audit logs from Vault.

---
