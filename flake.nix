{
  description = "Bore tunnel server NixOS module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {self, nixpkgs}: let
    lib = nixpkgs.lib;
  in {
    nixosModules.bore-server = import ./bore.nix {
      inherit lib;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    };
  };
}
