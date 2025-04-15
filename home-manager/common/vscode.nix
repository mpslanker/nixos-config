{ pkgs, ... }:
{
  programs.vscode.profiles.default.enable = true;
  programs.vscode.profiles.default.enableUpdateCheck = true;

  programs.vscode.profiles.default.extensions = [
    pkgs.vscode-extensions.bbenoist.nix
  ];

}
