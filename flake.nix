{
   description = "Rok's NixOS fleet";

   inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, home-manager, rust-overlay, ... }:
    let
      system = "x86_64-linux";

      mkHost = hostPath: hostName: homePath:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({ ... }: {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
              networking.hostName = hostName;
            })

            ./modules/system/base.nix
           hostPath

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.users.rok = import homePath;
            }
          ];
        };
    in {
      nixosConfigurations = {
        thinkpad = mkHost ./hosts/thinkpad/default.nix "thinkpad" ./home/rok-thinkpad.nix;
        mandarina = mkHost ./hosts/mandarina/default.nix "mandarina" ./home/rok-mandarina.nix;
        # proxman = mkHost ./hosts/proxman/default.nix "proxman" ./home/rok-proxman.nix;
      };
    };
}

