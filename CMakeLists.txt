cmake_minimum_required(VERSION 3.0)

find_package(Qt5 REQUIRED COMPONENTS Gui Quick)

add_subdirectory(src)

include(AndroidDeployQt.cmake)
