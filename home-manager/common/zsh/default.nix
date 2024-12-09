{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # autosuggestion.enable = true;
    # autosuggestion.highlight = "fg=#c2bdbd";

    shellAliases = {
      "ll" = "ls -l";
      ".." = "cd ..";
    };

    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)" 
    '';

  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # autosuggestion.enable = true;
    # autosuggestion.highlight = "fg=#c2bdbd";

    oh-my-zsh.enable = true;
    oh-my-zsh.theme = "";
    oh-my-zsh.plugins = [
      "git"
      "sudo"
    ];

    shellAliases = {
      "ll" = "ls -l";
      ".." = "cd ..";
    };

    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)" 
    '';

  };
}
