{ config, pkgs, nixgl, ... }:

{

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "naesna";
  home.homeDirectory = "/home/naesna";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  targets.genericLinux.enable = true;
  
  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "nvidia";
  nixGL.installScripts = ["nvidia"];
  

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    (config.lib.nixGL.wrap pkgs.ghostty)

    (config.lib.nixGL.wrap pkgs.discord)
    git
    htop
    go
    kdePackages.dolphin
    loupe
    signal-desktop
    fzf
    ripgrep
    rofi-wayland
    fastfetch

    waybar
    dunst
    libnotify

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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
    # EDITOR = "emacs";
    NIXPKGS_ALLOW_UNFREE = "1"; # Allow unfree packages
    NIXGL_REQUIRE = "1"; # Enable NixGL
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

  programs.ghostty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.ghostty;
    settings = {
      theme = "catppuccin-mocha";
      window-padding-x = 10;
      window-padding-y = 10;
      font-size = 10;
      background-opacity = 0.9;
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        padding = {
          top = 0;
        };
        source = "~/Pictures/capoo.png";
        type = "kitty-icat"; # kitty-icat works well inside of tmux. kitty gets a bit weird if used directly.
        width = 32;
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "bios"
        "bootmgr"
        "board"
        "kernel"
        "initsystem"
        "uptime"
        "loadavg"
        "processes"
        "packages"
        "shell"
        "editor"
        "display"
        "lm"
        "de"
        "wm"
        "terminal"
        "terminalsize"
        {
          type = "cpu";
          showPeCoreCount = true;
          temp = true;
        }
        {
          type = "gpu";
          driverSpecific = true;
          temp = true;
        }
        "memory"
        "physicalmemory"
        {
          type = "swap";
          separate = true;
        }
        "disk"
        "datetime"
        "vulkan"
        "opengl"
        "opencl"
        "sound"
        "camera"
        "break"
        "colors"
      ];
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.ghostty}/bin/ghostty";

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      element = {
        padding = mkLiteral "0.3em";
      };

      window = {
        padding = mkLiteral "0.8em";
        "border-radius" = mkLiteral "6px";
        border = 4;
        "border-color" = mkLiteral "#f1c7ff";
      };

      inputbar = {
        padding = mkLiteral "0.3em";
      };

      listview = {
        border = mkLiteral "none";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./files/nvim/init.lua;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.fish}/bin/fish";
    mouse = true;
    escapeTime = 0;
    extraConfig = builtins.readFile ./files/tmux/tmux.conf;
    clock24 = true;
  };
  catppuccin.tmux.enable = true;


  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        margin = "0 10 0 10"; # top right bottom left
        spacing = 0;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "temperature"
          "memory"
          "mpris"
          "tray"
        ];

        "hyprland/workspaces" = {
          all-outputs = true; # show workspaces on all monitors
          format = "{name}";
        };

        "hyprland/window" = {
          format = "{class}";
          separate-outputs = true; # for multi-monitor setups
        };

        "hyprland/submap" = {
          format = "{}";
          always-on = false;
        };

        clock = {
          format = "{:%A, %b %d %R}";
          calendar = {
            mode = "year";
            mode-mon-col = 4;
            format = {
              months = "<b>{}</b>";
              weekdays = "<b>{}</b>";
              today = "<span background='#ff0000'><b>{}</b></span>";
            };
          };
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          tooltip = true;
        };

        cpu = {
          format = "CPU {usage}%";
          interval = 5;
          tooltip = false;
        };

        memory = {
          format = "MEM {used}/{total}G";
          interval = 5;
          tooltip = false;
        };
        
        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon3";
          format = "{temperatureC}°C";
        };
        
        mpris = {
          format = "{player_icon} {dynamic}";
          dynamic-len = 20;
          player-icons = {
            spotify = "";
            default = "🎜";
            firefox = "";
          };
        };

        tray = {
          spacing = 4;
        };
      };
    };
    style = builtins.readFile ./files/waybar/style.css;
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        corner_radius = 8;
        frame_color = "#f1c7ff";
        origin = "top-right";
        font = "Noto Sans Mono 10";
        frame_width = 4;
        gap_size = 10;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./files/hypr/hyprland.conf;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Pictures/wallpaper.jpg"
        "~/Pictures/wallpaper2.jpg"
      ];

      wallpaper = {
        "DP-4" = "~/Pictures/wallpaper2.jpg";
      };
    };
  };

  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

}
