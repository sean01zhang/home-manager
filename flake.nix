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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    { nixpkgs, home-manager, nixgl, zen-browser, catppuccin, ... }:
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
    in
    {
      homeConfigurations."naesna" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          "${home-manager}/modules/misc/nixgl.nix"
          ./home.nix 
          catppuccin.homeModules.catppuccin
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit nixgl;
          inherit zen-browser;
        };
      };
    };
}
