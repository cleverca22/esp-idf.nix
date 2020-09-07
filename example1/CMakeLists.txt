cmake_minimum_required(VERSION 2.6)

project(example1)

find_package(PkgConfig REQUIRED)

pkg_check_modules(DRIVER REQUIRED IMPORTED_TARGET driver freertos esp_system)
pkg_check_modules(FREERTOS REQUIRED IMPORTED_TARGET freertos)
pkg_check_modules(ESPSYSTEM REQUIRED IMPORTED_TARGET esp_system)

add_executable(example1 example1.c)

target_link_options(example1 PUBLIC "-Wl,--gc-sections")
target_link_libraries(example1 PkgConfig::FREERTOS PkgConfig::DRIVER PkgConfig::ESPSYSTEM)

include_directories(.)
