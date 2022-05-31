load("@com_github_camearle20_ros2bazel//ros2/rules:ros2_interfaces.bzl", "ros2_all_interface_libraries")

ros2_all_interface_libraries(
    name = "rmw_dds_common",
    srcs = glob(["rmw_dds_common/msg/*.msg"]),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "rmw_dds_common_lib",
    srcs = glob(["rmw_dds_common/src/*.cpp"]),
    hdrs = glob([
        "rmw_dds_common/include/**/*.h",
        "rmw_dds_common/include/**/*.hpp",
    ]),
    includes = ["rmw_dds_common/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":rmw_dds_common_cpp",
        "@ros2_rcpputils//:rcpputils",
        "@ros2_rcutils//:rcutils",
        "@ros2_rmw//:rmw",
        "@ros2_rosidl//:rosidl_runtime_cpp",
    ],
)
