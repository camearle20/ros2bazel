load("@bazel_skylib//rules:copy_file.bzl", "copy_file")

copy_file(
    name = "typesupport_c_generator_main",
    src = "rosidl_typesupport_c/bin/rosidl_typesupport_c",
    out = "typesupport_c_generator_main.py",
)

py_binary(
    name = "typesupport_generator_c",
    srcs = glob(["rosidl_typesupport_c/rosidl_typesupport_c/*.py"]) + ["typesupport_c_generator_main.py"],
    imports = ["rosidl_typesupport_c"],
    main = "typesupport_c_generator_main.py",
    visibility = ["//visibility:public"],
    deps = [
        "@ament_index//:index_python",
        "@ros2_rosidl//:cli",
        "@ros2_rosidl//:cmake",
        "@ros2_rosidl//:parser",
    ],
)

filegroup(
    name = "typesupport_generator_c_templates",
    srcs = glob(["rosidl_typesupport_c/resource/*.em"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "typesupport_generator_c_visibility_template",
    srcs = ["rosidl_typesupport_c/resource/rosidl_typesupport_c__visibility_control.h.in"],
    visibility = ["//visibility:public"],
)

copy_file(
    name = "typesupport_cpp_generator_main",
    src = "rosidl_typesupport_cpp/bin/rosidl_typesupport_cpp",
    out = "typesupport_cpp_generator_main.py",
)

py_binary(
    name = "typesupport_generator_cpp",
    srcs = glob(["rosidl_typesupport_cpp/rosidl_typesupport_cpp/*.py"]) + ["typesupport_cpp_generator_main.py"],
    imports = ["rosidl_typesupport_cpp"],
    main = "typesupport_cpp_generator_main.py",
    visibility = ["//visibility:public"],
    deps = [
        "@ament_index//:index_python",
        "@ros2_rosidl//:cli",
        "@ros2_rosidl//:cmake",
        "@ros2_rosidl//:parser",
    ],
)

filegroup(
    name = "typesupport_generator_cpp_templates",
    srcs = glob(["rosidl_typesupport_cpp/resource/*.em"]),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "rosidl_typesupport_c",
    srcs = glob(["rosidl_typesupport_c/src/*"]),
    hdrs = glob(["rosidl_typesupport_c/include/rosidl_typesupport_c/*.h"]),
    includes = ["rosidl_typesupport_c/include"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2_rcpputils//:rcpputils",
        "@ros2_rcutils//:rcutils",
        "@ros2_rosidl//:rosidl_runtime_c",
    ],
)

cc_library(
    name = "rosidl_typesupport_cpp",
    srcs = glob(["rosidl_typesupport_cpp/src/*"]),
    hdrs = glob(["rosidl_typesupport_cpp/include/rosidl_typesupport_cpp/*"]),
    includes = ["rosidl_typesupport_cpp/include"],
    visibility = ["//visibility:public"],
    deps = [
        ":rosidl_typesupport_c",
        "@ros2_rcpputils//:rcpputils",
        "@ros2_rosidl//:rosidl_runtime_c",
    ],
)
