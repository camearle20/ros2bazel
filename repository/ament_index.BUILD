load("@rules_python//python:defs.bzl", "py_library")

cc_library(
    name = "index_cpp",
    hdrs = glob(["ament_index_cpp/include/*.hpp"]),
    srcs = glob(["ament_index_cpp/src/*/cpp"]),
    includes = ["ament_index_cpp/include"],
    visibility = ["//visibility:public"],
)

py_library(
    name = "index_python",
    srcs = glob(["ament_index_python/ament_index_python/*.py"]),
    imports = ["ament_index_python"],
    visibility = ["//visibility:public"]
)