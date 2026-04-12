# nixos-config

Declarative, multi-host NixOS configuration managed with Nix flakes and home-manager.

## Hosts

| Host | Hardware | GPU | Notes |
|------|----------|-----|-------|
| `thinkpad` | ThinkPad T14 Gen2 — Intel i5 Gen11 | Intel Xe (integrated) | LUKS encryption, TLP power management |
| `mandarina` | AMD Ryzen 9 7945HX3D desktop | NVIDIA (stable driver) | KVM/QEMU virtualization |

## Structure

```
.
├── flake.nix                        # entry point — inputs, outputs, mkHost helper
├── flake.lock                       # pins exact dependency versions (always commit this)
├── hosts/
│   ├── thinkpad/
│   │   ├── default.nix              # ThinkPad system config
│   │   └── hardware-configuration.nix
│   └── mandarina/
│       ├── default.nix              # Mandarina system config
│       └── hardware-configuration.nix
├── modules/
│   ├── system/
│   │   ├── base.nix                 # common: boot, network, locale, packages, user
│   │   ├── gnome.nix                # GNOME + GDM + fonts + XDG portals
│   │   ├── audio.nix                # PipeWire (replaces PulseAudio)
│   │   ├── thinkpad.nix             # Intel microcode, TLP, battery thresholds
│   │   ├── mandarina.nix            # AMD microcode, redistributable firmware
│   │   ├── nvidia.nix               # NVIDIA modesetting + open-source driver
│   │   └── virtualization.nix       # KVM, libvirtd, QEMU, virt-manager
│   └── home/
│       ├── base.nix                 # XDG defaults, common user packages, Rust toolchain
│       ├── terminal.nix             # bash, tmux, Ghostty, Neovim (full LSP setup)
│       ├── gnome-dconf.nix          # GNOME theme, extensions, keybindings
│       ├── thinkpad-home.nix        # touchpad, power, display settings
│       └── mandarina-home.nix       # SSH config, wallpaper
├── home/
│   ├── rok-thinkpad.nix             # home-manager entry for thinkpad
│   └── rok-mandarina.nix            # home-manager entry for mandarina
└── assets/
    ├── wallpaper.jpg
    └── monitors-thinkpad.xml
```

## First install

Boot into a base NixOS installer, then:

```bash
# Clone the config
sudo git clone https://github.com/cr00k/nixos-config /mnt/home/rok/.config/nixos-config

# Generate hardware configuration (if not already in repo)
sudo nixos-generate-config --root /mnt

# Copy generated hardware-configuration.nix into the appropriate host directory
sudo cp /mnt/etc/nixos/hardware-configuration.nix \
  /mnt/home/rok/.config/nixos-config/hosts/<hostname>/hardware-configuration.nix

# Build and switch (run from the config directory)
cd /mnt/home/rok/.config/nixos-config
sudo nixos-rebuild switch --flake .#thinkpad   # or .#mandarina
```

## Daily workflow

Shell aliases defined in `modules/home/terminal.nix`:

```bash
rb-thinkpad    # nixos-rebuild switch --flake ~/.config/nixos-config#thinkpad
rb-mandarina   # nixos-rebuild switch --flake ~/.config/nixos-config#mandarina
update-flake   # nix flake update (updates flake.lock)
bclean         # remove old boot generations
cleanup        # nix-collect-garbage -d

# Sync to GitHub
cd ~/.config/nixos-config && git add -A && git commit -m "update" && git push
```

> Always commit `flake.lock` — it pins dependency versions and makes the config reproducible.

## After first boot

```bash
# Rust toolchain (rust-overlay provides the toolchain, but set the default channel)
rustup default stable
rustup target add wasm32-unknown-unknown
rustup component add rust-analyzer clippy rustfmt
```

## Rollback

Every rebuild creates a new boot entry. To roll back:

```bash
sudo nixos-rebuild switch --rollback
# or select a previous generation from the systemd-boot menu at startup
```

## Key features

- **Neovim** — fully configured with LSP (Rust, TypeScript, Lua, Nix), treesitter, telescope, lazy.nvim
- **Ghostty** — IBM Plex Mono, Tokyo Night theme, transparency/blur
- **Tmux** — session resurrection + continuum auto-save every 15 min
- **GNOME** — minimal install, dark/purple theme, blur-my-shell, appindicator, Alt+Ctrl+T for terminal
- **ThinkPad power** — TLP with battery thresholds 20–85%, thermald, battery percentage in taskbar
- **Mandarina virtualization** — libvirtd + QEMU + SPICE, virbr0 trusted in firewall
