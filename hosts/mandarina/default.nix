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

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/69200f38-0eb0-407a-81a9-2ea099806699";
    fsType = "ext4";
    options = [ "nofail" ];
  };

}
