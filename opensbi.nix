{
  pkgs,
  stdenv,
  nativeBuildInputs,
}:
stdenv.mkDerivation rec {
  pname = "opensbi";
  version = "v1.5.1";

  src = pkgs.fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "opensbi";
    rev = "43cace6c3671e5172d0df0a8963e552bb04b7b20";
    sha256 = "sha256-qb3orbmZJtesIBj9F2OX+BhrlctymZA1ZIbV/GVa0lU=";
  };

  buildPhase = ''
    patchShebangs scripts/Kconfiglib/defconfig.py
    patchShebangs scripts/Kconfiglib/genconfig.py
    patchShebangs scripts/carray.sh
    make
  '';

  # Environment variables for the build
  CROSS_COMPILE = "riscv64-unknown-linux-gnu-";
  PLATFORM = "generic";
  FW_PIC = "y";

  installPhase = ''
    mkdir -p $out
    install build/platform/${PLATFORM}/firmware/fw_dynamic.bin $out/fw_dynamic.bin
  '';

  inherit nativeBuildInputs;
}
