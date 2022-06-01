load("@bazel_skylib//rules:write_file.bzl", "write_file")

write_file(
    name = "ros2_tracing_config",
    out = "tracetools/include/tracetools/config.h",
    content = [],  # This is empty since we are not enabling either of the defines in this file
)

cc_library(
    name = "tracetools",
    srcs = [
        "tracetools/src/status.c",
        "tracetools/src/tracetools.c",
        "tracetools/src/utils.cpp",
    ],
    hdrs = [
        "tracetools/include/tracetools/status.h",
        "tracetools/include/tracetools/tracetools.h",
        "tracetools/include/tracetools/utils.hpp",
        "tracetools/include/tracetools/visibility_control.hpp",
        ":ros2_tracing_config",
    ],
    includes = ["tracetools/include"],
    visibility = ["//visibility:public"],
)
