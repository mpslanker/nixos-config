{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    monolisa-nerdfonts
  ];
}