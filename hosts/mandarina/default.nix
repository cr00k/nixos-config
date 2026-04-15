{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/mandarina.nix
    ../../modules/system/nvidia.nix
    ../../modules/system/virtualization.nix
    ../../modules/system/gaming.nix
    ../../modules/system/ollama.nix
  ];
}
