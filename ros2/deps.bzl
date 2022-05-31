load("@rules_python//python:pip.bzl", "pip_parse")

def ros2bazel_dependencies():
    pip_parse(
        name = "ros2bazel_pip_deps",
        requirements_lock = "@com_github_camearle20_ros2bazel//:requirements_lock.txt",
    )
