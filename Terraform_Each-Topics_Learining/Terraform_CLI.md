# Terraform CLI (Command Line Interface):

## Understanding the Terraform CLI
#### What Is the Terraform CLI?
The Terraform CLI is the command-line tool that lets you interact with Terraform, executing tasks like initializing your project, planning and applying changes, validating configurations, and inspecting resources. Virtually every operation in Terraform begins here.

---
## Step-by-Step Guide:
Run the following commands in the terminal and inspect their output. To learn more about each command, try adding a `-help` flag to the command!

-   `terraform validate`: Checks the syntax of the Terraform files and verifies that they are internally consistent, but does not ensure that the resources exist or that the providers are properly configured.
-   `terraform fmt`: Automatically updates Terraform configuration files to a canonical format and style, improving consistency and readability. The command works only for the files in the current working directory, but you can also add a `-recursive` flag to format `.tf` files in nested directories.
-   `terraform plan`: Creates an execution plan, showing what actions Terraform will take to achieve the desired state defined in the Terraform files. This command does not modify the actual resources or state.
-   `terraform plan -out <filename>`: Similar to `terraform plan`, but it also writes the execution plan to a file that can be used by `terraform apply`, ensuring that exactly the planned actions are taken.
-   `terraform apply`: Applies the execution plan, making the necessary changes to reach the desired state of the resources. If you run `terraform plan` with the `-out` option, you can run `terraform apply <filename>` to provide the execution plan.
-   `terraform show`: Provides human-readable output from a state or plan file. It's used to inspect the current state or to see the actions planned by a `terraform plan` command.
-   `terraform state list`: Lists all resources in the state file, useful for managing and manipulating the state.
-   `terraform destroy`: Destroys all resources tracked in the state file. This command is the equivalent of passing a `-destroy` flag to the `terraform apply` command.
-   `terraform -help`: Provides help information about Terraform commands. It can be used alone for a general overview, or appended to a specific command for detailed help about that command.

---
### Essential Terraform CLI Commands
Here’s a breakdown of the key commands you’ll use most often, along with their practical meaning and workflow context:

#### 1. terraform init
- **Purpose:** Initializes a working directory with Terraform configuration files.
- **Details:** Downloads provider plugins, prepares the directory for use, sets up remote backends if configured.
- **Use Case:** Run after creating or copying a new Terraform project.

#### 2. terraform plan:
- **Purpose:** Previews changes Terraform will make.
- **Details:** Compares your configuration files with what’s already in state and shows a summary of additions, modifications, or deletions.
- **Use Case:** Always run before applying—this helps prevent surprises!

#### 3. terraform apply:
- **Purpose:** Executes the planned changes—provisions, updates, or removes infrastructure to match your configuration.
- **Details:** Prompts for approval unless you use -auto-approve, then interacts with the provider(s) to create/update resources.
- **Use Case:** Deploy real infrastructure or update existing resources.

#### 4. terraform destroy:
- **Purpose:** Removes all resources managed by a given Terraform configuration.
- **Details:** Useful for tearing down dev/test environments.
- **Use Case:** Run this when you want to clean up all infrastructure defined in a particular configuration.

#### 5. terraform validate:
- **Purpose:** Checks your configuration files for syntax errors and logical issues.
- **Details:** Quickly spots mistakes before you try to apply.
- **Use Case:** Use anytime you change a .tf file.

#### 6. terraform fmt:
- **Purpose:** Formats your configuration files to be consistent and readable.
- **Details:** Enforces standard styling for HCL files.
- **Use Case:** Helpful before committing changes to version control.

#### 7. terraform output:
- **Purpose:** Displays information defined in your output blocks.
- **Details:** Shows values like resource IPs, IDs, or other exports after apply.
- **Use Case:** Run when you want to see results from your deployment.

### 8. terraform state:
- **Purpose:** Inspects and manages the current state file.
- **Details:** Advanced users use it to list, show, rm, and mv resources in state.
- **Use Case:** Useful for troubleshooting or advanced manual interventions.
---

#### Typical Workflow Example:
1. Write or update .tf config files.
2. Run terraform init to start the working directory.
3. Run terraform plan to preview changes.
4. Run terraform apply to create or update infrastructure.
5. Use terraform output to see exported values.
6. When finished, run terraform destroy to clean up.
---
#### Best Practices for Using the CLI:
1. Always run terraform plan before terraform apply.
2. Commit your formatted code by running terraform fmt.
3. Use terraform validate to catch configuration errors early.
4. Store the state file securely, ideally using remote backends for team projects.
5.  Use the CLI help flag (terraform [command] -help) to discover options and usage for any command.


#### Summary:
The Terraform CLI is your gateway to building and managing infrastructure as code. By mastering its core commands, you'll be able to automate deployments, monitor infrastructure changes, and collaborate more effectively in cloud projects.
