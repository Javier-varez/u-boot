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
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gnumake
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
          shellHook = ''
            export CROSS_COMPILE=riscv64-unknown-linux-gnu-
            export ARCH=riscv
          '';
        };
      }
    );
}
