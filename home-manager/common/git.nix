{
  lib,
  pkgs,
  username,
  company,
  fullname,
  useremail,
  workemail,
  ...
}:
{
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.config/git/config*
  '';

  xdg.configFile."git/.gitignore" = {
    enable = true;
    text = ''
      # Core ignore rules
      **/.DS_Store
      **/nogit/**

      # Temporarily ignore
      **/devkit/**
    '';
  };

  xdg.configFile."git/config.work" = {
    enable = true;
    text = ''
      ; ${company} Configuration Overrides
      [user]
        email = ${workemail}

      [core]
        sshCommand = ssh -i ~/.ssh/${username}
    '';
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    # TODO replace with your own name & email
    userName = "${fullname}";
    userEmail = "${useremail}";

    includes = [
      {
        # Use work config if under ~/code/{company}
        path = "config.work";
        condition = "gitdir:~/code/${company}/**";
      }
    ];

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
      fetch.prune = true;
      core.sshCommand = "ssh -i ~/.ssh/mpslanker";
      core.excludeFile = "~/.config/git/.gitignore";
    };

    delta = {
      enable = true;
      options = {
        features = "side-by-side";
      };
    };

    aliases = {
      # common aliases
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
      amend = "commit --amend -m";

      # aliases for submodule
      update = "submodule update --init --recursive";
      foreach = "submodule foreach";
    };
  };
}
