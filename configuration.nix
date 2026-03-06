# NixOS Configuration — system-level
# Hardware: ThinkPad T14 Gen2 — Intel Core i5 Gen11 (Tiger Lake)
# Desktop:  GNOME + Wayland
#
# User-level config (shell, editor, browser, dotfiles) lives in home.nix
#
# Deploy:  sudo nixos-rebuild switch --flake .#thinkpad

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-4f804715-70a1-48ed-912e-f23574d0c175".device = "/dev/disk/by-uuid/4f804715-70a1-48ed-912e-f23574d0c175";
  networking.hostName = "thinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # Enable wireguard
  networking.wireguard.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Ljubljana";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sl_SI.UTF-8";
    LC_IDENTIFICATION = "sl_SI.UTF-8";
    LC_MEASUREMENT = "sl_SI.UTF-8";
    LC_MONETARY = "sl_SI.UTF-8";
    LC_NAME = "sl_SI.UTF-8";
    LC_NUMERIC = "sl_SI.UTF-8";
    LC_PAPER = "sl_SI.UTF-8";
    LC_TELEPHONE = "sl_SI.UTF-8";
    LC_TIME = "sl_SI.UTF-8";
  };

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

  # Configure console keymap
  console.keyMap = "slovene";

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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
  services.fwupd.enable    = true;   # Firmware updates via LVFS

  # ─────────────────────────────────────────────
  # Bluetooth & Printing
  # ─────────────────────────────────────────────
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };
  services.printing.enable = true;

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
  # Nix settings
  # ─────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
  };
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };
  nixpkgs.config.allowUnfree = true;   # Required for Viber and some drivers

  # ─────────────────────────────────────────────
  # System packages
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # ── Core utilities ──────────────────────────
    git
    curl
    wget
    fastfetch
    btop
    unzip
    p7zip
    ripgrep        # fast grep (rg)
    fd             # fast find
    bat            # cat with syntax highlighting
    eza            # modern ls
    fzf            # fuzzy finder
    jq             # JSON processor
    tree
    xdg-utils
    man-pages

    # ── Terminal & shell ────────────────────────
    ghostty
    tmux

    # ── Editor ──────────────────────────────────
    neovim
    nodejs_24      # many Neovim LSP / Treesitter plugins need Node

    # ── Browser ─────────────────────────────────
    firefox
    chromium

    # ── Development — Rust ──────────────────────
    rustup         # manages rustc, cargo, rust-analyzer, clippy, etc.
                   # after install: rustup default stable
    pkg-config     # needed by many Rust crates
    openssl

    # ── Development — JavaScript ─────────────────
    nodejs_24
    pnpm
    yarn

    # ── Claude Code CLI ──────────────────────────
    # Install via npm after boot:  npm install -g @anthropic-ai/claude-code
    # (not yet in nixpkgs; npm global works fine)

    # ── Version control extras ──────────────────
    gh             # GitHub CLI
    lazygit        # TUI for git

    # ── Office & creative ───────────────────────
    libreoffice-fresh
    inkscape
    gimp
    blender
    
    # ── Privacy & downloads ─────────────────────
    tor-browser
    transmission_4-gtk
    wireguard-tools

    # ── Communication ───────────────────────────
    viber          # allowUnfree = true required
    jitsi-meet-electron

    # ── Media ───────────────────────────────────
    vlc
    ffmpeg

    # ── GNOME tweaks & extensions ────────────────
    gnome-tweaks
    gnomeExtensions.appindicator   # system tray icons (Viber, etc.)
    gnomeExtensions.blur-my-shell

    # ── System utilities ────────────────────────
    brightnessctl
    powertop
    usbutils
    pciutils
  ];

  # ─────────────────────────────────────────────
  # Programs with module-level configuration
  # ─────────────────────────────────────────────
  programs.firefox = {
    enable = true;
  };

  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
    ];
  };

  # ─────────────────────────────────────────────
  # User account
  # ─────────────────────────────────────────────
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rok = {
    isNormalUser = true;
    description = "rok";
    extraGroups = [ 
      "wheel"           # sudo
      "networkmanager"
      "video"
      "audio"
      "input"
      "lp"              # printing
    ];
  };

  # ─────────────────────────────────────────────
  # XDG portals (screen sharing, Wayland clipboard, etc.)
  # ─────────────────────────────────────────────
  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # ─────────────────────────────────────────────
  # Security & Firewall
  # ─────────────────────────────────────────────
  security.sudo.wheelNeedsPassword = true;
  services.openssh.enable = false;   # no SSH server on a laptop

  networking.firewall = {
    enable          = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };
  
  # ─────────────────────────────────────────────
  # DO NOT change stateVersion after first install
  # ─────────────────────────────────────────────
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
