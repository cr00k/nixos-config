# General GNOME setup
# Hardware: Any
# Desktop:  GNOME + Wayland

{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;          # was: services.xserver.displayManager.gdm.enable
  services.desktopManager.gnome.enable = true;        # was: services.xserver.desktopManager.gnome.enable

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "si";
    variant = "";
  };

  # Strip GNOME apps you will not use
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany       # GNOME Web (using Firefox)
    geary          # GNOME Mail
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-weather
    gnome-music
    totem          # GNOME Videos (using VLC)
  ];

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # ─────────────────────────────────────────────
  # Fonts
  # ─────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code        # Terminal / Neovim
    nerd-fonts.jetbrains-mono
    inter                       # Clean UI font
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji	# was: noto-fonts-emoji
    liberation_ttf
    ibm-plex
  ];
  fonts.fontconfig.defaultFonts = {
    monospace = [ "IBM Plex Mono" ];
    sansSerif = [ "IBM Plex Sans" ];
  };

  # ─────────────────────────────────────────────
  # System packages
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];

  # ─────────────────────────────────────────────
  # Programs with module-level configuration
  # ─────────────────────────────────────────────
  programs.firefox = {
    enable = true;
  };
  
  # ─────────────────────────────────────────────
  # XDG portals (screen sharing, Wayland clipboard, etc.)
  # ─────────────────────────────────────────────
  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

}
