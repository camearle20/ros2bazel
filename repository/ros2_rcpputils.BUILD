cc_library(
    name = "rcpputils",
    hdrs = glob(["include/**/*.hpp"]),
    includes = ["include"],
    srcs = glob(["src/*.cpp"]),
    deps = ["@ros2_rcutils//:rcutils"],
    visibility = ["//visibility:public"],
    copts = ["-std=c++14"]
)