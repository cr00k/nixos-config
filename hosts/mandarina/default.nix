{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/mandarina.nix
    ../../modules/system/nvidia.nix
    ../../modules/system/virtualization.nix
  ];
}
