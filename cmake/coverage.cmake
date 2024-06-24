if(ENABLE_COVERAGE)
  find_program(GCOVR_PATH gcovr REQUIRED)

  function(create_coverage_targets)
    add_custom_target(coverage-clean
      COMMAND cmake -B ${CMAKE_BINARY_DIR} -P ${CMAKE_SOURCE_DIR}/cmake/coverage-cleanup.cmake)
    add_custom_target(coverage
      COMMAND ctest --test-dir ${CMAKE_BINARY_DIR}
      COMMAND ${GCOVR_PATH}
        --config ${CMAKE_SOURCE_DIR}/gcovr.cfg
        --root ${CMAKE_SOURCE_DIR}
        --object-directory=${CMAKE_BINARY_DIR}
        --txt -
        ${CMAKE_BINARY_DIR}
      COMMAND ${GCOVR_PATH}
        --config ${CMAKE_SOURCE_DIR}/gcovr.cfg
        --root ${CMAKE_SOURCE_DIR}
        --object-directory=${CMAKE_BINARY_DIR}
        --xml ${CMAKE_BINARY_DIR}/gcov/cobertura-coverage.xml
        ${CMAKE_SOURCE_DIR}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/gcov)
    add_dependencies(coverage coverage-clean apps tests)
  endfunction()

  set(GCOV_COMPILER_FLAGS -g3 -O0 --coverage)
  # set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "-lgcov" FORCE)

  # if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  #   set(WARNINGS ${CLANG_WARNINGS})
  # elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  #   set(WARNINGS ${GCC_WARNINGS})
  # endif()

  function(add_gcov_compiler_flags TARGET)
    target_compile_options(${TARGET} PUBLIC ${GCOV_COMPILER_FLAGS})
    message(STATUS "[${TARGET}] gcov compiler flags: ${GCOV_COMPILER_FLAGS}")
  endfunction()

  function(link_gcov TARGET)
    target_link_options(${TARGET} PUBLIC ${GCOV_COMPILER_FLAGS})
    target_link_libraries(${TARGET} PUBLIC gcov)
    message(STATUS "[${TARGET}] linking gcov")
  endfunction()

else()
  function(add_gcov_compiler_flags TARGET)
  endfunction()

  function(link_gcov TARGET)
  endfunction()
endif()
