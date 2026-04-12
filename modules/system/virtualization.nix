{ pkgs, ... }:

{
  boot.kernelModules = [ "kvm-amd" ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  programs.virt-manager.enable = true;

  users.users.rok.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    qemu
    dnsmasq
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
