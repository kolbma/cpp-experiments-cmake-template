
find_program(CPPCHECK cppcheck)
if(CPPCHECK)
  message(STATUS "add cppcheck target")
  add_custom_target(
    cppcheck)
    # COMMAND
    #   ${CPPCHECK}
    #   --check-level=exhaustive
    #   --cppcheck-build-dir=${PROJECT_SOURCE_DIR}/build
    #   --enable=all
    #   --force
    #   --inline-suppr
    #   --project=${PROJECT_SOURCE_DIR}/build/compile_commands.json
    #   --suppress=missingIncludeSystem
    # WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    # USES_TERMINAL)
  
  file(WRITE ${CMAKE_BINARY_DIR}/cppcheck-suppress "*:${CMAKE_BINARY_DIR}/*\n")
  file(APPEND ${CMAKE_BINARY_DIR}/cppcheck-suppress "*:${PROJECT_SOURCE_DIR}/.cpm_cache/*\n")
else()
  message(WARNING "cppcheck not found")
endif()

function(add_cppcheck_to_target TARGET_NAME)
  if(CPPCHECK)
    get_target_property(TARGET_SOURCES ${TARGET_NAME} SOURCES)
    list(
      FILTER
      TARGET_SOURCES
      INCLUDE
      REGEX
      ".*.(cc|h|cpp|hpp|cxx|hxx)")

    message(STATUS "add cppcheck for target: ${TARGET_NAME}")
    message(STATUS "  sources: ${TARGET_SOURCES}")
    add_custom_target(
      cppcheck-${TARGET_NAME}
      COMMAND
        ${CPPCHECK}
        --force
        --check-level=exhaustive 
        --enable=warning
        --enable=style
        --enable=performance
        --enable=portability
        # --enable=information
        --enable=missingInclude
        --suppress=missingIncludeSystem
        --suppressions-list=${CMAKE_BINARY_DIR}/cppcheck-suppress
        --inline-suppr
        --cppcheck-build-dir=${PROJECT_SOURCE_DIR}/build
        --error-exitcode=1
        -I .
        -I ${PROJECT_SOURCE_DIR}/include
        -I ${PROJECT_SOURCE_DIR}/src
        -I ${CMAKE_BINARY_DIR}/config/include
        -I ${Catch2_SOURCE_DIR}/src
        -I ${Catch2_BINARY_DIR}/generated-includes
        ${TARGET_SOURCES}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      USES_TERMINAL)

    # add_dependencies(${TARGET_NAME} cppcheck-${TARGET_NAME})
    add_dependencies(cppcheck cppcheck-${TARGET_NAME})
  else()
    message(WARNING "cppcheck not found")
  endif()
endfunction()
