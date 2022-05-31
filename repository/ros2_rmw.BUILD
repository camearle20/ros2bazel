cc_library(
    name = "rmw",
    srcs = glob(["rmw/src/**/*.c"]),
    hdrs = glob(["rmw/include/**/*.h"]),
    includes = ["rmw/include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rcutils//:rcutils",
        "@ros2_rosidl//:rosidl_runtime_c",
    ],
)

cc_library(
    name = "rmw_cpp",
    hdrs = glob(["rmw/include/**/*.hpp"]),
    includes = ["rmw/include"],
    visibility = ["//visibility:public"],
    deps = [":rmw"],
)
