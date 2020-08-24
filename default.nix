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
    mkExample = path: name: cfg: self.callPackage ({ stdenv, cmake, python }:
    stdenv.mkDerivation {
      inherit name cfg;
      passAsFile = [ "cfg" ];
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
        cat $cfgPath >> sdkconfig
      '';
      hardeningDisable = [ "format" ];
      installPhase = ''
        mkdir -p $out/bootloader
        cp -v *-flash_args $out/
        cp -vr partition_table ${name}.{bin,elf,map} $out
        cp bootloader/bootloader.{elf,bin,map} $out/bootloader/
      '';
    }) {};
    blink = self.mkExample "examples/get-started/blink" "blink" "";
    wifi_cfg = ''
      CONFIG_ESP_WIFI_SSID="fbi surveilance van"
      CONFIG_ESP_WIFI_PASSWORD="hunter2"
    '';
    softAP = self.mkExample "examples/wifi/getting_started/softAP" "wifi_softAP" self.wifi_cfg;
  };
in {
  inherit pkgs;
  esp32 = {
    inherit (pkgs.pkgsCross.esp32) blink softAP;
  };
}
