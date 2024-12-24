{
  description = "U-boot flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        nativeBuildInputs = with pkgs; [
          gnumake
          flex
          bison
          pkg-config
          ncurses
          pkgsCross.riscv64.gcc14Stdenv.cc
          python3
          python3Packages.setuptools
          swig
          dtc
          openssl.dev
          bc
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs;

          shellHook = ''
            export CROSS_COMPILE=riscv64-unknown-linux-gnu-
            export ARCH=riscv
          '';
        };

        packages = rec {
          opensbi = pkgs.callPackage ./opensbi.nix { inherit nativeBuildInputs; };
          u-boot = pkgs.callPackage ./u-boot.nix { inherit nativeBuildInputs opensbi; };
          default = u-boot;
        };
      }
    );
}
