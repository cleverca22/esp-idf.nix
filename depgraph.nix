let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { config = {}; overlays = []; };
  inherit (pkgs) lib;

  config = {};
  spec = {
    app_trace = {
      include_dirs = [
        "components/app_trace/include"
      ] ++ lib.optionals config.SYSVIEW_ENABLE [
        "components/app_trace/sys_view/Config"
        "components/app_trace/sys_view/SEGGER"
        "components/app_trace/sys_view/Sample/OS"
      ];
      priv_include_dirs = [];
      priv_requires = ["soc"];
      requires = [];
    };
    app_update = {
      include_dirs = ["components/app_update/include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["spi_flash" "partition_table" "bootloader_support"];
    };
    asio = {
      include_dirs = [
        "components/asio/asio/asio/include"
        "components/asio/port/include"
      ];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["lwip"];
      # target_link_libraries
    };
    bootloader = {
      include_dirs = [];
      priv_include_dirs = [];
      priv_requires = ["partition_table"];
      requires = [];
    };
    bootloader_support = {
      include_dirs = ["include"];
      priv_include_dirs = ["include_bootloader"];
      priv_requires = ["spi_flash" "mbedtls" "efuse"];
      requires = ["soc"];
    };
    bt = {
      include_dirs = [];
      priv_include_dirs = [];
      priv_requires = ["esp_ipc"];
      requires = ["nvs_flash" "soc" "esp_timer"];
    };
    cbor = {
      include_dirs = ["port/include"];
      priv_include_dirs = ["tinycbor/src"];
      priv_requires = [];
      requires = [];
    };
    coap = {
      include_dirs = [
        "port/include"
        "port/include/coap"
        "libcoap/include"
        "libcoap/include/coap2"
      ];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["lwip" "mbedtls"];
    };
    console = {
      include_dirs = ["."];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["vfs"];
    };
    cxx = {
      include_dirs = [];
      priv_include_dirs = [];
      priv_requires = ["pthread"];
      requires = [];
    };
    driver = {
      include_dirs = ["include" "esp32/include"];
      priv_include_dirs = ["include/driver"];
      priv_requires = ["efuse" "esp_timer" "esp_ipc"];
      requires = ["esp_ringbuf" "freertos" "soc"];
    };
    efuse = {
      include_dirs = ["include" "esp32/include"];
      priv_include_dirs = ["private_include"];
      priv_requires = ["bootloader_support" "soc" "spi_flash"];
      requires = [];
    };
    esp-tls = {
      include_dirs = ["."];
      priv_include_dirs = ["private_include"];
      priv_requires = ["lwip" "nghttp"];
      requires = ["mbedtls"];
    };
    esp32 = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [
        "app_trace"
        "app_update"
        "bootloader_support"
        "esp_system"
        "log"
        "mbedtls"
        "nvs_flash"
        "pthread"
        "spi_flash"
        "vfs"
        "espcoredump"
        "esp_common"
        "perfmon"
        "esp_timer"
        "esp_ipc"
      ];
      requires = ["driver" "efuse" "soc"];
    };
    esp_adc_cal = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["driver" "efuse"];
    };
    esp_common = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = ["soc"];
      requires = ["esp32" "espcoredump" "esp_timer" "esp_ipc"];
    };
    esp_eth = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = ["driver" "log" "esp_netif"];
      requires = ["esp_event"];
    };
    esp_event = {
      include_dirs = ["include"];
      priv_include_dirs = ["private_include"];
      priv_requires = ["esp_eth" "esp_timer"];
      requires = ["log" "esp_netif"];
    };
    esp_gdbstub = {
      include_dirs = ["include"];
      priv_include_dirs = ["private_include" "esp32" "xtensa"];
      priv_requires = ["soc" "xtensa" "esp_rom"];
      requires = ["freertos"];
    };
    esp_hid = {
      include_dirs = ["include"];
      priv_include_dirs = ["private"];
      priv_requires = [];
      requires = ["esp_event" "bt"];
    };
    esp_http_client = {
      include_dirs = ["include"];
      priv_include_dirs = ["lib/include"];
      priv_requires = ["mbedtls" "lwip" "esp-tls" "tcp_transport"];
      requires = ["nghttp"];
    };
    esp_http_server = {
      include_dirs = ["include"];
      priv_include_dirs = ["src/port/esp32" "src/util"];
      priv_requires = ["lwip" "mbedtls" "esp_timer"];
      requires = ["nghttp"];
    };
    esp_https_ota = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = ["log" "app_update"];
      requires = ["esp_http_client" "bootloader_support"];
    };
    esp_https_server = {
      include_dirs = [];
      priv_include_dirs = [];
      priv_requires = ["lwip"];
      requires = ["esp_http_server" "esp-tls"];
    };
    esp_ipc = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    esp_local_ctrl = {
      include_dirs = ["include"];
      priv_include_dirs = ["proto-c" "src" "../protocomm/proto-c"];
      priv_requires = ["protobuf-c" "mdns"];
      requires = ["protocomm" "esp_https_server"];
    };
    esp_netif = {
      include_dirs = ["include"];
      priv_include_dirs = ["lwip" "private_include"];
      priv_requires = [];
      requires = ["lwip" "esp_eth" "tcpip_adapter"];
    };
    esp_ringbuf = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    esp_rom = {
      include_dirs = ["include"];
      priv_include_dirs = ["esp32"];
      priv_requires = ["soc"];
      requires = [];
    };
    esp_serial_slave_link = {
      include_dirs = ["include"];
      priv_include_dirs = ["." "include/esp_serial_slave_link"];
      priv_requires = [];
      requires = ["sdmmc" "driver"];
    };
    esp_system = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [
        "spi_flash"
        "app_update"
        "nvs_flash"
        "pthread"
        "app_trace"
      ];
      requires = [];
    };
    esp_timer = {
      include_dirs = ["include"];
      priv_include_dirs = ["private_include"];
      priv_requires = ["soc" "driver" "esp32"];
      requires = ["esp_common"];
    };
    esp_websocket_client = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = ["esp_timer"];
      requires = ["lwip" "esp-tls" "tcp_transport" "nghttp"];
    };
    esp_wifi = {
      include_dirs = ["include" "esp32/include"];
      priv_include_dirs = [];
      priv_requires = ["wpa_supplicant" "nvs_flash" "esp_netif"];
      requires = ["esp_event"];
    };
    espcoredump = {
      include_dirs = ["include"];
      priv_include_dirs = ["include_core_dump"];
      priv_requires = ["spi_flash" "app_update" "mbedtls" "esp_rom" "soc"];
      requires = [];
    };
    esptool_py = {
      include_dirs = [];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["bootloader"];
    };
    expat = {
      include_dirs = ["expat/expat/lib" "port/include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    fatfs = {
      include_dirs = ["diskio" "vfs" "src"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["wear_levelling" "sdmmc"];
    };
    freemodbus = {
      include_dirs = ["common/include"];
      priv_include_dirs = [
        "common"
        "port"
        "modbus"
        "modbus/ascii"
        "modbus/functions"
        "modbus/rtu"
        "modbus/tcp"
        "modbus/include"
        "serial_slave/port"
        "serial_slave/modbus_controller"
        "serial_master/port"
        "serial_master/modbus_controller"
        "tcp_slave/port"
        "tcp_slave/modbus_controller"
        "tcp_master/port"
        "tcp_master/modbus_controller"
      ];
      priv_requires = [];
      requires = ["driver"];
    };
    freertos = {
      include_dirs = ["include" "xtensa/include"];
      priv_include_dirs = [
        "include/freertos"
        "xtensa/include/freertos"
        "xtensa"
        "."
      ];
      priv_requires = ["soc"];
      requires = ["app_trace" "esp_timer"];
    };
    heap = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = ["soc"];
      requires = [];
    };
    idf_test = {
      include_dirs = ["include" "include/esp32"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    jsmn = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    json = {
      include_dirs = ["cJSON"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    libsodium = {
      include_dirs = ["libsodium/src/libsodium/include" "port_include"];
      priv_include_dirs = [
        "libsodium/src/libsodium/include/sodium"
        "port_include/sodium"
        "port"
      ];
      priv_requires = [];
      requires = ["mbedtls"];
    };
    log = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = ["soc"];
      requires = [];
    };
    lwip = {
      include_dirs = [
        "include/apps"
        "include/apps/sntp"
        "lwip/src/include"
        "port/esp32/include"
        "port/esp32/include/arch"
      ];
      priv_include_dirs = [];
      priv_requires = ["esp_eth" "esp_netif" "tcpip_adapter" "nvs_flash"];
      requires = ["vfs" "esp_wifi"];
    };
    mbedtls = {
      include_dirs = ["port/include" "mbedtls/include" "esp_crt_bundle/include"];
      priv_include_dirs = [];
      priv_requires = ["soc"];
      requires = ["lwip"];
    };
    mdns = {
      include_dirs = ["include"];
      priv_include_dirs = ["private_include"];
      priv_requires = ["esp_timer"];
      requires = ["lwip" "console" "esp_netif"];
    };
    mqtt = {
      include_dirs = ["esp-mqtt/include"];
      priv_include_dirs = ["esp-mqtt/lib/include"];
      priv_requires = [];
      requires = ["lwip" "nghttp" "mbedtls" "tcp_transport"];
    };
    newlib = {
      include_dirs = ["platform_include"];
      priv_include_dirs = ["priv_include"];
      priv_requires = ["soc"];
      requires = [];
    };
    nghttp = {
      include_dirs = ["port/include" "nghttp2/lib/includes"];
      priv_include_dirs = ["private_include"];
      priv_requires = [];
      requires = [];
    };
    nvs_flash = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["spi_flash" "mbedtls"];
    };
    openssl = {
      include_dirs = ["include"];
      priv_include_dirs = [
        "include/internal"
        "include/platform"
        "include/openssl"
      ];
      priv_requires = [];
      requires = ["mbedtls"];
    };
    partition_table = {
      include_dirs = [];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    perfmon = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["xtensa"];
    };
    protobuf-c = {
      include_dirs = ["protobuf-c"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    protocomm = {
      include_dirs = ["include/common" "include/security" "include/transports"];
      priv_include_dirs = ["proto-c" "src/common"];
      priv_requires = ["protobuf-c" "mbedtls" "console" "esp_http_server"];
      requires = ["bt"];
    };
    pthread = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    sdmmc = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = ["soc"];
      requires = ["driver"];
    };
    soc = {
      include_dirs = [];
      priv_include_dirs = [];
      priv_requires = ["esp32"];
      requires = [];
    };
    spi_flash = {
      include_dirs = ["include"];
      priv_include_dirs = ["private_include"];
      priv_requires = ["bootloader_support" "app_update" "soc" "esp_ipc"];
      requires = [];
    };
    spiffs = {
      include_dirs = ["include"];
      priv_include_dirs = ["." "spiffs/src"];
      priv_requires = ["bootloader_support"];
      requires = ["spi_flash"];
    };
    tcp_transport = {
      include_dirs = ["include"];
      priv_include_dirs = ["private_include"];
      priv_requires = [];
      requires = ["lwip" "esp-tls"];
    };
    tcpip_adapter = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["esp_netif"];
    };
    tinyusb = {
      include_dirs = [];
      priv_include_dirs = [];
      priv_requires = [];
      requires = ["esp_rom" "freertos" "vfs" "soc"];
    };
    ulp = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    unity = {
      include_dirs = ["include" "unity/src"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    vfs = {
      include_dirs = ["include"];
      priv_include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    wear_levelling = {
      include_dirs = ["include"];
      priv_include_dirs = ["private_include"];
      priv_requires = [];
      requires = ["spi_flash"];
    };
    wifi_provisioning = {
      include_dirs = ["include"];
      priv_include_dirs = ["src" "proto-c" "../protocomm/proto-c"];
      priv_requires = ["protobuf-c" "bt" "mdns" "json" "esp_timer"];
      requires = ["lwip" "protocomm"];
    };
    wpa_supplicant = {
      include_dirs = ["include" "port/include" "include/esp_supplicant"];
      priv_include_dirs = ["src"];
      priv_requires = ["mbedtls" "esp_timer"];
      requires = [];
    };
    xtensa = {
      include_dirs = ["include" "esp32/include"];
      priv_include_dirs = [];
      priv_requires = ["soc" "freertos"];
      requires = [];
    };
  };
in {
  inherit pkgs lib spec;
}
