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

}
