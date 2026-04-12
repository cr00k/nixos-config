{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/desktop-amd.nix
    ../../modules/system/nvidia.nix
  ];

  networking.hostName = "desktop";
}
