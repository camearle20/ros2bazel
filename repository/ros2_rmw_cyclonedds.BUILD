cc_library(
    name = "rmw_cyclonedds_cpp",
    srcs = glob(["rmw_cyclonedds_cpp/src/*.cpp"]),
    hdrs = glob(["rmw_cyclonedds_cpp/src/*.hpp"]),
    copts = ["-Iexternal/ros2_rmw_cyclonedds/rmw_cyclonedds_cpp/src"],
    deps = [
        "@eclipse_cyclonedds//:ddsc",
        "@ros2_rcpputils//:rcpputils",
        "@ros2_rcutils//:rcutils",
        "@ros2_rmw//:rmw",
        "@ros2_rmw_dds_common//:rmw_dds_common_lib",
        "@ros2_rosidl//:rosidl_runtime_c",
        "@ros2_rosidl//:rosidl_typesupport_introspection_c",
        "@ros2_rosidl//:rosidl_typesupport_introspection_cpp",
    ],
    visibility = ["//visibility:public"],
)
