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

  xdg.desktopEntries.virt-manager-dark = {
    name = "Virtual Machine Manager (Dark)";
    genericName = "Virtual Machine Manager";
    exec = "env GTK_THEME=Adwaita:dark virt-manager";
    terminal = false;
    categories = [ "System" ];
    icon = "virt-manager";
  };
}
