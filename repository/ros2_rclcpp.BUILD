load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_skylib//rules:run_binary.bzl", "run_binary")
load("@rules_python//python:defs.bzl", "py_binary")
load("@com_github_camearle20_ros2bazel//ros2/private:rclcpp_interfaces.bzl", "rclcpp_interfaces")

_generate_logging_macros_src = """
import sys
import em

em.invoke([
    '-o', sys.argv[1],
    sys.argv[2],
])
"""

_generate_interfaces_src = """
import sys
import em

em.invoke([
    '-D', f'interface_name=\\"{sys.argv[1]}\\"',
    '-o', sys.argv[2],
    sys.argv[3],
])
"""

write_file(
    name = "generate_logging_macros_file",
    out = "generate_logging_macros.py",
    content = [_generate_logging_macros_src],
    is_executable = True,
)

py_binary(
    name = "generate_logging_macros",
    srcs = ["generate_logging_macros.py"],
    main = "generate_logging_macros.py",
    deps = [
        "@ros2_rcutils//:logging_generator",
        "@ros2bazel_pip_deps_empy//:pkg",
    ],
)

run_binary(
    name = "logging_macros",
    srcs = ["rclcpp/resource/logging.hpp.em"],
    outs = ["rclcpp/include/rclcpp/logging.hpp"],
    args = [
        "$(location rclcpp/include/rclcpp/logging.hpp)",
        "$(location rclcpp/resource/logging.hpp.em)",
    ],
    tool = ":generate_logging_macros",
)

filegroup(
    name = "interfaces",
    srcs = glob(["rclcpp/include/rclcpp/node_interfaces/node_*_interface.hpp"]),
    visibility = ["//visibility:public"],
)

write_file(
    name = "generate_interfaces_file",
    out = "generate_interfaces.py",
    content = [_generate_interfaces_src],
    is_executable = True,
)

py_binary(
    name = "generate_interfaces",
    srcs = ["generate_interfaces.py"],
    main = "generate_interfaces.py",
    deps = ["@ros2bazel_pip_deps_empy//:pkg"],
)

rclcpp_interfaces(
    name = "rclcpp_interfaces",
    generator = ":generate_interfaces",
    getter_template = "rclcpp/resource/get_interface.hpp.em",
    interfaces = ":interfaces",
    prefix_path = "rclcpp/include/rclcpp/node_interfaces",
    traits_template = "rclcpp/resource/interface_traits.hpp.em",
)

cc_library(
    name = "rclcpp",
    srcs = glob([
        "rclcpp/src/**/*.cpp",
        "rclcpp/src/**/*.hpp",
    ]),
    hdrs = glob(["rclcpp/include/**/*.hpp"]) + [
        ":logging_macros",
        ":rclcpp_interfaces",
    ],
    includes = ["rclcpp/include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ament_index//:index_cpp",
        "@ros2_libstatistics_collector//:libstatistics_collector",
        "@ros2_rcl//:rcl",
        "@ros2_rcl//:rcl_yaml_param_parser",
        "@ros2_rcl_interfaces//:builtin_interfaces_cpp",
        "@ros2_rcl_interfaces//:rcl_interfaces_cpp",
        "@ros2_rcl_interfaces//:rosgraph_msgs_cpp",
        "@ros2_rcl_interfaces//:statistics_msgs_cpp",
        "@ros2_rcpputils//:rcpputils",
        "@ros2_rcutils//:rcutils",
        "@ros2_rmw//:rmw",
        "@ros2_rosidl//:rosidl_runtime_cpp",
        "@ros2_rosidl_typesupport//:rosidl_typesupport_c",
        "@ros2_rosidl_typesupport//:rosidl_typesupport_cpp",
        "@ros2_tracing//:tracetools",
    ],
)

cc_library(
    name = "rclcpp_action",
    srcs = glob(["rclcpp_action/src/**/*.cpp"]),
    hdrs = glob(["rclcpp_action/include/**/*.hpp"]),
    includes = ["rclcpp_action/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":rclcpp",
        "@ros2_rcl//:rcl_action",
        "@ros2_rcl_interfaces//:action_msgs_cpp",
        "@ros2_rosidl//:rosidl_runtime_c",
    ],
)

cc_library(
    name = "rclcpp_lifecycle",
    srcs = glob([
        "rclcpp_lifecycle/src/**/*.cpp",
        "rclcpp_lifecycle/src/**/*.hpp",
    ]),
    hdrs = glob([
        "rclcpp_lifecycle/include/**/*.hpp",
        "rclcpp_lifecycle/include/**/*.h",
    ]),
    includes = ["rclcpp_lifecycle/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":rclcpp",
        "@ros2_rcl//:rcl_lifecycle",
        "@ros2_rcl_interfaces//:lifecycle_msgs_cpp",
        "@ros2_rmw//:rmw",
        "@ros2_rosidl_typesupport//:rosidl_typesupport_cpp",
    ],
)
