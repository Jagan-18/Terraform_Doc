# Terrafrom 

<img width="1172" height="602" alt="Image" src="https://github.com/user-attachments/assets/f9aa2b4d-b10b-435e-b47c-1b94912f4e9f" />

# 🔎 Detailed Explanation of the Diagram
## 1. **GitLab (Source Code Management)**

* Terraform code is version-controlled in **GitLab repository**.
* Developers use **branches** to separate work:

  * **Dev branch** → experimental/in-progress code.
  * **Main branch** → stable, reviewed, and approved code.
* GitLab also acts as a **CI/CD trigger point** (pipelines can run automatically on push/merge).

---
## 2. **Development Terraform Core**
This is the **Terraform execution engine** (could be Terraform CLI, Terraform Cloud, or GitLab pipeline job) that manages **non-production infra (Dev Env)**.

* **Connected to Dev Branch**:

  * Any change pushed to **dev branch** triggers this core.
  * Runs `terraform init`, `plan`, and `apply` against **Dev Environment**.

* **Purpose**:

  * Test new infrastructure code safely.
  * Ensure modules, variables, providers are working.
  * Catch errors before they reach higher environments.

* **Access Control**:

  * Uses **Dev Access Key** → IAM credentials with permissions limited only to Dev resources.
  * Prevents accidental deployment to QA/Prod.

* **Example Use Case**:

  * Developer writes code for a new S3 bucket.
  * Pushes to **dev branch** → Development Core provisions it only in **Dev account/environment**.

---
## 3. **Production Terraform Core**
This is the **centralized Terraform engine** for deploying **stable infrastructure** into QA and Prod.

* **Connected to Main Branch**:

  * Only runs when code is merged from dev → main.
  * Ensures only reviewed/approved code reaches QA and Prod.

* **Multi-Environment Control**:

  * Can apply code to:

    * **QA Env** → with **QA access key**.
    * **Prod Env** → with **Prod access key**.
  * Often gated with **approval steps** (e.g., manual approval before Prod apply).

* **Purpose**:

  * Standardize and control production deployments.
  * Maintain **separation of duties**: Dev Core ≠ Prod Core.
  * Ensure infra in QA/Prod is stable and consistent.

* **Access Control**:

  * Uses **different IAM keys** for QA and Prod.
  * Provides **security isolation** between environments.

---
## 4. **Environments**
Each environment is a **separate execution target** (different cloud accounts, VPCs, or subscriptions).

* **Dev Environment (black)**

  * Used by developers for testing infra changes.
  * Frequent deployments, less strict policies.

* **QA Environment (red)**

  * For QA/testing teams to validate infra before production.
  * Runs staging workloads, integration tests.
  * Typically mirrors Prod closely.

* **Prod Environment (green)**

  * Live, business-critical workloads.
  * Very restricted access (only Prod Terraform Core with Prod IAM key can update).

---
## 5. **Access Keys & Security**
* Each environment has its **own credentials**: Dev, QA, Prod.
* This ensures:

  * Dev Core cannot accidentally touch Prod.
  * Least-privilege principle applied.
  * Audit control (different IAM roles).

---
# ⚡ End-to-End Flow Example: 
1. **Dev Phase**

   * Developer → Checkout Dev Branch → Write Terraform Code → Push.
   * Development Terraform Core runs → Deploys changes to Dev Env using **Dev Access Key**.

2. **Merge to Main (Promotion Phase)**

   * Once tested, Dev code is merged into **Main branch**.
   * Main branch triggers **Production Terraform Core**.

3. **QA Phase**

   * Production Terraform Core runs → Deploys infra to **QA Env** with QA Access Key.
   * QA team validates infra.

4. **Prod Phase**

   * After QA approval → Terraform Core applies to **Prod Env** with Prod Access Key.
   * Infra is now live in Production.

---
✅ In short:
* **Development Terraform Core** = Sandbox executor (Dev branch → Dev Env).
* **Production Terraform Core** = Controlled executor (Main branch → QA + Prod).
* **Access Keys** = Isolate environments.
* **GitLab branches** = Control promotion of infrastructure code.

---
# 🔧 Terraform Workflow with Commands (ASCII Diagram)

```
                  ┌──────────────────┐
                  │     GitLab        │
                  │ (Terraform Code)  │
                  └───────┬───────────┘
                          │
        ┌─────────────────┴──────────────────┐
        │                                    │
   (Dev Branch)                         (Main Branch)
        │                                    │
        ▼                                    ▼
┌───────────────────┐                 ┌───────────────────┐
│ Development Core  │                 │ Production Core    │
│ (Terraform Engine)│                 │ (Terraform Engine) │
└─────────┬─────────┘                 └─────────┬─────────┘
          │                                     │
   terraform init                               │
   terraform plan                               │
   terraform apply --auto-approve               │
          │                                     │
          ▼                                     │
   ┌───────────────┐                            │
   │  Dev Env       │                            │
   │ (Testing Infra)│                            │
   └───────┬────────┘                            │
           │                                     │
           └────── Merge to Main ────────────────┘
                                               │
                            ┌──────────────────┴──────────────┐
                            │                                  │
                     terraform init                    terraform init
                     terraform plan                    terraform plan
                     terraform apply                   terraform apply
                  (with QA Access Key)             (with Prod Access Key)
                            │                                  │
                            ▼                                  ▼
                   ┌───────────────┐                 ┌───────────────┐
                   │   QA Env       │                 │   Prod Env     │
                   │ (Validation)   │                 │ (Live Infra)   │
                   └───────────────┘                 └───────────────┘
```
---
### 🔎 Step-by-Step Command Flow

1. **Dev Branch → Dev Env**
   ```bash
   git checkout dev
   terraform init
   terraform plan
   terraform apply --auto-approve
   ```

2. **Merge Dev → Main Branch**
   ```bash
   git checkout main
   git merge dev
   git push origin main
   ```

3. **Main Branch → QA Env**
   ```bash
   terraform init
   terraform plan -var-file=qa.tfvars
   terraform apply --auto-approve -var-file=qa.tfvars
   ```

4. **Main Branch → Prod Env** (after QA approval)
   ```bash
   terraform init
   terraform plan -var-file=prod.tfvars
   terraform apply --auto-approve -var-file=prod.tfvars
   ```

---
* 🔎 Quick Read of the Flow:
1. **Dev branch** → Development Core → Dev Env (safe testing).
2. After testing, **code merged to main branch.**
3. **Main branch** → Production Core → QA Env (validation).
4. After QA approval → Production Core → **Prod Env (live infra).**
   
✅ This way:
* **Dev Core** = safe sandbox testing.
* **Prod Core** = controlled QA + Prod rollout.
* **Commands** ensure idempotent, repeatable deployments.



---




