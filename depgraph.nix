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
      include_dirs = ["components/esp_rom/include"];
      priv_include_dirs = ["esp32"];
      priv_requires = ["soc"];
      requires = [];
      extraLinkFlags = [ "-T" "esp32/ld/esp32.rom.syscalls.ld" ];
    };
    esp_serial_slave_link = {
      include_dirs = ["components/esp_serial_slave_link/include"];
      priv_requires = [];
      requires = ["sdmmc" "driver"];
    };
    esp_system = {
      include_dirs = ["components/esp_system/include"];
      priv_requires = [
        "spi_flash"
        "app_update"
        "nvs_flash"
        "pthread"
        "app_trace"
      ];
      requires = [];
      extraLinkFlags = [ "-u" "start_app" ] ++ lib.optionals (!config.ESP_SYSTEM_SINGLE_CORE_MODE) [ "-u" "start_app_other_cores" ]
    };
    esp_timer = {
      include_dirs = ["components/esp_timer/include"];
      priv_requires = ["soc" "driver" "esp32"];
      requires = ["esp_common"];
    };
    esp_websocket_client = {
      include_dirs = ["components/esp_websocket_client/include"];
      priv_requires = ["esp_timer"];
      requires = ["lwip" "esp-tls" "tcp_transport" "nghttp"];
    };
    esp_wifi = {
      include_dirs = ["components/esp_wifi/include" "components/esp_wifi/esp32/include"];
      priv_requires = ["wpa_supplicant" "nvs_flash" "esp_netif"];
      requires = ["esp_event"];
      # todo: linker.lf and CONFIG_ESP32_NO_BLOBS
      # todo CONFIG_ESP32_PHY_INIT_DATA_IN_PARTITION effects partition table
    };
    espcoredump = {
      include_dirs = ["components/espcoredump/include"];
      priv_requires = ["spi_flash" "app_update" "mbedtls" "esp_rom" "soc"];
      requires = [];
    };
    esptool_py = {
      include_dirs = [];
      priv_requires = [];
      requires = ["bootloader"];
    };
    expat = {
      include_dirs = ["components/expat/expat/expat/lib" "components/expat/port/include"];
      priv_requires = [];
      requires = [];
    };
    fatfs = {
      include_dirs = ["components/fatfs/diskio" "components/fatfs/vfs" "components/fatfs/src"];
      priv_requires = [];
      requires = ["wear_levelling" "sdmmc"];
    };
    freemodbus = {
      include_dirs = ["components/freemodbus/common/include"];
      priv_requires = [];
      requires = ["driver"];
    };
    freertos = {
      include_dirs = ["components/freertos/include" "components/freertos/xtensa/include"];
      priv_requires = ["soc"];
      requires = ["app_trace" "esp_timer"];
    };
    heap = {
      include_dirs = ["components/heap/include"];
      priv_include_dirs = [];
      priv_requires = ["soc"];
      requires = [];
      extraLinkFlags = lib.optionals config.HEAP_TRACING (map (f: "-Wl,--wrap=${f}") [ "calloc" "malloc" "free" "realloc" "heap_caps_malloc" "heap_caps_free" "heap_caps_realloc" "heap_caps_malloc_default" "heap_caps_realloc_default");
    };
    idf_test = {
      include_dirs = ["components/idf_test/include" "components/idf_test/include/esp32"];
      priv_requires = [];
      requires = [];
    };
    jsmn = {
      include_dirs = ["components/jsmn/include"];
      priv_requires = [];
      requires = [];
      cflags = lib.optional config.JSMN_PARENT_LINKS "-DJSMN_PARENT_LINKS" ++
        lib.optional config.JSMN_STRICT "-DJSMN_STRICT";
    };
    json = {
      include_dirs = ["components/json/cJSON"];
      priv_requires = [];
      requires = [];
    };
    libsodium = {
      include_dirs = ["components/libsodium/libsodium/src/libsodium/include" "components/libsodium/port_include"];
      priv_requires = [];
      requires = ["mbedtls"];
    };
    log = {
      include_dirs = ["components/log/include"];
      priv_requires = ["soc"];
      requires = [];
    };
    lwip = {
      include_dirs = [
        "components/lwip/include/apps"
        "components/lwip/include/apps/sntp"
        "components/lwip/lwip/src/include"
        "components/lwip/port/esp32/include"
        "components/lwip/port/esp32/include/arch"
      ];
      priv_requires = ["esp_eth" "esp_netif" "tcpip_adapter" "nvs_flash"];
      requires = ["vfs" "esp_wifi"];
    };
    mbedtls = {
      include_dirs = ["components/mbedtls/port/include" "components/mbedtls/mbedtls/include" "components/mbedtls/esp_crt_bundle/include"];
      priv_requires = ["soc"];
      requires = ["lwip"];
    };
    mdns = {
      include_dirs = ["components/mdns/include"];
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
      include_dirs = ["components/newlib/platform_include"];
      priv_requires = ["soc"];
      requires = [];
      # todo: esp32-spiram-rom-functions-c.lf and CONFIG_SPIRAM_CACHE_WORKAROUND
      #todo --specs=nano.specs and CONFIG_NEWLIB_NANO_FORMAT
    };
    nghttp = {
      include_dirs = ["components/nghttp/port/include" "components/nghttp/nghttp2/lib/includes"];
      priv_requires = [];
      requires = [];
    };
    nvs_flash = {
      include_dirs = ["components/nvs_flash/include"];
      priv_requires = [];
      requires = ["spi_flash" "mbedtls"];
    };
    openssl = {
      include_dirs = ["components/openssl/include"];
      priv_requires = [];
      requires = ["mbedtls"];
    };
    partition_table = {
      include_dirs = [];
      priv_requires = [];
      requires = [];
    };
    perfmon = {
      include_dirs = ["components/perfmon/include"];
      priv_requires = [];
      requires = ["xtensa"];
    };
    protobuf-c = {
      include_dirs = ["components/protobuf-c/protobuf-c"];
      priv_requires = [];
      requires = [];
    };
    protocomm = {
      include_dirs = ["components/protocomm/include/common" "components/protocomm/include/security" "components/protocomm/include/transports"];
      priv_requires = ["protobuf-c" "mbedtls" "console" "esp_http_server"];
      requires = ["bt"];
    };
    pthread = {
      include_dirs = ["components/pthread/include"];
      priv_requires = [];
      requires = [];
      extraLinkFlags = [ "-u" "pthread_include_pthread_impl" ] ++
        if config.FREERTOS_ENABLE_STATIC_TASK_CLEAN_UP then
          [ "-Wl,--wrap=vPortCleanUpTCB" ]
        else
          [ "-u" "pthread_include_pthread_cond_impl" "-u" "pthread_include_pthread_local_storage_impl" ];
      ;
    };
    sdmmc = {
      include_dirs = ["components/sdmmc/include"];
      priv_requires = ["soc"];
      requires = ["driver"];
    };
    soc = {
      include_dirs = [];
      priv_requires = ["esp32"];
      requires = [];
    };
    spi_flash = {
      include_dirs = ["components/spi_flash/include"];
      priv_requires = ["bootloader_support" "app_update" "soc" "esp_ipc"];
      requires = [];
    };
    spiffs = {
      include_dirs = ["components/spiffs/include"];
      priv_requires = ["bootloader_support"];
      requires = ["spi_flash"];
    };
    tcp_transport = {
      include_dirs = ["components/tcp_transport/include"];
      priv_requires = [];
      requires = ["lwip" "esp-tls"];
    };
    tcpip_adapter = {
      include_dirs = ["components/tcpip_adapter/include"];
      priv_requires = [];
      requires = ["esp_netif"];
    };
    tinyusb = {
      include_dirs = [];
      priv_requires = [];
      requires = lib.optionals config.USB_ENABLED ["esp_rom" "freertos" "vfs" "soc"];
    };
    ulp = {
      include_dirs = ["components/ulp/include"];
      priv_requires = [];
      requires = [];
    };
    unity = {
      include_dirs = ["components/unity/include" "components/unity/unity/src"];
      priv_requires = [];
      requires = [];
    };
    vfs = {
      include_dirs = ["components/vfs/include"];
      priv_requires = [];
      requires = [];
    };
    wear_levelling = {
      include_dirs = ["components/wear_levelling/include"];
      priv_requires = [];
      requires = ["spi_flash"];
    };
    wifi_provisioning = {
      include_dirs = ["components/wifi_provisioning/include"];
      priv_requires = ["protobuf-c" "bt" "mdns" "json" "esp_timer"];
      requires = ["lwip" "protocomm"];
    };
    wpa_supplicant = {
      include_dirs = ["components/wpa_supplicant/include" "components/wpa_supplicant/port/include" "components/wpa_supplicant/include/esp_supplicant"];
      priv_requires = ["mbedtls" "esp_timer"];
      requires = [];
    };
    xtensa = {
      include_dirs = ["components/extensa/include" "components/xtensa/esp32/include"];
      priv_requires = ["soc" "freertos"];
      requires = [];
    };
  };
in {
  inherit pkgs lib spec;
}
