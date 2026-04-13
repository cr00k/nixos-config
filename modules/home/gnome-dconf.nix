# gnome-dconf.nix
# GNOME preferences and dconf settings

{ lib, pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Gnome
  # ─────────────────────────────────────────────
 
  programs.gnome-shell = {
    enable = true;

    extensions = [
     {
        package = pkgs.gnomeExtensions.appindicator;
      }
      {
        package = pkgs.gnomeExtensions.blur-my-shell;
      }
    ];
  };

  # ─────────────────────────────────────────────
  # GNOME settings via dconf
  # ─────────────────────────────────────────────
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme     = "prefer-dark";
      accent-color     = "purple";
      clock-show-date  = true;
      font-name        = "IBM Plex Sans 11";
      monospace-font-name = "IBM Plex Mono 11";
      enable-animations = true;
    };
    
    "org/gnome/desktop/background" = {
      picture-uri       = "file:///home/rok/Pictures/wallpaper.jpg";
      picture-uri-dark  = "file:///home/rok/Pictures/wallpaper.jpg";
      picture-options   = "zoom";  # "zoom", "scaled", "centered", "stretched"
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,close";
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;   # disable click sounds
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
      ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 120;
    };

    "org/gnome/desktop/screensaver" = {
      lock-delay = lib.hm.gvariant.mkUint32 0;
    };
    
    "org/gnome/settings-daemon/plugins/media-keys" = {
       custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "/run/current-system/sw/bin/ghostty";
      binding = "<Alt><Ctrl>t";
    };
  };
}

