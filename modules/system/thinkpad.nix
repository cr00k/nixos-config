# NixOS Configuration — Thinkpad specific
# Hardware: ThinkPad T14 Gen2 — Intel Core i5 Gen11 (Tiger Lake)
# Desktop:  GNOME + Wayland

{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Hardware — ThinkPad T14 Gen2 specifics
  # ─────────────────────────────────────────────
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;   # Intel WiFi / BT firmware

  # Intel Xe (Tiger Lake integrated GPU)
  hardware.graphics = {
    enable        = true;
    enable32Bit   = true;
    extraPackages = with pkgs; [
      intel-media-driver   # VAAPI hardware video decode (iHD)
      intel-vaapi-driver  # was: vaapiIntel
      libva-vdpau-driver  # was: vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # ThinkPad power management
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC  = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      # Charge thresholds — protect battery longevity
      START_CHARGE_THRESH_BAT0 = 20;
      STOP_CHARGE_THRESH_BAT0  = 85;
    };
  };
  services.power-profiles-daemon.enable = false;   # conflicts with tlp
  services.thermald.enable = true;   # Intel thermal management
  
  # ─────────────────────────────────────────────
  # System packages
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # ── System utilities ────────────────────────
    brightnessctl
    powertop
  ];
}
