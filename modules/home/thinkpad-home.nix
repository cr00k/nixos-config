# thinkpad-home.nix
# Manages dotfiles, shell, editor, browser extensions, and GNOME settings

{ ... }:

{
  home.file.".config/monitors.xml" = {
    source = ../../assets/monitors-thinkpad.xml;
    force = true;
  };
  home.file."Pictures/wallpaper.jpg".source = ../../assets/wallpaper.jpg;

  # ─────────────────────────────────────────────
  # GNOME settings via dconf
  # ─────────────────────────────────────────────
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click     = true;
      two-finger-scrolling-enabled = true;
      natural-scroll   = true;
      speed            = 0.2;
    };

    # Power
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-battery-timeout = 900;   # 15 min
      sleep-inactive-ac-timeout      = 3600;  # 1 hr
      power-button-action            = "suspend";
    };
  };
}





