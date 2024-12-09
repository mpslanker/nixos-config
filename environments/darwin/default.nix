# common/default.nix
{
  lib,
  inputs,
  outputs,
  pkgs,
  config,
  username,
  homeDirectory,
  hostname,
  stateVersion,
  ...
}:
{
  imports = [
    ./configuration.nix
  ];
}
