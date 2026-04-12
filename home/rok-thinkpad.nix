{ ... }:

{
  imports = [
    ../modules/home/base.nix
    ../modules/home/terminal.nix
    ../modules/home/gnome-dconf.nix
    ../modules/home/thinkpad-home.nix
  ];

  home.username = "rok";
  home.homeDirectory = "/home/rok";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}



