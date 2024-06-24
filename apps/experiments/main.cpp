#include <array>
#include <cstddef>
#include <iostream>
#include <ostream>
#include <print>

#include "config.hpp"

/// @brief Some test
///
/// Has currently no data
///
struct Test {
    /* data */
};

struct Test2 {
    /* data */
};

struct Test3 {};

namespace {
    constexpr std::size_t k_array_size = 10;
    constexpr char8_t k_zero_char = 48;
} // namespace

auto main(const int /*unused*/,
          const char *const /*unused*/[]) noexcept(false) -> int {
    auto array_a = std::array<char8_t, k_array_size>();
    array_a[1] = u8'\t';
    std::cout << "Hello, from " << project_name << " " << project_version
              << "!\n";

    for (const auto &ele : array_a) {
        std::print("{:c} ", ele + k_zero_char);
    }

    std::cout << "\n";

    return 0;
}
