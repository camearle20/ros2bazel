load("@rules_python//python:defs.bzl", "py_library")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")

py_library(
    name = "adapter",
    srcs = glob(["rosidl_adapter/rosidl_adapter/**/*.py"]),
    imports = ["rosidl_adapter"],
    deps = [
        ":cli",
        "@ros2bazel_pip_deps_empy//:pkg",
    ],
    data = [":adapter_templates"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "adapter_templates",
    srcs = glob(["rosidl_adapter/rosidl_adapter/resource/*.em"]),
    visibility = ["//visibility:public"],
)

py_library(
    name = "cli",
    srcs = glob(["rosidl_cli/rosidl_cli/**/*.py"]),
    imports = ["rosidl_cli"],
    visibility = ["//visibility:public"],
    deps = [
        "@ros2bazel_pip_deps_argcomplete//:pkg",
        "@ros2bazel_pip_deps_importlib_metadata//:pkg",
    ],
)

py_library(
    name = "cmake",
    srcs = ["rosidl_cmake/rosidl_cmake/__init__.py"],
    imports = ["rosidl_cmake"],
    visibility = ["//visibility:public"],
    deps = [
        ":parser",
        "@ros2bazel_pip_deps_empy//:pkg",
    ],
)

# Give the main file a .py extension since py_binary won't accept it without it
copy_file(
    name = "generator_c_main",
    src = "rosidl_generator_c/bin/rosidl_generator_c",
    out = "generator_c_main.py",
)

py_binary(
    name = "generator_c",
    srcs = glob(["rosidl_generator_c/rosidl_generator_c/*.py"]) + ["generator_c_main.py"],
    imports = ["rosidl_generator_c"],
    main = "generator_c_main.py",
    visibility = ["//visibility:public"],
    deps = [
        ":cli",
        ":cmake",
        ":parser",
        "@ament_index//:index_python",
    ],
)

filegroup(
    name = "generator_c_templates",
    srcs = glob(["rosidl_generator_c/resource/*.em"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "generator_c_visibility_template",
    srcs = ["rosidl_generator_c/resource/rosidl_generator_c__visibility_control.h.in"],
    visibility = ["//visibility:public"],
)

# Give the main file a .py extension since py_binary won't accept it without it
copy_file(
    name = "generator_cpp_main",
    src = "rosidl_generator_cpp/bin/rosidl_generator_cpp",
    out = "generator_cpp_main.py",
)

py_binary(
    name = "generator_cpp",
    srcs = glob(["rosidl_generator_cpp/rosidl_generator_cpp/*.py"]) + ["generator_cpp_main.py"],
    imports = ["rosidl_generator_cpp"],
    main = "generator_cpp_main.py",
    visibility = ["//visibility:public"],
    deps = [
        ":cli",
        ":cmake",
        ":parser",
        "@ament_index//:index_python",
    ],
)

filegroup(
    name = "generator_cpp_templates",
    srcs = glob(["rosidl_generator_cpp/resource/*.em"]),
    visibility = ["//visibility:public"],
)

py_library(
    name = "parser",
    srcs = glob(["rosidl_parser/rosidl_parser/*.py"]),
    data = ["rosidl_parser/rosidl_parser/grammar.lark"],
    imports = ["rosidl_parser"],
    visibility = ["//visibility:public"],
    deps = ["@ros2bazel_pip_deps_lark_parser//:pkg"],
)

cc_library(
    name = "rosidl_runtime_c",
    srcs = glob(["rosidl_runtime_c/src/*.c"]),
    hdrs = glob(["rosidl_runtime_c/include/rosidl_runtime_c/*.h"]),
    includes = ["rosidl_runtime_c/include"],
    visibility = ["//visibility:public"],
    deps = ["@ros2_rcutils//:rcutils", ":rosidl_typesupport_interface"],
)

cc_library(
    name = "rosidl_runtime_cpp",
    hdrs = glob(["rosidl_runtime_cpp/include/**/*.hpp"]),
    visibility = ["//visibility:public"],
    includes = ["rosidl_runtime_cpp/include"],
    deps = [":rosidl_runtime_c"],
)

cc_library(
    name = "rosidl_typesupport_interface",
    hdrs = ["rosidl_typesupport_interface/include/rosidl_typesupport_interface/macros.h"],
    includes = ["rosidl_typesupport_interface/include"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "rosidl_typesupport_introspection_c",
    srcs = glob(["rosidl_typesupport_introspection_c/src/*.c"]),
    hdrs = glob(["rosidl_typesupport_introspection_c/include/rosidl_typesupport_introspection_c/*.h"]),
    includes = ["rosidl_typesupport_introspection_c/include"],
    visibility = ["//visibility:public"],
    deps = [":rosidl_runtime_c"],
)

# Give the main file a .py extension since py_binary won't accept it without it
copy_file(
    name = "typesupport_introspection_c_generator_main",
    src = "rosidl_typesupport_introspection_c/bin/rosidl_typesupport_introspection_c",
    out = "typesupport_introspection_c_generator_main.py",
)

py_binary(
    name = "typesupport_introspection_c_generator",
    srcs = glob(["rosidl_typesupport_introspection_c/rosidl_typesupport_introspection_c/*.py"]) + ["typesupport_introspection_c_generator_main.py"],
    imports = ["rosidl_typesupport_introspection_c"],
    main = "typesupport_introspection_c_generator_main.py",
    visibility = ["//visibility:public"],
    deps = [
        ":cli",
        ":cmake",
        ":parser",
        "@ament_index//:index_python",
        ":generator_c"
    ],
)

filegroup(
    name = "typesupport_introspection_c_generator_templates",
    srcs = glob(["rosidl_typesupport_introspection_c/resource/*.em"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "typesupport_introspection_c_generator_visibility_template",
    srcs = ["rosidl_typesupport_introspection_c/resource/rosidl_typesupport_introspection_c__visibility_control.h.in"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "rosidl_typesupport_introspection_cpp",
    srcs = glob(["rosidl_typesupport_introspection_cpp/src/*.cpp"]),
    hdrs = glob([
        "rosidl_typesupport_introspection_cpp/include/rosidl_typesupport_introspection_cpp/*.hpp",
        "rosidl_typesupport_introspection_cpp/include/rosidl_typesupport_introspection_cpp/*.h",
    ]),
    includes = ["rosidl_typesupport_introspection_cpp/include"],
    deps = [
        ":rosidl_runtime_cpp",
        ":rosidl_typesupport_interface",
        ":rosidl_typesupport_introspection_c",
    ],
    visibility = ["//visibility:public"],
)

# Give the main file a .py extension since py_binary won't accept it without it
copy_file(
    name = "typesupport_introspection_cpp_generator_main",
    src = "rosidl_typesupport_introspection_cpp/bin/rosidl_typesupport_introspection_cpp",
    out = "typesupport_introspection_cpp_generator_main.py",
)

py_binary(
    name = "typesupport_introspection_cpp_generator",
    srcs = glob(["rosidl_typesupport_introspection_cpp/rosidl_typesupport_introspection_cpp/*.py"]) + ["typesupport_introspection_cpp_generator_main.py"],
    imports = ["rosidl_typesupport_introspection_cpp"],
    main = "typesupport_introspection_cpp_generator_main.py",
    visibility = ["//visibility:public"],
    deps = [
        ":cli",
        ":cmake",
        ":parser",
        ":generator_cpp",
        "@ament_index//:index_python",
    ],
)

filegroup(
    name = "typesupport_introspection_cpp_generator_templates",
    srcs = glob(["rosidl_typesupport_introspection_cpp/resource/*.em"]),
    visibility = ["//visibility:public"],
)
