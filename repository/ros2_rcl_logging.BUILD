cc_library(
    name = "rcl_logging_interface",
    srcs = glob(["rcl_logging_interface/src/*.c"]),
    hdrs = glob(["rcl_logging_interface/include/**/*.h"]),
    includes = ["rcl_logging_interface/include"],
    visibility = ["//visibility:public"],
    deps = ["@ros2_rcutils//:rcutils"],
)

cc_library(
    name = "rcl_logging_spdlog",
    srcs = glob(["rcl_logging_spdlog/src/**/*.cpp"]),
    deps = [
        ":rcl_logging_interface",
        "@ros2_rcpputils//:rcpputils",
        "@ros2_rcutils//:rcutils",
        "@spdlog",
    ],
    visibility = ["//visibility:public"],
)
