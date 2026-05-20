# NixOS Configuration — Mandarina
# Hardware: AMD Ryzen 9 7945HX3D
# Desktop:  GNOME + Wayland

{ ... }:

{
  # ─────────────────────────────────────────────
  # Hardware — AMD Ryzen 9 7945HX3D
  # ─────────────────────────────────────────────
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  services.gnome.gcr-ssh-agent.enable = true;
  
  # ─────────────────────────────────────────────
  # XMrig specifics
  # ─────────────────────────────────────────────
  boot.kernelModules = [ "msr" ]; # for xmrig
  boot.kernel.sysctl."vm.nr_hugepages" = 1280;
  boot.kernelParams = [ "hugepagesz=1G" "hugepages=3" ];

  # ─────────────────────────────────────────────
  # SSH Service
  # ─────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;   # key-only, no passwords
      PermitRootLogin = "no";           # no direct root login
    };
  };

  users.users.rok.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWhZVXKyYeRm2pSTaaHED4l+79ZyX8agz6A9T8j2/eT rok@thinkpad"
  ];
}
