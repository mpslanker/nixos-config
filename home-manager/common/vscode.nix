{ pkgs, ... }:
{
  programs.vscode.enable = true;

  programs.vscode.extensions = [
    pkgs.vscode-extensions.bbenoist.nix
  ];

}
