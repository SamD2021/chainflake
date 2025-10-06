{
  description = "Full nix configuration";

  inputs = {
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.follows = "nixos-cosmic/nixpkgs"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    lazyvim = {
      url = "github:/SamD2021/lazyvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      lazyvim,
      ...
    }@inputs:
    let
      darwinHost = "chainguard";
      system = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      username = "samuel.dasilva";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ];
        config = {
          allowUnfree = true;
        };
      };
      inherit (self) outputs;
    in
    {
      darwinConfigurations = {
        "${darwinHost}" = nix-darwin.lib.darwinSystem {
          system = darwinSystem;
          modules = [
            ./configuration.nix
            inputs.stylix.darwinModules.stylix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit
                    username
                    inputs
                    outputs
                    darwinSystem
                    ;
                  pkgs = nixpkgs.legacyPackages.${darwinSystem};
                };
                useUserPackages = true;
                useGlobalPkgs = true;
                backupFileExtension = "backup";
                users.${username} = import ./home.nix;
              };
            }
          ];
        };
      };
    };
}
