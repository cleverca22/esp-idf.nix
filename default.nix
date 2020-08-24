let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { config = {}; overlays = [ overlay ]; };
  esp-idf = pkgs.fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf";
    rev = "6c17e3a64c02eff3a4f726ce4b7248ce11810833";
    fetchSubmodules = true;
    sha256 = "1cp5qv4v2vkm447ppa7nv8wkxbn3cnb28r5h7qfdck1mf84wy88v";
  };
  overlay = self: super: {
    mkExample = path: name: self.callPackage ({ stdenv, cmake, python }:
    stdenv.mkDerivation {
      inherit name;
      src = esp-idf;
      patches = [ ./change.patch ];
      nativeBuildInputs = [
        cmake
        python
        (python.__spliced.buildBuild.withPackages (p: with p; [
          future
          pyserial
          cryptography
        ]))
      ];
      allowSubstitutes = false;
      preConfigure = ''
        export IDF_PATH=$(pwd)
        cd ${path}
        echo CONFIG_SDK_TOOLCHAIN_SUPPORTS_TIME_WIDE_64_BITS=y > sdkconfig
      '';
      hardeningDisable = [ "format" ];
      installPhase = ''
        mkdir $out
        cp -v *-flash_args $out/
        cp -vr bootloader partition_table ${name}.bin $out
      '';
    }) {};
    blink = self.mkExample "examples/get-started/blink" "blink";
  };
in {
  inherit pkgs;
  esp32 = {
    inherit (pkgs.pkgsCross.esp32) blink;
  };
}
