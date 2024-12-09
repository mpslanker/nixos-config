{
  description = "Slanker Nix Config";

  inputs = {
    # Nixpkgs
    # nixpkgs-24.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    # darwin
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # vscode extensions
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # wsl
    # nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    # flake-utils
    flake-utils.url = "github:numtide/flake-utils";
    # systems
    systems.url = "github:nix-systems/default";
    # devenv
    # devenv.url = "github:cachix/devenv";
    # nixpkgs-python
    # nixpkgs-python.url = "github:cachix/nixpkgs-python";
    # pre-commit-hooks
    # pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    # brew-nix
    # brew-nix = {
    #   url = "github:BatteredBunny/brew-nix";
    #   inputs.brew-api.follows = "brew-api";
    # };
    # brew-api = {
    #   url = "github:BatteredBunny/brew-api";
    #   flake = false;
    # };
    #disko
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    # extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    # extra-substituters = "https://devenv.cachix.org";
    experimental-features = "nix-command flakes";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      vscode-extensions,
      # nixos-wsl,
      darwin,
      # devenv,
      flake-utils,
      systems,
      # nixpkgs-python,
      # pre-commit-hooks,
      # brew-nix,
      # brew-api,
      # disko,
      agenix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      username = "mslanker";
      useremail = "ms@msitp.com";
      workemail = "slanker@opstack.com";
      hostname = "${username}-nix";
      homeDirectory = nixpkgs.lib.mkForce "/home/${username}";
      stateVersion = "24.05";
      commonSpecialArgs = inputs // {
        inherit
          inputs
          outputs
          useremail
          workemail
          stateVersion
          username
          hostname
          homeDirectory
          ;
      };
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      basePackages = eachSystem (
        system: import ./environments/common/pkgs nixpkgs.legacyPackages.${system}
      );
      additionalPackages = eachSystem (system: {
        # devenv-up = self.devShells.${system}.default.config.procfileScript;
      });
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      # packages = eachSystem (system: basePackages.${system} // additionalPackages.${system});
      # formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./environments/common/overlays { inherit inputs; };

      # checks = eachSystem (system: {
      #   pre-commit-check = pre-commit-hooks.lib.${system}.run {
      #     src = ./.;
      #     hooks = {
      #       alejandra.enable = true;
      #       check-yaml.enable = true;
      #       end-of-file-fixer.enable = true;
      #       gitleaks = {
      #         enable = true;
      #         name = "gitleaks";
      #         entry = "${nixpkgs.legacyPackages.${system}.gitleaks}/bin/gitleaks detect --source . -v";
      #       };
      #     };
      #   };
      # });

      # devShells = eachSystem (system: {
      #   default = nixpkgs.legacyPackages.${system}.mkShell {
      #     inherit (self.checks.${system}.pre-commit-check) shellHook;
      #     buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      #   };
      # });

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#mslanker-wsl'
      # nixosConfigurations = {
      #   mslanker-wsl = nixpkgs.lib.nixosSystem {
      #     specialArgs =
      #       commonSpecialArgs
      #       // {
      #         hostname = "mslanker-wsl";
      #       };
      #     modules = [
      #       nixos-wsl.nixosModules.default
      #       # > Our main nixos configuration <
      #       ./environments/wsl
      #       home-manager.nixosModules.home-manager
      #       ({specialArgs, ...}: {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.extraSpecialArgs = specialArgs;
      #         home-manager.backupFileExtension = "backup"; # enable moving existing files
      #         home-manager.users.${specialArgs.username} = import ./home-manager/wsl;
      #       })
      #       agenix.nixosModules.default
      #     ];
      #   };
      # };

      # Darwin/macOS configuration entrypoint
      # Available through 'darwin-rebuild --flake .#mslanker'
      darwinConfigurations = {
        mjolnir = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = commonSpecialArgs // {
            username = "mslanker";
            hostname = "mjolnir";
            homeDirectory = nixpkgs.lib.mkForce "/Users/mslanker";
          };
          modules = [
            # > Our main darwin configuration <
            ./environments/darwin
            home-manager.darwinModules.home-manager
            (
              { specialArgs, ... }:
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.backupFileExtension = "backup"; # enable moving existing files
                home-manager.users.mslanker.imports = [
                  ./home-manager/darwin
                ];
              }
            )
            agenix.nixosModules.default
          ];
        };
      };
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    };
}
