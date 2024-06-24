#include <algorithm>
#include <array>
#include <cassert>
#include <cerrno>
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <iostream>
// #include <limits>
#include <string>
#include <thread>

namespace {
    constexpr const char *k_env_varname = "ENV_TEST_VAR";
    constexpr const int64_t k_error_wait_us = 10;
    constexpr const std::size_t k_thread_count = 20;
    constexpr const int64_t k_thread_sleep_ms = 1000;
} // namespace

/// @brief Generate random `std::string` with length digit at start
///
/// @param len Length of `std::string` [1..=9]
///
/// @return random `std::string`
auto rnd_value(uint8_t len) -> std::string {
    auto randchar = []() -> char {
        const auto charset = std::to_array(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
        const auto max_index = charset.size() - 1;
        const auto index =
            static_cast<unsigned long>(rand()) % max_index; // NOLINT
        return charset.at(index);
    };
    std::string value(len + 1, 0);
    std::generate_n(value.begin() + 1, len, randchar);
    value[0] = static_cast<char>('1' + len);
    return value;
}

auto main() -> int {
    // Flawfinder: ignore
    const auto *env_value_start = std::getenv(k_env_varname); // NOLINT
    assert(!env_value_start);
    if (env_value_start != nullptr) {
        // dummy for unused in Release
    }

    auto th_getenv = std::array<std::jthread, k_thread_count>{};

    for (auto &thread : th_getenv) {
        thread = std::jthread{[] {
            for (;;) {
                // Flawfinder: ignore
                const auto *env_value = std::getenv(k_env_varname); // NOLINT
                if (env_value == nullptr) {
                    // NOLINTNEXTLINE
                    std::cerr << "getenv fail: " << std::strerror(errno)
                              << "\n";
                    std::this_thread::sleep_for(
                        std::chrono::microseconds{k_error_wait_us});
                } else {
                    std::cout << "getenv: " << k_env_varname << ": "
                              << env_value << "\n";
                    const auto value = std::string{env_value};
                    // Flawfinder: ignore
                    assert(value.length() ==
                           static_cast<std::size_t>(value[0] - '0'));
                }
            }
        }};
    }

    auto th_setenv = std::array<std::jthread, k_thread_count>{};

    for (auto &thread : th_setenv) {
        thread = std::jthread{[] {
            for (;;) {
                // NOLINTNEXTLINE(cert-msc30-c,cert-msc50-cpp,concurrency-mt-unsafe)
                const uint8_t value_len = 1 + static_cast<uint8_t>(rand() % 9);
                const auto value = rnd_value(value_len);
                // Flawfinder: ignore
                auto ret = setenv(k_env_varname, value.data(), 1); // NOLINT
                if (ret != 0) {
                    // NOLINTNEXTLINE
                    std::cerr << "setenv fail: " << std::strerror(errno)
                              << "\n";
                    std::this_thread::sleep_for(
                        std::chrono::microseconds{k_error_wait_us});
                } else {
                    std::cout << "setenv: " << k_env_varname << ": " << value
                              << "\n";
                }

                // causes invalid memory access
                // for (uint32_t round = 0;
                //      round < std::numeric_limits<uint32_t>::max(); ++round) {
                //     auto key = std::string{"test"};
                //     // NOLINTNEXTLINE
                //     for (uint32_t i = 0; i < round % 10; ++round) {
                //         key.append("test");
                //     }
                //     key.append(std::to_string(round));

                //     auto round_ret =
                //         // NOLINTNEXTLINE
                //         setenv(key.data(), std::to_string(round).data(), 1);

                //     if (round_ret != 0) {
                //         // NOLINTNEXTLINE
                //         std::cerr << "setenv fail: " << std::strerror(errno)
                //                   << "\n";
                //         std::this_thread::sleep_for(
                //             std::chrono::microseconds{k_error_wait_us});
                //     } else {
                //         std::cout << "setenv: " << key << ": " << round <<
                //         "\n";
                //     }
                // }
            }
        }};
    }

    for (;;) {
        std::this_thread::sleep_for(
            std::chrono::milliseconds{k_thread_sleep_ms});
    }

    return 0;
}
