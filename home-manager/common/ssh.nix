{
  pkgs,
  lib,
  ...
}:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {

      # Self-hosted GitLab 
      "git.msitp.io" = {
        hostname = "git.msitp.io";
        identityFile = "~/.ssh/mpslanker";
        identitiesOnly = true;
      };

      # GitHub proper
      # "github.com" = {
      #   hostname = "github.com";
      #   identityFile = "~/.ssh/mpslanker";
      #   identitiesOnly = true;
      # };

      "i-* mi-*" = {
        proxyCommand = "sh -c \"aws ssm start-session --target %h --document-name AWS-StartSession --parameters 'portNumber=%p'\"";
      };

    };
    includes = [
      "~/.ssh/work_servers.config"
    ];
    
    extraConfig = lib.mkOrder 100 ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}

