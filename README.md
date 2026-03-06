# nixos-config

Declarative NixOS configuration for ThinkPad T14 Gen2 (Intel i5 Gen11).

## Structure

```
.
├── flake.nix                    # entry point — declares inputs and outputs
├── flake.lock                   # auto-generated — pins exact versions (commit this!)
├── configuration.nix            # system-level config (hardware, services, packages)
├── hardware-configuration.nix   # auto-generated during install
└── home.nix                     # user-level config via home-manager
```

## First install

After booting into a base NixOS system:

```bash
# Clone your config from GitHub
sudo git clone https://github.com/cr00k/nixos-config ~/.config/nixos-config

# hardware-configuration.nix is already in /etc/nixos from the installer — keep it

# Edit yourname in configuration.nix and home.nix, then:
cd /etc/nixos
sudo nixos-rebuild switch --flake .#thinkpad
```

## Daily workflow

```bash
rebuild   # apply config changes  (alias defined in home.nix)
update    # update nixpkgs + home-manager + rebuild
cleanup   # remove old generations
bootclean # remove old generations from boot/GRUB

# Sync to GitHub
cd /etc/nixos && git add -A && git commit -m "update" && git push
```

> Always commit `flake.lock` — it's what makes the config reproducible.

## After first boot (manual steps)

```bash
# npm install -g @anthropic-ai/claude-code   # Claude Code CLI (use official install command!)
rustup default stable                       # Rust toolchain
rustup component add rust-analyzer clippy rustfmt
```

## Rollback

Every rebuild creates a new GRUB entry. To go back:

```bash
sudo nixos-rebuild switch --rollback
```
