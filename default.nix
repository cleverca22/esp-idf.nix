{ ssid ? "", password ? "" }:

# { echo '['; find /path/to/source/components/ -name '*.json' | grep '__idf_' | xargs cat | sed 's/}/},/g'; echo ']'; } | json-strip-trailing-commas | jq 'map(del(.ldfragments)) | map(.include_dirs = (.include_dirs | split(";"))) | map(.priv_include_dirs = (.priv_include_dirs | split(";"))) | map(.requires = (.requires | split(";"))) | map(.priv_requires = (.priv_requires | split(";"))) | map(.name = (.alias | ltrimstr("idf::")) | del(.alias))'
# pkgs.lib.listToAttrs (map (obj: { name = obj.name; value = builtins.removeAttrs obj ["name"]; }) (builtins.fromJSON (builtins.readFile ./esp-idf.json)))

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { config = {}; overlays = [ overlay ]; };
  inherit (pkgs) lib;
  esp-idf = pkgs.fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf";
    rev = "6c17e3a64c02eff3a4f726ce4b7248ce11810833";
    sha256 = "1cp5qv4v2vkm447ppa7nv8wkxbn3cnb28r5h7qfdck1mf84wy88v";
    fetchSubmodules = true;
  };

  spec = (import ./depgraph.nix).spec;

  interspace = lib.concatStringsSep " ";

  toPc = name: attrs: lib.concatStrings (map (x: x + "\n") (lib.concatLists [
    ["Name: ${name}"]
    (lib.optional (attrs.trans_requires != []) ("Requires: " + interspace attrs.trans_requires))
    (lib.optional (attrs.priv_requires  != []) ("Requires.private: " + interspace attrs.priv_requires))
    ["Libs: ${interspace (["-l${name}"] ++ (attrs.lflags or []))}"]
    (lib.optional (attrs.include_dirs != []) "Cflags: -I@out@/include")
  ]));

  pcFiles = lib.mapAttrs toPc spec;

  generateSDKConfig = cfg: "";
  overlay = self: super: {
    mkLibrary = component: self.callPackage ({ stdenv, cmake, findutils, python, esptool }:
    stdenv.mkDerivation {
      name = "esp-idf-${component}-${esp-idf.rev}";
      cfg = generateSDKConfig (self.config.esp32 or "");
      pcFile = pcFiles.${component};
      passAsFile = [ "cfg" "pcFile" ];
      src = esp-idf;
      patches = [ ./change.patch ];
      makeFlags = "__idf_${component}/fast";
      nativeBuildInputs = [
        cmake
        findutils
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
        cd examples/get-started/blink
        echo CONFIG_SDK_TOOLCHAIN_SUPPORTS_TIME_WIDE_64_BITS=y >> sdkconfig
        echo CONFIG_BT_ENABLED=y >> sdkconfig
        echo CONFIG_USB_ENABLED=y >> sdkconfig
        echo CONFIG_ESP_HTTPS_SERVER_ENABLE=y >> sdkconfig
        cat $cfgPath >> sdkconfig
      '';
      hardeningDisable = [ "format" ];
      # FIXME: maybe remove partition_table
      installPhase = ''
        mkdir -pv $out/lib
        for archive in $(find . -name '*.a'); do
            cp -v "$archive" $out/lib/
        done
        mkdir -pv $out/lib/pkgconfig
        substituteAll "$pcFilePath" "$out/lib/pkgconfig/${component}.pc"
        mkdir -pv $out/include
        for include in ${interspace spec.${component}.include_dirs}; do
            if test -n "$(ls ../../../../$include)"; then
                cp -r ../../../../$include/* $out/include/
            fi
        done
      '';
    }) {};

    mkExample = path: name: cfg: self.callPackage ({ stdenv, cmake, python, esptool }:
    stdenv.mkDerivation {
      inherit name cfg;
      passAsFile = [ "cfg" ];
      src = esp-idf;
      patches = [ ./change.patch ];
      nativeBuildInputs = [
        cmake
        python
        (python.__spliced.buildBuild.withPackages (p: with p; [
          pip
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
        cat <<EOF > $out/flashit
        #!$shell
        cd $out
        ${esptool.__spliced.buildBuild}/bin/esptool.py -p /dev/ttyUSB0 -b 115200 --chip esp32 write_flash \
          --flash_mode dio --flash_size detect --flash_freq 40m \
          $(cat app-flash_args | tail -n1) \
          $(cat bootloader-flash_args | tail -n1) \
          $(cat partition_table-flash_args | tail -n1)
        EOF
        chmod +x $out/flashit
      '';
    }) {};
    blink = self.mkExample "examples/get-started/blink" "blink" "";
    wifi_cfg = ''
      CONFIG_ESP_WIFI_SSID="fbi-surveilance-van"
      CONFIG_ESP_WIFI_PASSWORD="hunter2hunter2"
      CONFIG_ESP32_XTAL_FREQ=26
      CONFIG_ESP32_XTAL_FREQ_26=y
      CONFIG_ESP32_XTAL_FREQ_40=n
    '';
    station_cfg = ''
      CONFIG_ESP_WIFI_SSID="${ssid}"
      CONFIG_ESP_WIFI_PASSWORD="${password}"
      CONFIG_ESP32_XTAL_FREQ_26=y
      CONFIG_ESP32_XTAL_FREQ_40=n
    '';
    websocket_cfg = ''
      CONFIG_WEBSOCKET_URI_FROM_STRING=y
      CONFIG_WEBSOCKET_URI_FROM_STDIN=n
      CONFIG_WEBSOCKET_URI="ws://echo.websocket.org"
      CONFIG_EXAMPLE_WIFI_SSID="${ssid}"
      CONFIG_EXAMPLE_WIFI_PASSWORD="${password}"
      CONFIG_ESP32_XTAL_FREQ_26=y
      CONFIG_ESP32_XTAL_FREQ_40=n
    '';
    softAP = self.mkExample "examples/wifi/getting_started/softAP" "wifi_softAP" self.wifi_cfg;
    helloworld = self.mkExample "examples/get-started/hello_world" "hello-world" "";
    wifi_station = self.mkExample "examples/wifi/getting_started/station" "wifi_station" self.station_cfg;
    websocket = self.mkExample "examples/protocols/websocket" "websocket-example" self.websocket_cfg;
  };
in {
  inherit toPc spec pkgs lib;
  esp32 = {
    libraries = lib.listToAttrs
                (map (k: { name = k; value = pkgs.pkgsCross.esp32.mkLibrary k; })
                 (lib.filter (x: spec.${x}.enable or true) (lib.attrNames spec)));
    inherit (pkgs.pkgsCross.esp32) blink softAP websocket wifi_station helloworld;
  };
}
