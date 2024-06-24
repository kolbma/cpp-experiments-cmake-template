include(custom_target)

set(TARGET_NAME experiments)
create_executable(${TARGET_NAME} main.cpp)
target_link_libraries(${TARGET_NAME} PRIVATE liba libb)
