{
  pkgs,
  stdenv,
  nativeBuildInputs,
  opensbi,
}:
stdenv.mkDerivation {
  pname = "u-boot";
  version = "";

  inherit nativeBuildInputs;

  src = ./.;

  postPatch = ''
    patchShebangs .
  '';

  configurePhase = ''
    make uconsole_defconfig
  '';

  installPhase = ''
    mkdir -p $out
    install u-boot-sunxi-with-spl.bin $out/
  '';

  # Environment variables for the build
  CROSS_COMPILE = "riscv64-unknown-linux-gnu-";
  OPENSBI = "${opensbi}/fw_dynamic.bin";
}
