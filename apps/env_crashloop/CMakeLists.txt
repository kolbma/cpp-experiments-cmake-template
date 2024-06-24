include(custom_target)

set(TARGET_NAME env_crashloop)
create_executable(${TARGET_NAME} env_crashloop.cpp)
target_link_libraries(${TARGET_NAME} PRIVATE pthread)
