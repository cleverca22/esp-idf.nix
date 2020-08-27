{ config, lib, ... }:

let
  cfg = config.esp32;
in {
  options = {
    esp32.rev.min = lib.mkOption {
      type = lib.types.enum [ 0 1 2 3 ];
    };
    esp32.xtal.freq = lib.mkOption {
      type = lib.types.enum [ "auto" 26 40 ];
      apply = x: if (x == "auto") then 0 else x;
    };
  };
  config = {
    esp32_final_tree = {
      ESP32_XTAL_FREQ = cfg.xtal.freq;
      ESP32_XTAL_FREQ_AUTO = cfg.xtal.freq == 0;
      ESP32_XTAL_FREQ_40 = cfg.xtal.freq == 40;
      ESP32_XTAL_FREQ_26 = cfg.xtal.freq == 26;
      ESP32_REV_MIN_0 = cfg.rev.min == 0;
      ESP32_REV_MIN_1 = cfg.rev.min == 1;
      ESP32_REV_MIN_2 = cfg.rev.min == 2;
      ESP32_REV_MIN_3 = cfg.rev.min == 3;
    };
  };
}
