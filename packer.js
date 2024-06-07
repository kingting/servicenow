//File: packer.js

var gitRepo = "https://github.com/your-repo/packer-scripts.git";
var packerScriptPath = "path/to/packer/template.json";
var packerCommand = "packer build " + packerScriptPath;

// Clone the Git repository
var gitClone = new GlideScriptedGit("your-git-username", "your-git-token");
gitClone.cloneRepo(gitRepo, "/tmp/packer");

// Execute the Packer script
var packer = new GlideScriptedPacker();
packer.execute(packerCommand);
