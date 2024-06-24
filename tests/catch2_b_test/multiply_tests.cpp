#include "libb/b.hpp"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("multiply 1 * 10", "[multiply]") {
    // cppcheck-suppress unreadVariable
    const auto multiplication = multiply(1, 10);
    CHECK(multiplication == 10);
}
