cc_library(
    name = "rcl_yaml_param_parser",
    srcs = glob([
        "rcl_yaml_param_parser/src/**/*.c",
        "rcl_yaml_param_parser/src/**/*.h",
    ]),
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
    local_defines = ["ROS_PACKAGE_NAME=\\\"rcl\\\""],
    visibility = ["//visibility:public"],
    deps = [
        ":rcl_yaml_param_parser",
        "@ros2_rcl_interfaces//:rcl_interfaces_c",
        "@ros2_rcl_logging//:rcl_logging_interface",
        "@ros2_rcl_logging//:rcl_logging_spdlog",
        "@ros2_rcutils//:rcutils",
        "@ros2_rmw_cyclonedds//:rmw_cyclonedds_cpp",
        "@ros2_rosidl//:rosidl_runtime_c",
        "@ros2_tracing//:tracetools",
    ],
)

cc_library(
    name = "rcl_action",
    srcs = glob([
        "rcl_action/src/**/*.c",
        "rcl_action/src/**/*.h",
    ]),
    hdrs = glob(["rcl_action/include/**/*.h"]),
    includes = ["rcl_action/include"],
    local_defines = ["ROS_PACKAGE_NAME=\\\"rcl_action\\\""],
    visibility = ["//visibility:public"],
    deps = [
        ":rcl",
        "@ros2_rcl_interfaces//:action_msgs_c",
        "@ros2_rcutils//:rcutils",
        "@ros2_rmw//:rmw",
        "@ros2_rosidl//:rosidl_runtime_c",
    ],
)

cc_library(
    name = "rcl_lifecycle",
    srcs = glob([
        "rcl_lifecycle/src/**/*.c",
        "rcl_lifecycle/src/**/*.h",
    ]),
    hdrs = glob(["rcl_lifecycle/include/**/*.h"]),
    includes = ["rcl_lifecycle/include"],
    local_defines = ["ROS_PACKAGE_NAME=\\\"rcl_lifecycle\\\""],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rcl_interfaces//:lifecycle_msgs_c",
        ":rcl",
        "@ros2_rcutils//:rcutils",
        "@ros2_rmw//:rmw",
        "@ros2_rosidl//:rosidl_runtime_c",
        "@ros2_tracing//:tracetools"
    ]
)