include(custom_target)

if(ENABLE_CATCH2_TEST)
  set(TEST_NAME multiply_tests)
  create_test(${TEST_NAME})
  target_link_libraries(${TEST_NAME} PRIVATE libb)
endif()
