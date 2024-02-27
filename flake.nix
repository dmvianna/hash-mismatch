{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, nixos-generators, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        config = {
          allowUnfree = true;
        };

        pkgs = import nixpkgs {
          inherit config system;
        };
      in {
        packages = {
          example = nixos-generators.nixosGenerate {
            system = "x86_64-linux";
            pkgs = pkgs;
            format = "gce";

            modules = [
              ./example.nix
            ];
          };
        };
      }
    );
}
