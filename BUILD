# Copyright 2017-present The Material Foundation Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@bazel_ios_warnings//:strict_warnings_objc_library.bzl", "strict_warnings_objc_library")
load(":apple_framework_relative_headers.bzl", "apple_framework_relative_headers")

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

strict_warnings_objc_library(
    name = "MDFInternationalization",
    srcs = glob([
        "Sources/*.m",
    ]),
    hdrs = glob([
        "Sources/*.h",
    ]),
    sdk_frameworks = [
        "UIKit",
        "CoreGraphics",
        "CoreImage",
    ],
    enable_modules = 1,
    includes = ["Sources"],
    visibility = ["//visibility:public"],
    deps = [
        ":MDFInternationalizationFrameworkHeaders",
    ],
)

apple_framework_relative_headers(
    name = "MDFInternationalizationFrameworkHeaders",
    hdrs = glob([
        "Sources/*.h",
    ]),
    framework_name = "MDFInternationalization",
)

objc_library(
    name = "UnitTestsLib",
    srcs = glob([
        "Tests/*.m",
    ]),
    deps = [
        ":MDFInternationalization",
        ":MDFInternationalizationFrameworkHeaders",
    ],
    visibility = ["//visibility:private"],
)

ios_unit_test(
    name = "UnitTests",
    deps = [
      ":UnitTestsLib",
    ],
    minimum_os_version = "8.0",
    timeout = "short",
    visibility = ["//visibility:private"],
)
