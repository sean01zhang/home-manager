{ config, pkgs, ... }:

{
  imports = [ ../common.nix ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "user";
  home.homeDirectory = "/home/user";

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [

  ];
}
