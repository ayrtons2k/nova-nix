# /home/ayrton/nova-nix-config/modules/editors/vscode/default.nix
#
# This module provides a function to create a customized Visual Studio Code
# package with a specified list of extensions.

{ pkgs }: # This function accepts the nixpkgs set as an argument

# The function that will be imported by other flakes.
# It takes a list of extension packages as input.
{ extensions ? [] }:

# Use vscode-with-extensions to build a new VS Code package.
pkgs.vscode-with-extensions.override {
  # The base vscode package to use. You could switch this to pkgs.vscodium if you prefer.
  vscode = pkgs.vscode;

  # The list of extensions to install.
  # The `extensions` argument is the list of packages passed to this function.
  vscodeExtensions = extensions ++ [
    # You can also include a list of extensions that you want in ALL vscode environments.
    # Example: pkgs.vscode-extensions.github.copilot
  ];
}