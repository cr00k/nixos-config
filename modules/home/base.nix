# base.nix > base of home.nix

{ pkgs, ... }:

let
  rust = pkgs.rust-bin.stable.latest.default.override {
    targets = [ "wasm32-unknown-unknown" ];
    extensions = [ "rust-src" "clippy" "rustfmt" ];
  };
in

{
  # ─────────────────────────────────────────────
  # XDG — default applications
  # ─────────────────────────────────────────────
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html"               = "firefox.desktop";
        "x-scheme-handler/http"   = "firefox.desktop";
        "x-scheme-handler/https"  = "firefox.desktop";
        "application/pdf"         = "org.gnome.Evince.desktop";
        "image/png"               = "org.gnome.eog.desktop";
        "image/jpeg"              = "org.gnome.eog.desktop";
        "video/mp4"               = "vlc.desktop";
        "video/x-matroska"        = "vlc.desktop";
        "audio/mpeg"              = "vlc.desktop";
      };
    };
  };

  # ─────────────────────────────────────────────
  # Packages that only this user needs
  # (system-wide ones stay in configuration.nix)
  # ─────────────────────────────────────────────
  home.packages = with pkgs; [
    # CLI extras
    nix-tree       # visualise nix dependency tree
    nix-du         # disk usage of nix store
    duf            # pretty disk usage
    dust           # intuitive du
    viber
    darktable
    exercism
    adwaita-icon-theme
    hicolor-icon-theme
    rust
    gcc
    rust-analyzer
    # jetbrains.rust-rover
    lutris
    retroarch
  ];
}

