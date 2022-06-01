load("@com_github_camearle20_ros2bazel//ros2/rules:ros2_interfaces.bzl", "ros2_all_interface_libraries")

ros2_all_interface_libraries(
    name = "std_msgs",
    srcs = glob(["std_msgs/msg/*.msg"]),
    visibility = ["//visibility:public"],
    deps = ["@ros2_rcl_interfaces//:builtin_interfaces"],
)

ros2_all_interface_libraries(
    name = "std_srvs",
    srcs = glob(["std_srvs/srv/*.srv"]),
    visibility = ["//visibility:public"],
)

ros2_all_interface_libraries(
    name = "actionlib_msgs",
    srcs = glob(["actionlib_msgs/msg/*.msg"]),
    visibility = ["//visibility:public"],
    deps = [
        ":std_msgs",
        "@ros2_rcl_interfaces//:builtin_interfaces",
    ],
)

ros2_all_interface_libraries(
    name = "geometry_msgs",
    srcs = glob(["geometry_msgs/msg/*.msg"]),
    visibility = ["//visibility:public"],
    deps = [":std_msgs"],
)

ros2_all_interface_libraries(
    name = "diagnostic_msgs",
    srcs = glob([
        "diagnostic_msgs/msg/*.msg",
        "diagnostic_msgs/srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":geometry_msgs",
        ":std_msgs",
        "@ros2_rcl_interfaces//:builtin_interfaces",
    ],
)

ros2_all_interface_libraries(
    name = "nav_msgs",
    srcs = glob([
        "nav_msgs/msg/*.msg",
        "nav_msgs/srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":geometry_msgs",
        ":std_msgs",
        "@ros2_rcl_interfaces//:builtin_interfaces",
    ],
)

ros2_all_interface_libraries(
    name = "sensor_msgs",
    srcs = glob([
        "sensor_msgs/msg/*.msg",
        "sensor_msgs/srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":geometry_msgs",
        ":std_msgs",
        "@ros2_rcl_interfaces//:builtin_interfaces",
    ],
)

cc_library(
    name = "sensor_msgs_lib",
    hdrs = glob([
        "sensor_msgs/include/**/*.hpp",
    ]),
    includes = ["sensor_msgs/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":sensor_msgs_cpp",
    ],
)

ros2_all_interface_libraries(
    name = "shape_msgs",
    srcs = glob(["shape_msgs/msg/*.msg"]),
    visibility = ["//visibility:public"],
    deps = [":geometry_msgs"],
)

ros2_all_interface_libraries(
    name = "stereo_msgs",
    srcs = glob(["stereo_msgs/msg/*.msg"]),
    visibility = ["//visibility:public"],
    deps = [
        ":sensor_msgs",
        ":std_msgs",
    ],
)

ros2_all_interface_libraries(
    name = "trajectory_msgs",
    srcs = glob(["trajectory_msgs/msg/*.msg"]),
    visibility = ["//visibility:public"],
    deps = [
        ":geometry_msgs",
        ":std_msgs",
        "@ros2_rcl_interfaces//:builtin_interfaces",
    ],
)

ros2_all_interface_libraries(
    name = "visualization_msgs",
    srcs = glob([
        "visualization_msgs/msg/*.msg",
        "visualization_msgs/srv/*.srv",
    ]),
    visibility = ["//visibility:public"],
    deps = [
        ":geometry_msgs",
        ":std_msgs",
        "@ros2_rcl_interfaces//:builtin_interfaces",
    ],
)
