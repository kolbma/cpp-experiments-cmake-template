if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(
    FATAL_ERROR
    "custom_init: in-source builds not allowed: cmake -B build")
endif()

if(NOT CMAKE_BUILD_TYPE)
  message(STATUS "custom_init: no build type selected, default to Debug")
  set(CMAKE_BUILD_TYPE "Debug")
else()
  message(STATUS "custom_init: CMAKE_BUILD_TYPE == ${CMAKE_BUILD_TYPE}")
endif()

message(STATUS "custom_init: done")
