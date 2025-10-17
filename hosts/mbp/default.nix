{ config, pkgs, ... }:

{
  imports = [ ../common.nix ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "work";
  home.homeDirectory = "/Users/work";

  home.packages = with pkgs; [

  ];
  catppuccin.nvim.enable = false;
}
