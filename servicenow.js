var gitRepo = "https://github.com/your-repo/terraform-scripts.git";
var terraformScriptPath = "path/to/terraform/script";
var terraformCommand = "terraform apply -auto-approve";

// Clone the Git repository
var gitClone = new GlideScriptedGit("your-git-username", "your-git-token");
gitClone.cloneRepo(gitRepo, "/tmp/terraform");

// Execute the Terraform script
var terraform = new GlideScriptedTerraform();
terraform.execute(terraformScriptPath, terraformCommand);
