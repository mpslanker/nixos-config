{
  description = "Slanker's Nix Config";

  inputs = {
    # Nixpkgs
    # Use `github:NixOS/nixpkgs/nixpkgs-25.05-darwin` to use Nixpkgs 25.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-25.05` to use Nixpkgs 25.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # flake-utils
    flake-utils.url = "github:numtide/flake-utils";
    # systems
    systems.url = "github:nix-systems/default";

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
      nix-darwin,
      flake-utils,
      systems,
      agenix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      username = "mslanker";
      fullname = "Matthew Slanker";
      useremail = "ms@msitp.com";
      company = "opstack";
      workemail = "slanker@opstack.com";
      hostname = "${username}-nix";
      homeDirectory = nixpkgs.lib.mkForce "/home/${username}";
      stateVersion = "24.05";
      commonSpecialArgs = inputs // {
        inherit
          inputs
          outputs
          useremail
          company
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

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#${username}-wsl'
      # nixosConfigurations = {
      #   ${username}-wsl = nixpkgs.lib.nixosSystem {
      #     specialArgs =
      #       commonSpecialArgs
      #       // {
      #         hostname = "${username}-wsl";
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
      # Available through 'darwin-rebuild --flake .#${username}'
      darwinConfigurations = {
        mjolnir = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = commonSpecialArgs // {
            username = "mslanker";
            fullname = "Matthew Slanker";
            hostname = "mjolnir";
            homeDirectory = nixpkgs.lib.mkForce "/Users/${username}";
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
                home-manager.users.${username}.imports = [
                  ./home-manager/darwin
                ];
              }
            )
            agenix.nixosModules.default
          ];
        };
        onigiri = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = commonSpecialArgs // {
            username = "mslanker";
            hostname = "onigiri";
            homeDirectory = nixpkgs.lib.mkForce "/Users/${username}";
          };
          modules = [
            # > Our main darwin configuration <
            ./environments/darwin
            # home-manager.darwinModules.home-manager
            # (
            #   { specialArgs, ... }:
            #   {
            #     home-manager.useGlobalPkgs = true;
            #     home-manager.useUserPackages = true;
            #     home-manager.extraSpecialArgs = specialArgs;
            #     home-manager.backupFileExtension = "backup"; # enable moving existing files
            #     home-manager.users.${username}.imports = [
            #       ./home-manager/darwin
            #     ];
            #   }
            # )
            # agenix.nixosModules.default
          ];
        };
      };
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    };
}
