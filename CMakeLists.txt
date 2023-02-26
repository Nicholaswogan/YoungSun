cmake_minimum_required(VERSION "3.14")

project(YOUNGSUN LANGUAGES Fortran)

option(SKBUILD "Should be ON of being build by skbuild, 
and OFF of being build by regular cmake" OFF)

if (NOT CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE STREQUAL "")
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# lsoda
add_library(youngsun SHARED 
  YoungSun/SunFlux.f90
)
set_target_properties(youngsun PROPERTIES PREFIX "lib")

if (SKBUILD)
  install(TARGETS youngsun DESTINATION YoungSun)
else()
  install(TARGETS youngsun DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/YoungSun/)
endif()
