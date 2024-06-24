include(coverage)

function(include_directories_default TARGET_NAME)
  target_include_directories(${TARGET_NAME} PRIVATE . 
    ${PROJECT_SOURCE_DIR}/include 
    ${PROJECT_SOURCE_DIR}/src 
    ${CMAKE_BINARY_DIR}/config/include)
endfunction()

function(create_checks TARGET_NAME)
  if(ENABLE_CLANG_TIDY)
    add_clang_tidy_to_target(${TARGET_NAME})
  endif()

  if(ENABLE_CPPCHECK)
    add_cppcheck_to_target(${TARGET_NAME})
  endif()
endfunction()

function(create_executable)
  set(TARGET_NAME ${ARGV0})
  list(SUBLIST ARGV 1 -1 ARGV_LIST)
  add_executable(${TARGET_NAME} ${ARGV_LIST})
  include_directories_default(${TARGET_NAME})

  if(ENABLE_WARNINGS)
    target_set_warnings(
      TARGET
      ${TARGET_NAME}
      ENABLE
      ${ENABLE_WARNINGS}
      AS_ERRORS
      ${ENABLE_WARNINGS_AS_ERRORS})
  endif()

  if(ENABLE_LTO)
    target_enable_lto(
      TARGET
      ${TARGET_NAME}
      ENABLE
      ON)
  endif()

  add_gcov_compiler_flags(${TARGET_NAME})
  link_gcov(${TARGET_NAME})

  create_checks(${TARGET_NAME})

  add_dependencies(apps ${TARGET_NAME})
endfunction()

function(create_library)
  set(TARGET_NAME ${ARGV0})
  list(SUBLIST ARGV 1 -1 SOURCE_LIST)
  add_library(${TARGET_NAME}_obj OBJECT ${SOURCE_LIST})
  include_directories_default(${TARGET_NAME}_obj)
  add_library(${TARGET_NAME} $<TARGET_OBJECTS:${TARGET_NAME}_obj>)

  if(ENABLE_WARNINGS)
    target_set_warnings(
      TARGET
      ${TARGET_NAME}
      ENABLE
      ${ENABLE_WARNINGS}
      AS_ERRORS
      ${ENABLE_WARNINGS_AS_ERRORS})
  endif()

  if(ENABLE_LTO)
    target_enable_lto(
      TARGET
      ${TARGET_NAME}
      ENABLE
      ON)
  endif()

  add_gcov_compiler_flags(${TARGET_NAME}_obj)
  link_gcov(${TARGET_NAME}_obj)
  add_gcov_compiler_flags(${TARGET_NAME})
  link_gcov(${TARGET_NAME})

  create_checks(${TARGET_NAME}_obj)
endfunction()

function(create_test TEST_NAME)
  add_library(${TEST_NAME}_obj OBJECT ${TEST_NAME}.cpp)
  add_executable(${TEST_NAME} $<TARGET_OBJECTS:${TEST_NAME}_obj>)
  include_directories_default(${TEST_NAME}_obj)
  if(ENABLE_CATCH2_TEST)
    target_include_directories(${TEST_NAME}_obj PRIVATE 
      ${Catch2_SOURCE_DIR}/src
      ${Catch2_BINARY_DIR}/generated-includes)
  endif()

  if(${ENABLE_WARNINGS})
    target_set_warnings(
      TARGET
      ${TEST_NAME}_obj
      ENABLE
      ${ENABLE_WARNINGS}
      AS_ERRORS
      ${ENABLE_WARNINGS_AS_ERRORS})
  endif()

  if(ENABLE_LTO)
    target_enable_lto(
      TARGET
      ${TEST_NAME}_obj
      ENABLE
      ON)
  endif()

  if(ENABLE_LTO)
    target_enable_lto(
      TARGET
      ${TEST_NAME}
      ENABLE
      ON)
  endif()

  add_gcov_compiler_flags(${TEST_NAME}_obj)
  add_gcov_compiler_flags(${TEST_NAME})
  link_gcov(${TEST_NAME})

  create_checks(${TEST_NAME}_obj)

  if(${ENABLE_CATCH2_TEST})
    target_link_libraries(${TEST_NAME} PRIVATE Catch2::Catch2WithMain)
    catch_discover_tests(${TEST_NAME})
  endif()

  add_dependencies(tests ${TEST_NAME})
endfunction()
