{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/thinkpad.nix
  ];

  # networking.hostName = "thinkpad";
  
  boot.initrd.luks.devices."luks-4f804715-70a1-48ed-912e-f23574d0c175".device = "/dev/disk/by-uuid/4f804715-70a1-48ed-912e-f23574d0c175";
}
