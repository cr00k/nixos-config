{
  description = "ThinkPad T14 Gen2 NixOS configuration";

  # ─────────────────────────────────────────────
  # Inputs — pinned in flake.lock after first build
  # Update all:  nix flake update
  # Update one:  nix flake update nixpkgs
  # ─────────────────────────────────────────────
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";   # share nixpkgs, no duplicate
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";   # share nixpkgs, no duplicate
    };
  };

  # ─────────────────────────────────────────────
  # Outputs
  # ─────────────────────────────────────────────
  outputs = { self, nixpkgs, home-manager, fenix, ... }: 
  let      
    system = "x86_64-linux";
    pkgs   = nixpkgs.legacyPackages.${system};
    rust   = fenix.packages.${system}.combine [
      fenix.packages.${system}.stable.toolchain
      fenix.packages.${system}.targets.wasm32-unknown-unknown.stable.toolchain
    ];
  in {

    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [

        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs   = true;   # share system pkgs, no duplication
          home-manager.useUserPackages = true;
          home-manager.users.rok  = import ./home.nix;  # ← change username
        }
      ];
    };

    # ─────────────────────────────────────────────
    # Rust dev shell — run with: nix develop
    # ─────────────────────────────────────────────
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        rust            # rustc, cargo, clippy, rustfmt + wasm target
        pkgs.gcc        # linker (fixes "cc not found")
        pkgs.pkg-config
        pkgs.trunk      # build tool for Leptos/WASM
      ];

      RUST_SRC_PATH = "${rust}/lib/rustlib/src/rust/library";
    };
  };
}
