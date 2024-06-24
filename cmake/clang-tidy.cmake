
find_program(CLANGTIDY clang-tidy)
if(CLANGTIDY)
  # set(CMAKE_CXX_CLANG_TIDY ${CLANGTIDY} -p build)

  message(STATUS "add clang-tidy target")
  add_custom_target(
    clang-tidy)
    # COMMAND
    #   ${CMAKE_CXX_CLANG_TIDY}
    #   ${TARGET_SOURCES}
    #   --
    #   -I .
    #   -I ${PROJECT_SOURCE_DIR}/include
    #   -I ${PROJECT_SOURCE_DIR}/src
    #   -I ${CMAKE_BINARY_DIR}/config/include
    #   -I ${Catch2_SOURCE_DIR}/src
    #   -I ${Catch2_BINARY_DIR}/generated-includes
    # WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    # USES_TERMINAL)
else()
  message(WARNING "clang-tidy not found")
endif()

function(add_clang_tidy_to_target TARGET_NAME)
  if(CLANGTIDY)
    get_target_property(TARGET_SOURCES ${TARGET_NAME} SOURCES)
    list(
      FILTER
      TARGET_SOURCES
      INCLUDE
      REGEX
      ".*.(cc|h|cpp|hpp|cxx|hxx)")

    message(STATUS "add clang-tidy for target: ${TARGET_NAME}")
    message(STATUS "  sources: ${TARGET_SOURCES}")
    add_custom_target(
      clang-tidy-${TARGET_NAME}
      COMMAND
        ${CLANGTIDY}
        -p build
        ${TARGET_SOURCES}
        --
        -I .
        -I ${PROJECT_SOURCE_DIR}/include
        -I ${PROJECT_SOURCE_DIR}/src
        -I ${CMAKE_BINARY_DIR}/config/include
        -I ${Catch2_SOURCE_DIR}/src
        -I ${Catch2_BINARY_DIR}/generated-includes
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      USES_TERMINAL)
    
    # add_dependencies(${TARGET_NAME} clang-tidy-${TARGET_NAME})
    add_dependencies(clang-tidy clang-tidy-${TARGET_NAME})
  else()
    message(WARNING "clang-tidy not found")
  endif()
endfunction()
