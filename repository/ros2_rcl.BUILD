cc_library(
    name = "rcl_yaml_param_parser",
    srcs = glob(["rcl_yaml_param_parser/src/**/*.c", "rcl_yaml_param_parser/src/**/*.h"]),
    hdrs = glob(["rcl_yaml_param_parser/include/**/*.h"]),
    includes = ["rcl_yaml_param_parser/include"],
    visibility = ["//visibility:public"],
    deps = [
        "@libyaml",
        "@ros2_rcutils//:rcutils",
        "@ros2_rmw//:rmw",
    ],
)

cc_library(
    name = "rcl",
    srcs = glob([
        "rcl/src/**/*.c",
        "rcl/src/**/*.h",
    ]),
    hdrs = glob(["rcl/include/**/*.h"]),
    includes = ["rcl/include"],
    deps = [
        ":rcl_yaml_param_parser",
        "@ros2_rcl_interfaces//:rcl_interfaces_c",
        "@ros2_rcl_logging//:rcl_logging_interface",
        "@ros2_rcl_logging//:rcl_logging_spdlog",
        "@ros2_rcutils//:rcutils",
        "@ros2_rmw_cyclonedds//:rmw_cyclonedds_cpp",
        "@ros2_rosidl//:rosidl_runtime_c",
        "@ros2_tracing//:tracetools"
    ],
    local_defines = ["ROS_PACKAGE_NAME=\\\"rcl\\\""],
    visibility = ["//visibility:public"],
)
