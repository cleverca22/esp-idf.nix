{ ssid ? "", password ? "" }:

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
    libraries = cfg: self.callPackage ({ stdenv, cmake, findutils, python, esptool }:
    stdenv.mkDerivation {
      name = "esp-idf-${esp-idf.rev}";
      inherit cfg;
      passAsFile = [ "cfg" ];
      src = esp-idf;
      patches = [ ./change.patch ];
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
        echo CONFIG_SDK_TOOLCHAIN_SUPPORTS_TIME_WIDE_64_BITS=y > sdkconfig
        cat $cfgPath >> sdkconfig
      '';
      hardeningDisable = [ "format" ];
      includeDirs = [
        "components/app_trace/include"
        "components/app_trace/sys_view/Config"
        "components/app_trace/sys_view/SEGGER"
        "components/app_update/include"
        "components/asio/port/include"
        "components/bootloader_support/include"
        "components/bootloader_support/include_bootloader"
        "components/bt/common/btc/include"
        "components/bt/common/include"
        "components/bt/common/osi/include"
        "components/bt/esp_ble_mesh/api/core/include"
        "components/bt/esp_ble_mesh/api/models/include"
        "components/bt/esp_ble_mesh/btc/include"
        "components/bt/esp_ble_mesh/mesh_common/include"
        "components/bt/esp_ble_mesh/mesh_common/tinycrypt/include"
        "components/bt/esp_ble_mesh/mesh_core/include"
        "components/bt/esp_ble_mesh/mesh_models/client/include"
        "components/bt/esp_ble_mesh/mesh_models/common/include"
        "components/bt/esp_ble_mesh/mesh_models/server/include"
        "components/bt/host/bluedroid/api/include"
        "components/bt/host/bluedroid/bta/ar/include"
        "components/bt/host/bluedroid/bta/av/include"
        "components/bt/host/bluedroid/bta/dm/include"
        "components/bt/host/bluedroid/bta/gatt/include"
        "components/bt/host/bluedroid/bta/hf_ag/include"
        "components/bt/host/bluedroid/bta/hf_client/include"
        "components/bt/host/bluedroid/bta/hh/include"
        "components/bt/host/bluedroid/bta/include"
        "components/bt/host/bluedroid/bta/jv/include"
        "components/bt/host/bluedroid/bta/sdp/include"
        "components/bt/host/bluedroid/bta/sys/include"
        "components/bt/host/bluedroid/btc/include"
        "components/bt/host/bluedroid/btc/profile/esp/blufi/include"
        "components/bt/host/bluedroid/btc/profile/esp/include"
        "components/bt/host/bluedroid/btc/profile/std/a2dp/include"
        "components/bt/host/bluedroid/btc/profile/std/battery/include"
        "components/bt/host/bluedroid/btc/profile/std/dis/include"
        "components/bt/host/bluedroid/btc/profile/std/hid/include"
        "components/bt/host/bluedroid/btc/profile/std/include"
        "components/bt/host/bluedroid/btc/profile/std/smp/include"
        "components/bt/host/bluedroid/common/include"
        "components/bt/host/bluedroid/device/include"
        "components/bt/host/bluedroid/external/sbc/decoder/include"
        "components/bt/host/bluedroid/external/sbc/encoder/include"
        "components/bt/host/bluedroid/external/sbc/plc/include"
        "components/bt/host/bluedroid/hci/include"
        "components/bt/host/bluedroid/stack/a2dp/include"
        "components/bt/host/bluedroid/stack/avct/include"
        "components/bt/host/bluedroid/stack/avdt/include"
        "components/bt/host/bluedroid/stack/avrc/include"
        "components/bt/host/bluedroid/stack/btm/include"
        "components/bt/host/bluedroid/stack/gap/include"
        "components/bt/host/bluedroid/stack/gatt/include"
        "components/bt/host/bluedroid/stack/include"
        "components/bt/host/bluedroid/stack/l2cap/include"
        "components/bt/host/bluedroid/stack/rfcomm/include"
        "components/bt/host/bluedroid/stack/sdp/include"
        "components/bt/host/bluedroid/stack/smp/include"
        "components/bt/host/nimble/esp-hci/include"
        "components/bt/host/nimble/port/include"
        "components/bt/include"
        "components/cbor/port/include"
        "components/coap/port/include"
        "components/driver/esp32/include"
        "components/driver/include"
        "components/driver/include/driver"
        "components/driver/test/include"
        "components/driver/test/param_test/include"
        "components/driver/test/touch_sensor_test/include"
        "components/efuse/esp32/include"
        "components/efuse/include"
        "components/efuse/test/include"
        "components/esp32/include"
        "components/esp_adc_cal/include"
        "components/esp_common/include"
        "components/espcoredump/include"
        "components/espcoredump/include_core_dump"
        "components/esp_eth/include"
        "components/esp_event/include"
        "components/esp_gdbstub/include"
        "components/esp_hid/include"
        "components/esp_http_client/include"
        "components/esp_http_client/lib/include"
        "components/esp_http_server/include"
        "components/esp_https_ota/include"
        "components/esp_https_server/include"
        "components/esp_ipc/include"
        "components/esp_local_ctrl/include"
        "components/esp_netif/include"
        "components/esp_ringbuf/include"
        "components/esp_rom/include"
        "components/esp_serial_slave_link/include"
        "components/esp_system/include"
        "components/esp_system/port/include"
        "components/esp_timer/include"
        "components/esp_websocket_client/include"
        "components/esp_wifi/esp32/include"
        "components/esp_wifi/include"
        "components/expat/port/include"
        "components/freemodbus/common/include"
        "components/freemodbus/modbus/include"
        "components/freertos/include"
        "components/freertos/xtensa/include"
        "components/heap/include"
        "components/idf_test/include"
        "components/jsmn/include"
        "components/libsodium/port_include"
        "components/log/include"
        "components/lwip/include"
        "components/lwip/port/esp32/include"
        "components/lwip/lwip/src/include"
        "components/lwip/include/apps"
        "components/lwip/include/apps/dhcpserver"
        "components/lwip/include/apps/ping"
        "components/lwip/include/apps/sntp"
        "components/mbedtls/esp_crt_bundle/include"
        "components/mbedtls/port/include"
        "components/mdns/include"
        "components/newlib/platform_include"
        "components/nghttp/port/include"
        "components/nvs_flash/include"
        "components/openssl/include"
        "components/perfmon/include"
        "components/protocomm/include"
        "components/pthread/include"
        "components/sdmmc/include"
        "components/soc/include"
        "components/soc/soc/esp32/include"
        "components/soc/soc/include"
        "components/soc/src/esp32/include"
        "components/spiffs/include"
        "components/spi_flash/include"
        "components/tcpip_adapter/include"
        "components/tcp_transport/include"
        "components/tinyusb/additions/include"
        "components/ulp/include"
        "components/ulp/ulp_riscv/include"
        "components/unity/include"
        "components/vfs/include"
        "components/wear_levelling/include"
        "components/wear_levelling/private_include"
        "components/wifi_provisioning/include"
        "components/wpa_supplicant/include"
        "components/wpa_supplicant/port/include"
        "components/xtensa/esp32/include"
        "components/xtensa/include"
      ];
      # FIXME: maybe remove partition_table
      installPhase = ''
        mkdir -pv $out/binary
        cp -v *-flash_args $out/binary
        cp -vr partition_table/partition-table.bin $out/binary
        cp bootloader/bootloader.{elf,bin,map} $out/binary
        mkdir -pv $out/lib
        for archive in $(find . -name '*.a'); do
            cp -v "$archive" $out/lib/
        done
        mkdir -pv $out/include
        cp -v config/sdkconfig.h $out/include/
        for include in $includeDirs; do
            cp -r ../../../../$include/* $out/include/
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
  esp32 = {
    libraries = pkgs.pkgsCross.esp32.libraries "";
    inherit (pkgs.pkgsCross.esp32) blink softAP websocket wifi_station helloworld;
  };
}
