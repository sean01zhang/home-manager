{
  description = "Home Manager configuration of naesna";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs and NixGL.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL/pull/195/head";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    { nixpkgs, home-manager, nixgl, catppuccin, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ 
          nixgl.overlay
        ];
        config = {
          allowUnfree = true; # Allow unfree packages
        };
      };
      pkgs-mac = import nixpkgs {
	system = "aarch64-darwin";
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      homeConfigurations."seanspc" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          "${home-manager}/modules/misc/nixgl.nix"
          ./hosts/seanspc/default.nix
          catppuccin.homeModules.catppuccin
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit nixgl;
        };
      };

      homeConfigurations."vw" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./hosts/vw/default.nix
          catppuccin.homeModules.catppuccin
        ];
      };

      homeConfigurations."mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-mac;

        modules = [
          ./hosts/mbp/default.nix
          catppuccin.homeModules.catppuccin
        ];
      };
    };
}
