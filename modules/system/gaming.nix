# modules/system/gaming.nix
{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
    steam-run
    retroarch-full

  ];
}
