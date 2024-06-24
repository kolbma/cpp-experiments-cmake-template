#include "liba/a.hpp"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("sum 1 + 1", "[sum]") {
    // cppcheck-suppress unreadVariable
    const auto sum1 = sum(1, 1);
    REQUIRE(sum1 == 2);
}
