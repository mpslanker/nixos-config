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

      "corpjump" = {
        hostname = "35.171.76.59";
        user = "ec2-user";
        identityFile = "~/.ssh/shared_services.pem";
      };

      # GitLab SCM Dev jumpbox
      "scmdevjump" = {
        hostname = "18.221.147.115";
        user = "ec2-user";
        identityFile = "~/.ssh/ISCMSPGITLAB.pem";
      };

      # ISC Corporate account GitLab server
      "isc-gitlab" = {
        hostname =  "10.0.3.135";
        user = "ubuntu";
        identityFile = "creds.pem";
      };

      # SCM Dev GitLab server
      "scm-dev" = {
        hostname =  "10.0.142.90";
        user = "ubuntu";
        identityFile = "key.pem";
      };
    };
    extraConfig = lib.mkOrder 100 ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}

