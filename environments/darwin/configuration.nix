{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  homeDirectory,
  hostname,
  stateVersion,
  agenix,
  ...
}:
{
  imports = [
    ./system.nix
    ./apps.nix
  ];
  system.stateVersion = 5;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # inputs.brew-nix.overlays.default
    ];
    config = {
      allowUnfree = true;
      # allowUnsupportedSystem = true;
      experimental-features = "nix-command flakes";
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        nix-path = config.nix.nixPath;
        trusted-users = [ "${username}" ];
        auto-optimise-store = false;
        # extra-substituters = ["https://nixpkgs-python.cachix.org"];
        # extra-trusted-public-keys = ["nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU=" "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
      };

      gc = {
        automatic = lib.mkDefault true;
        options = lib.mkDefault "--delete-older-than 7d";
      };

      extraOptions = lib.optionalString (
        config.nix.package == pkgs.nixVersions.stable
      ) "experimental-features = nix-command flakes";

      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  ids.uids.nixbld = lib.mkForce 350;

  networking.hostName = hostname;

  users.users = {
    "${username}" = {
      # shell = pkgs.zsh;
      # You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      openssh.authorizedKeys.keys = [
        " ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJe5pR2ATMGK66uDEngdTiMRiN5Su7GPASflwdYMzhzE ${username}"
      ];
      description = username;
    };
  };

  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.fish = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    _1password-cli
    # aerospace # moved to home-manager
    atuin
    bat
    agenix.packages.${pkgs.system}.default
    fzf
    git
    git-extras
    git-lfs
    hexyl
    jq
    # mkalias # Only needed if pkgs install in to /Applications/ Nix\ Apps
    neovim
    pam-reattach
    ripgrep
    tart
    tealdeer
    tmux
    tree
    unixtools.watch
    wget
    wireguard-tools
  ];

  nixpkgs.flake = {
    setFlakeRegistry = false;
    setNixPath = false;
  };
}
