# C++ Experiments CMake Template

![Build](https://github.com/kolbma/cpp-experiments-cmake-template/actions/workflows/safe-cplusplus-build.yml/badge.svg)
![CodeQL](https://github.com/kolbma/cpp-experiments-cmake-template/actions/workflows/codeql.yml/badge.svg)
![Coverage](https://img.shields.io/endpoint?style=flat-square&url=https%3A%2F%2Fgist.githubusercontent.com%2Fkolbma%2Fd7b822a2fd65dc027c2cc661184207aa%2Fraw%2Fcpp-experiments-cmake-template-cobertura-coverage.json)

The _C++ Experiments CMake Template_ is a project template for modern
C++ projects with the
[_CMake_](https://cmake.org/cmake/help/latest/index.html) build system
and Visual Studio [Code](https://code.visualstudio.com/) as a 
development environment.  

The default setting is the __C++23__ standard.

## Components

1. C++ Compiler

GCC and CLang are supported in current versions with sufficient
C++23 support. Testing is carried out with GCC 14 and CLang 18.

2. LTO Support

If the installed compiler/linker supports LTO, this is activated by 
default.

Disable with __ENABLE_LTO=OFF__.

3. ccache/sccache Support

If the programs __ccache__ or __sccache__ are installed and found by
CMake, these compiler caches are used for build and linking. 

Disable with __ENABLE_CCACHE=OFF__.

4. Compiler Warnings

Very strict compiler warnings in order to create error-free, secure and
multiplatform-compatible code.

With the CMake option _ENABLE_WARNINGS_AS_ERRORS_ these warnings can 
also be degraded to errors.  
So set __ENABLE_WARNINGS_AS_ERRORS=ON__.

To disable all the compiler warnings setup set __ENABLE_WARNINGS=OFF__.

5. Code Checks

Provided the tools are installed in the development environment,
they are used to check the created source code.  
Build targets are also available in CMake.

* clang-tidy (Disable with __ENABLE_CLANG_TIDY=OFF__)
* cppchecker (Disable with __ENABLE_CPPCHECK=OFF__)
* flawfinder (Disable with __ENABLE_FLAWFINDER=OFF__)

6. Sanitizer Compile Options

The following sanitizer options are optionally available for compiling:

* ENABLE_SANITIZE_ADDR "Enable address sanitize."
* ENABLE_SANITIZE_UNDEF "Enable undefined sanitize."
* ENABLE_SANITIZE_LEAK "Enable leak sanitize."
* ENABLE_SANITIZE_THREAD "Enable thread sanitize."

7. CPM CMake Package Manager

With [CPM](https://github.com/cpm-cmake/CPM.cmake), external 
dependencies for the project can be added very easily during the build 
process.

8. Doxygen Code Documentation

If installed on the system, the code documentation tool 
[Doxygen](https://www.doxygen.nl/) is activated and provides the build 
target __docs__ for the creation of HTML documentation in the _docs_ 
subfolder.  
The theme 
[doxygen-awesome-css](https://jothepro.github.io/doxygen-awesome-css)
is used.  
The files in the _doxygen_ folder can be edited for customisation.

Disable with __ENABLE_DOXYGEN=OFF__.

9. CTest and Catch2 Testing

Tests are using _CTest_ of _CMake_.

It can be disabled by setting __BUILD_TESTING=OFF__.

[Catch2](https://github.com/catchorg/Catch2) is installed automatically 
(can be deactivated) and can be used for unit tests.  
Optionally, any other tool can be installed, e.g. with _CPM_.

Disable with __ENABLE_CATCH2_TEST=OFF__.

9. Code Coverage of Tests

Code coverage report in tests can be enabled with
__ENABLE_COVERAGE=ON__.

The external tool [__gcovr__](https://gcovr.com) is required for this to
work. Any version >= 5.0 should do.

To run the coverage report the _CMake__ target __coverage__ is to be
used.  
The compilation and linking is done with special flags and additional
lib. So this should be only enabled to generate a report.

A textual report is in the console output and the _Cobertura_ XML format
in saved in _build/gcov/cobertura-coverage.xml_.

Optional configuration can be done in file _gcovr.cfg_.

With
[GaelGirodon/ci-badges-action](https://github.com/GaelGirodon/ci-badges-action)
GitHub Workflow Action a badge can be created like in this template.

10. GitHub Workflow

There is provided the `safe-cplusplus-build.yml` workflow for GitHub.  
It does source and safety checks provided by the multiple CMake targets
created by helper functions of this template.  
After build of _Debug_ and _Release_ config the tests are running.  
On any failure the workflow fails.

## Organisation of the Project Structure

There are the subfolders _apps_, _include_, _src_ and _tests_.  

_apps_ is intended for the sources of applications  
_include_ is the base of the usual include files  
_src_ is for shared source components for building objects or libraries.
_tests_ is the subfolder for unit tests 

These folders contain _CMakeLists.txt_ files, each of which 
automatically involve further _CMakeLists.txt_ files in deeper 
subfolders and thus a tree structure can be created very easily.

Based on the existing example code in the folders, it should be
comprehensable how you can adapt the structure for your own project.

The _include_ folder is added to the default includes of compiler.

## _custom_target_ Magic

The provided _CMakeLists.txt_ in subfolders of the template project 
contains the usage of CMake helper functions out of 
`cmake/custom_target.cmake`.  

So for _apps_ this might look like:
```
include(custom_target)

set(TARGET_NAME env_crashloop)
create_executable(${TARGET_NAME} env_crashloop.cpp)
target_link_libraries(${TARGET_NAME} PRIVATE -lpthread)
```

The `create_executable(${TARGET_NAME} <source files...>)` make the
required CMake setup to compile the code like intended and provides
useful CMake targets.  
Afterwards you can call any CMake function on the target which makes
sense for your project.

The example libraries in _src_ are using a quite simple 
_CMakeLists.txt_ with comparable purpose:
```
include(custom_target)

set(TARGET_NAME liba)
create_library(${TARGET_NAME} lib.cpp)
```

For unit tests using _CTest_ like in the sample `bare_test`:
```
include(custom_target)

if(BUILD_TESTING)
  set(TEST_NAME bare_test)
  create_test(${TEST_NAME})
  add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
  # target_link_libraries(${TEST_NAME} PRIVATE liba)
endif()
```

There you have to call at least 
[`add_test()`](https://cmake.org/cmake/help/latest/command/add_test.html)
provided by CMake.

For unit tests with the _Catch2_ framework like in `catch2_a_test`:
```
include(custom_target)

if(ENABLE_CATCH2_TEST)
  set(TEST_NAME sum_tests)
  create_test(${TEST_NAME})
  target_link_libraries(${TEST_NAME} PRIVATE liba)
endif()
```

Here the addition of tests for _CTest_ is handled by _Catch2_ and you
must not call `add_test()` yourself.

## License

[BSD 1-Clause License](https://spdx.org/licenses/BSD-1-Clause.html)

Copyright (c) 2024 Markus Kolb All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
“AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

