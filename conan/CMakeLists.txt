cmake_minimum_required(VERSION 3.14)

project(wesnoth-conan)

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
      "Build type for Wesnoth [Debug, RelWithDebInfo, Release, MinSizeRel]"
      FORCE)
  message(STATUS "No build type was specified, will default to ${CMAKE_BUILD_TYPE}")
endif()

include(conan.cmake)

find_program(CONAN_CMD conan)

message(STATUS "Looking for a conan...")

if(CONAN_CMD)
   conan_check(VERSION 0.0.0)
endif()

conan_add_remote(NAME conancenter INDEX 0 URL https://center.conan.io)

conan_cmake_autodetect(CONAN_SETTINGS)

conan_cmake_install(PATH_OR_REFERENCE ${CMAKE_SOURCE_DIR}
        SETTINGS ${CONAN_SETTINGS}
        BUILD missing)

include(${CMAKE_BINARY_DIR}/conan_paths.cmake)

enable_testing()

# Now the environment is setup correctly, call the top level CMakeList.txt
add_subdirectory(${PROJECT_SOURCE_DIR}/.. ${CMAKE_BINARY_DIR}/wesnoth)