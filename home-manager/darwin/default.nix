# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  homeDirectory,
  stateVersion,
  ...
}:
let
  initConfigAdditions = ''
    eval $(/opt/homebrew/bin/brew shellenv)
    # source ${pkgs.iterm2-terminal-integration}/bin/iterm2_shell_integration.fish
  '';
in
{
  imports = [
    ../common
    ./safari.nix
  ];

  home.packages = [
    pkgs.aerospace
    pkgs.jankyborders
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nodejs_20
    pkgs.python311Full
    pkgs.sketchybar
    pkgs.watchexec
  ];

    # home.packages =
    #   (import ../common/packages.nix {inherit pkgs lib;}).home.packages
    #   ++ (with pkgs; [
    #     # macos only packages
    #     shopt-script
    #     iterm2-terminal-integration
    #     clai-go
    #   ]);
    # programs.fish.interactiveShellInit = lib.strings.concatStrings [
    #   (import ../common/fish/init.nix {inherit pkgs;}).interactiveShellInit
    #   initConfigAdditions
    # ];

  programs.git.extraConfig.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
