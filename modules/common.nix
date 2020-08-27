{ config, lib, ... }:

{
  options.esp32_final_tree = lib.mkOption {
    default = {};
    type = lib.types.attrs;
  };
}
