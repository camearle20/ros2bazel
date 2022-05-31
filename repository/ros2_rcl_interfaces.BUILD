load("@com_github_camearle20_ros2bazel//ros2/rules:ros2_interfaces.bzl", "ros2_all_interface_libraries")

ros2_all_interface_libraries(
    name = "builtin_interfaces",
    srcs = glob(["builtin_interfaces/msg/*.msg"]),
    visibility = ["//visibility:public"],
)

ros2_all_interface_libraries(
    name = "action_msgs",
    srcs = glob([
        "action_msgs/msg/*.msg",
        "action_msgs/srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":builtin_interfaces",
        "@ros2_unique_identifier_msgs//:unique_identifier_msgs",
    ],
)

ros2_all_interface_libraries(
    name = "rcl_interfaces",
    srcs = glob([
        "rcl_interfaces/msg/*.msg",
        "rcl_interfaces/srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
    deps = [":builtin_interfaces"],
)

ros2_all_interface_libraries(
    name = "composition_interfaces",
    srcs = glob([
        "composition_interfaces/srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":rcl_interfaces",
    ],
)

ros2_all_interface_libraries(
    name = "lifecycle_msgs",
    srcs = glob([
        "lifecycle_msgs/msg/*.msg",
        "lifecycle_msgs/srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
)

ros2_all_interface_libraries(
    name = "rosgraph_msgs",
    srcs = glob([
        "rosgraph_msgs/msg/*.msg",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":builtin_interfaces",
    ],
)

ros2_all_interface_libraries(
    name = "statistics_msgs",
    srcs = glob([
        "statistics_msgs/msg/*.msg",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":builtin_interfaces",
    ],
)
