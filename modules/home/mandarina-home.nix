# mandarina-home.nix
# Manages dotfiles, shell, editor, browser extensions, and GNOME settings

{ ... }:

{
  home.file."Pictures/wallpaper.jpg".source = ../../assets/wallpaper.jpg;

  dconf.settings = {
  "org/gnome/settings-daemon/plugins/power" = {
    sleep-inactive-ac-timeout = 0;
    sleep-inactive-battery-timeout = 0;
    power-button-action = "interactive";
  };
 };
}
