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
  };

  # ─────────────────────────────────────────────
  # Outputs
  # ─────────────────────────────────────────────
  outputs = { self, nixpkgs, home-manager, ... }: {

    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [

        ./configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs   = true;   # share system pkgs, no duplication
          home-manager.useUserPackages = true;
          home-manager.users.rok  = import ./home.nix;  # ← change username
        }
      ];
    };
  };
}
