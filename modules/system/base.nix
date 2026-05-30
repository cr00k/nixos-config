# NixOS Configuration — BASE
# Hardware: Any
# Desktop:  GNOME + Wayland

{ pkgs, ... }:

{
  
  # Bootloader - check if is Thinkpad specific
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # NTFS support
  boot.supportedFilesystems = [ "ntfs" ];
  system.fsPackages = [ pkgs.ntfs3g ];

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

  # Configure console keymap
  console.keyMap = "slovene";

  # ─────────────────────────────────────────────
  # Bluetooth & Printing
  # ─────────────────────────────────────────────
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };

  services.printing.enable = true;
  services.fwupd.enable = true; # check

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
    unrar
    p7zip
    zip
    ripgrep        # fast grep (rg)
    fd             # fast find
    bat            # cat with syntax highlighting
    eza            # modern ls
    fzf            # fuzzy finder
    jq             # JSON processor
    tree
    xdg-utils
    man-pages
    # nslookup
    kdePackages.kleopatra
    screen 

    # ── Terminal & shell ────────────────────────
    ghostty
    tmux

    # ── Editor ──────────────────────────────────
    neovim
    nodejs_24      # many Neovim LSP / Treesitter plugins need Node

    # ── Browser ─────────────────────────────────
    chromium

    # ── Development — Rust ──────────────────────
    #rustup        # manages rustc, cargo, rust-analyzer, clippy, etc.
                   # after install: rustup default stable
    pkg-config     # needed by many Rust crates
    openssl

    # ── Development — JavaScript ─────────────────
    pnpm
    yarn
    python3


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
    # darktable
    blender
    krita
    aseprite


    
    # ── Privacy & downloads ─────────────────────
    tor-browser
    transmission_4-gtk
    wireguard-tools

    # ── Communication ───────────────────────────
    # viber          # allowUnfree = true required
    jitsi-meet-electron

    # ── Media ───────────────────────────────────
    vlc
    ffmpeg
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly   # includes mp4/h264 support
    gst_all_1.gst-libav          # ffmpeg codecs

    # ── System utilities ────────────────────────
    usbutils
    pciutils
    file-roller
  ];

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
      "dialout"
    ];
  };

  # ─────────────────────────────────────────────
  # Security & Firewall
  # ─────────────────────────────────────────────
  security.sudo.wheelNeedsPassword = true;
  # services.openssh.enable = false;   # no SSH server on a machines

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
