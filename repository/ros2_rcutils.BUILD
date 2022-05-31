load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_skylib//rules:run_binary.bzl", "run_binary")
load("@rules_python//python:defs.bzl", "py_binary", "py_library")

_generate_logging_macros_src = """
import sys
import em

em.invoke([
    '-o', sys.argv[1],
    '-D', 'rcutils_module_path=\\"\\"',
    sys.argv[2],
])
"""

write_file(
    name = "generate_logging_macros_file",
    out = "generate_logging_macros.py",
    content = [_generate_logging_macros_src],
    is_executable = True,
)

py_library(
    name = "logging_generator",
    srcs = ["rcutils/logging.py"],
    visibility = ["//visibility:public"],  # This generator is used by other packages
    deps = ["@ros2bazel_pip_deps_empy//:pkg"],
)

py_binary(
    name = "generate_logging_macros",
    srcs = ["generate_logging_macros.py"],
    main = "generate_logging_macros.py",
    deps = [":logging_generator"],
)

run_binary(
    name = "logging_macros",
    srcs = ["resource/logging_macros.h.em"],
    outs = ["include/rcutils/logging_macros.h"],
    args = [
        "$(location include/rcutils/logging_macros.h)",
        "$(location resource/logging_macros.h.em)",
    ],
    tool = ":generate_logging_macros",
)

cc_library(
    name = "rcutils",
    srcs = glob(
        [
            "src/*.c",
            "src/*.h",
        ],
        exclude = ["src/time_*.c"],
    ) + select({
        "@platforms//os:linux": ["src/time_unix.c"],
        "@platforms//os:macos": ["src/time_unix.c"],
        "@platforms//os:windows": ["src/time_win32.c"],
    }),
    hdrs = glob(["include/**/*.h"]) + [":logging_macros"],
    copts = ["-std=c11"],
    includes = ["include"],
    linkopts = select({
        "@platforms//os:linux": ["-ldl"],
        "@platforms//os:macos": ["-ldl"],
        "@platforms//os:windows": [],
    }),
    local_defines = select({
        "@platforms//os:linux": ["_GNU_SOURCE"],  # TODO determine if this should be here or not since we're using clang on Linux as well.
        "//conditions:default": [],
    }),
    visibility = ["//visibility:public"],
)
