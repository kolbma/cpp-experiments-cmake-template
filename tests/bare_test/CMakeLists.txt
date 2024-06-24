include(custom_target)

if(BUILD_TESTING)
  set(TEST_NAME bare_test)
  create_test(${TEST_NAME})
  add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
  # target_link_libraries(${TEST_NAME} PRIVATE liba)
endif()
