cmake_minimum_required(VERSION 3.20.0)
project(experiments VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# set(CMAKE_VERBOSE_MAKEFILE ON)


option(BUILD_TESTING "Build the testing tree." ON)

option(ENABLE_CATCH2_TEST "Enable Catch2)." ON)

option(ENABLE_CCACHE "Enable (s)ccache)." ON)

option(ENABLE_CLANG_TIDY "Enable to add clang tidy." ON)

option(ENABLE_COVERAGE "Enable a Code Coverage build." OFF)

option(ENABLE_CPPCHECK "Enable to add cppcheck." ON)

option(ENABLE_DOXYGEN "Enable a docs target for doxygen." ON)

option(ENABLE_FLAWFINDER "Enable to add flawfinder." ON)

option(ENABLE_LTO "Enable to add Link Time Optimization." ON)

option(ENABLE_SANITIZE_ADDR "Enable address sanitize." OFF)
option(ENABLE_SANITIZE_UNDEF "Enable undefined sanitize." OFF)
option(ENABLE_SANITIZE_LEAK "Enable leak sanitize." OFF)
option(ENABLE_SANITIZE_THREAD "Enable thread sanitize." OFF)

option(ENABLE_WARNINGS "Enable to add warnings to a target." ON)
option(ENABLE_WARNINGS_AS_ERRORS "Enable to treat warnings as errors." OFF)


list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(custom_init)


if(ENABLE_CCACHE)
  include(ccache)
endif()


include(CPM)
if(NOT CPM_SOURCE_CACHE)
  set(CPM_SOURCE_CACHE ${PROJECT_SOURCE_DIR}/.cpm_cache)
endif()
set(CPM_USE_NAMED_CACHE_DIRECTORIES ON)
message(STATUS "CPM_SOURCE_CACHE: ${CPM_SOURCE_CACHE}")



CPMAddPackage(
  NAME Format.cmake
  VERSION 1.8.1
  GITHUB_REPOSITORY TheLartians/Format.cmake
  OPTIONS
    # set to yes skip cmake formatting
    "FORMAT_SKIP_CMAKE YES"
    # set to yes skip clang formatting
    "FORMAT_SKIP_CLANG NO"
    # path to exclude (optional, supports regular expressions)
    # "CMAKE_FORMAT_EXCLUDE cmake/CPM.cmake"
    # extra arguments for cmake_format (optional)
    # "CMAKE_FORMAT_EXTRA_ARGS -c /path/to/cmake-format.{yaml,json,py}"
)

add_custom_target(apps)

include(CTest)
if(BUILD_TESTING)
  message(STATUS "add tests target")
  add_custom_target(tests)

  if(BUILD_TESTING AND ENABLE_COVERAGE AND CMAKE_BUILD_TYPE STREQUAL "Debug")
    include(coverage)
    create_coverage_targets()
    message(STATUS "coverage enabled")
  elseif(ENABLE_COVERAGE)
    set(ENABLE_COVERAGE OFF)
    message(WARNING "coverage disabled: requires testing with Debug config")
  endif()

  if(ENABLE_CATCH2_TEST)
    # CPMAddPackage("gh:catchorg/Catch2@3.6.0")
    # list(APPEND CMAKE_MODULE_PATH ${Catch2_SOURCE_DIR}/extras)

    find_package(Catch2 2 QUIET)
    if(NOT Catch2_FOUND)
      CPMAddPackage(
        NAME Catch2
        VERSION 3.6.0
        GITHUB_REPOSITORY catchorg/Catch2
        OPTIONS
          "CATCH_BUILD_TESTING OFF"
          "CATCH_BUILD_EXAMPLES OFF"
          "CATCH_INSTALL_DOCS OFF"
          "BUILD_TESTING OFF"
      )
      # list(APPEND CMAKE_MODULE_PATH ${Catch2_SOURCE_DIR}/contrib)
      list(APPEND CMAKE_MODULE_PATH ${Catch2_SOURCE_DIR}/extras)
    endif()    
    find_package(Catch2 2 REQUIRED)
  endif()
else()
  set(ENABLE_CATCH2_TEST OFF)
endif()


if(ENABLE_WARNINGS)
 include(compiler_warnings)
endif()

if(ENABLE_LTO)
  include(LTO)
endif()

if(ENABLE_SANITIZE_ADDR
   OR ENABLE_SANITIZE_UNDEF
   OR ENABLE_SANITIZE_LEAK
   OR ENABLE_SANITIZE_THREAD)
    include(sanitizer)
    add_sanitizer_flags()
endif()


if(ENABLE_CLANG_TIDY)
  include(clang-tidy)
endif()

if(ENABLE_CPPCHECK)
  include(cppcheck)
endif()

if(ENABLE_FLAWFINDER)
  include(flawfinder)
endif()


if(ENABLE_DOXYGEN)
  CPMAddPackage(gh:jothepro/doxygen-awesome-css@2.3.3)
  include(doxygen)
endif()


add_subdirectory(config)
add_subdirectory(apps)
add_subdirectory(src)


if(BUILD_TESTING)
  add_compile_definitions(BUILD_TESTING)
  enable_testing()
  add_subdirectory(tests)
endif()


set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
