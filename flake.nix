{
  description = "NixOS + CachyOS kernel example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, zen-browser, ... }: {
    nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ({ pkgs, ... }: {
            
            nixpkgs.overlays = [
              nix-cachyos-kernel.overlays.default
            ];

            boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
           
            environment.systemPackages = [
              zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
          
          }
        )
      ];
    };
  };

}
