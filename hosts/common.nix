{ config, pkgs, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.


  # # The home.packages option allows you to install Nix packages into your
  # # environment.
  # home.packages = with pkgs; [
  #   git
  #   htop
  #   go
  #   fzf
  #   ripgrep
  #
  #   neovim
  #   tmux
  #
  #   # # It is sometimes useful to fine-tune packages, for example, by applying
  #   # # overrides. You can do that directly here, just don't forget the
  #   # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  #   # # fonts?
  #   # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  #
  #   # # You can also create simple shell scripts directly inside your
  #   # # configuration. For example, this adds a command 'my-hello' to your
  #   # # environment:
  #   # (pkgs.writeShellScriptBin "my-hello" ''
  #   #   echo "Hello, ${config.home.username}!"
  #   # '')
  # ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/naesna/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {

  };

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      "1"="cd ..";
      "2"="cd ../..";
      "3"="cd ../../../";
      "dotfiles"="cd ~/git/dotfiles";
      "g"="git";
      "m12"="hyprctl keyword monitor \"DP-4,preferred,auto,1.2\"";
      "m10"="hyprctl keyword monitor \"DP-4,preferred,auto,1.0\"";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  
    defaultCommand = "rg --files";

    defaultOptions = [
      "--height 60%"
      "--tmux center"
      "--layout reverse"
      "--border"
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ../files/nvim/init.lua;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.fish}/bin/fish";
    mouse = true;
    escapeTime = 0;
    extraConfig = builtins.readFile ../files/tmux/tmux.conf;
    clock24 = true;
  };
  catppuccin.tmux.enable = true;

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;
}
