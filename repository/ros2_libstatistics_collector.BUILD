cc_library(
    name = "libstatistics_collector",
    srcs = glob(["src/**/*.cpp"]),
    hdrs = glob(["include/**/*.hpp"]),
    includes = ["include"],
    deps = [
        "@ros2_common_interfaces//:std_msgs_cpp",
        "@ros2_rcl//:rcl",
        "@ros2_rcl_interfaces//:statistics_msgs_cpp",
        "@ros2_rcpputils//:rcpputils",
    ],
    visibility = ["//visibility:public"],
)
