load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

LIBYAML_VERSION = "0.2.5"
SPDLOG_VERSION = "1.10.0"
ECLIPSE_CYCLONEDDS_VERSION = "0.9.1"
AMENT_INDEX_VERSION = "1.2.0"
ROS2_RCUTILS_VERSION = "4.0.2"
ROS2_RCPPUTILS_VERSION = "2.2.1"
ROS2_ROSIDL_VERSION = "2.2.2"
ROS2_ROSIDL_TYPESUPPORT_VERSION = "1.2.1"
ROS2_UNIQUE_IDENTIFIER_MSGS_VERSION = "2.2.1"
ROS2_RCL_INTERFACES_VERSION = "1.0.3"
ROS2_RMW_VERSION = "3.3.1"
ROS2_RMW_DDS_COMMON_VERSION = "1.2.1"
ROS2_RMW_CYCLONEDDS_VERSION = "0.22.5"
ROS2_RCL_LOGGING_VERSION = "2.1.4"
ROS2_TRACING_VERSION = "2.3.0"
ROS2_RCL_VERSION = "3.1.3"
ROS2_COMMON_INTERFACES_VERSION = "2.2.4"
ROS2_LIBSTATISTICS_COLLECTOR_VERSION = "1.1.1"
ROS2_RCLCPP_VERSION = "9.2.1"

def ros2bazel_repositories():
    """
    Declares other workspaces that this one depends on.

    Additionally declares repositories of ROS2 packages.
    """
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "cdf6b84084aad8f10bf20b46b77cb48d83c319ebe6458a18e9d2cebf57807cdd",
        strip_prefix = "rules_python-0.8.1",
        url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.1.tar.gz",
    )

    maybe(
        http_archive,
        name = "libyaml",
        build_file = "@com_github_camearle20_ros2bazel//:repository/libyaml.BUILD",
        sha256 = "14605baa6dfc0c4d3ab943a46a627413c0388736e453b67fe4e90c9683c8cbc8",
        strip_prefix = "libyaml-%s" % LIBYAML_VERSION,
        urls = ["https://github.com/yaml/libyaml/archive/refs/tags/%s.zip" % LIBYAML_VERSION],
    )

    # Third party repos
    maybe(
        http_archive,
        name = "spdlog",
        sha256 = "7be28ff05d32a8a11cfba94381e820dd2842835f7f319f843993101bcab44b66",
        build_file = "@com_github_camearle20_ros2bazel//:repository/spdlog.BUILD",
        strip_prefix = "spdlog-%s" % SPDLOG_VERSION,
        urls = ["https://github.com/gabime/spdlog/archive/refs/tags/v%s.zip" % SPDLOG_VERSION],
    )

    # ROS2 repos
    maybe(
        http_archive,
        name = "eclipse_cyclonedds",
        build_file = "@com_github_camearle20_ros2bazel//:repository/eclipse_cyclonedds.BUILD",
        sha256 = "ff5c7f535adcaf1b9537cf61fd33d10d81ad4c66635ab7eba034564ec66f5b24",
        strip_prefix = "cyclonedds-%s" % ECLIPSE_CYCLONEDDS_VERSION,
        urls = ["https://github.com/eclipse-cyclonedds/cyclonedds/archive/refs/tags/%s.zip" % ECLIPSE_CYCLONEDDS_VERSION],
    )

    maybe(
        http_archive,
        name = "ament_index",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ament_index.BUILD",
        sha256 = "4670172e55c3a0b107330104b0f2fea12cbfa5c42234533d353c83b0f3d32d13",
        strip_prefix = "ament_index-%s" % AMENT_INDEX_VERSION,
        urls = ["https://github.com/ament/ament_index/archive/refs/tags/%s.zip" % AMENT_INDEX_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rcutils",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rcutils.BUILD",
        sha256 = "8fc2b80b9c04b2cca25c9e22f35ef8cc859e9c7816ce3a46a76eb2c69e609c30",
        strip_prefix = "rcutils-%s" % ROS2_RCUTILS_VERSION,
        urls = ["https://github.com/ros2/rcutils/archive/refs/tags/%s.zip" % ROS2_RCUTILS_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rcpputils",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rcpputils.BUILD",
        sha256 = "c13bb7de617e34ac9e5cece4e7460ff0051c52b3a3cb51318cde7ba621bbe6b5",
        strip_prefix = "rcpputils-%s" % ROS2_RCPPUTILS_VERSION,
        urls = ["https://github.com/ros2/rcpputils/archive/refs/tags/%s.zip" % ROS2_RCPPUTILS_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rosidl",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rosidl.BUILD",
        sha256 = "34dbc3ca953fa1c8108890eb13eb045854cd4656dcd698b31c822d191636f777",
        strip_prefix = "rosidl-%s" % ROS2_ROSIDL_VERSION,
        urls = ["https://github.com/ros2/rosidl/archive/refs/tags/%s.zip" % ROS2_ROSIDL_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rosidl_typesupport",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rosidl_typesupport.BUILD",
        sha256 = "71ad259062d9e59301d5561bcb1102de85e914156c15a489eef8f0df6f5d7910",
        strip_prefix = "rosidl_typesupport-%s" % ROS2_ROSIDL_TYPESUPPORT_VERSION,
        urls = ["https://github.com/ros2/rosidl_typesupport/archive/refs/tags/%s.zip" % ROS2_ROSIDL_TYPESUPPORT_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_unique_identifier_msgs",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_unique_identifier_msgs.BUILD",
        strip_prefix = "unique_identifier_msgs-%s" % ROS2_UNIQUE_IDENTIFIER_MSGS_VERSION,
        sha256 = "a5d0c75b6fbff05259e16bb34af37fd74fa2bb9f67193a10e2c39a28c7f7eb69",
        urls = ["https://github.com/ros2/unique_identifier_msgs/archive/refs/tags/%s.zip" % ROS2_UNIQUE_IDENTIFIER_MSGS_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rcl_interfaces",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rcl_interfaces.BUILD",
        sha256 = "14f396a2b011ea7b1947937a4658ff319edfa4c2d9dd6262bbfba11a7d487833",
        strip_prefix = "rcl_interfaces-%s" % ROS2_RCL_INTERFACES_VERSION,
        urls = ["https://github.com/ros2/rcl_interfaces/archive/refs/tags/%s.zip" % ROS2_RCL_INTERFACES_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rmw",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rmw.BUILD",
        sha256 = "4afb82225c28395cb3a2a8f82052735a7594af394eda7b6cb3c4fbd094893f9c",
        strip_prefix = "rmw-%s" % ROS2_RMW_VERSION,
        urls = ["https://github.com/ros2/rmw/archive/refs/tags/%s.zip" % ROS2_RMW_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rmw_dds_common",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rmw_dds_common.BUILD",
        sha256 = "d5f65926081423ff9a58cc79d54ad2d26479b2f82a945ca70ead292e305afd31",
        strip_prefix = "rmw_dds_common-%s" % ROS2_RMW_DDS_COMMON_VERSION,
        urls = ["https://github.com/ros2/rmw_dds_common/archive/refs/tags/%s.zip" % ROS2_RMW_DDS_COMMON_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rmw_cyclonedds",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rmw_cyclonedds.BUILD",
        sha256 = "c9bdd148d46f592f5b6f304756f218768cfdfa0d08bc6bf0941a3e5a0b333f09",
        strip_prefix = "rmw_cyclonedds-%s" % ROS2_RMW_CYCLONEDDS_VERSION,
        urls = ["https://github.com/ros2/rmw_cyclonedds/archive/refs/tags/%s.zip" % ROS2_RMW_CYCLONEDDS_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rcl_logging",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rcl_logging.BUILD",
        sha256 = "2dc52930f1edf88d42d0d1e6908ff6a283d9773a31252dcd39d75f9065b1097a",
        strip_prefix = "rcl_logging-%s" % ROS2_RCL_LOGGING_VERSION,
        urls = ["https://github.com/ros2/rcl_logging/archive/refs/tags/%s.zip" % ROS2_RCL_LOGGING_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_tracing",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_tracing.BUILD",
        sha256 = "c9567ccbdbabc2388094a21bcdc5b80a056e181e04cff20d0faa365fea907062",
        strip_prefix = "ros2_tracing-%s" % ROS2_TRACING_VERSION,
        urls = ["https://gitlab.com/ros-tracing/ros2_tracing/-/archive/%s/ros2_tracing-%s.zip" % (ROS2_TRACING_VERSION, ROS2_TRACING_VERSION)],
    )

    maybe(
        http_archive,
        name = "ros2_rcl",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rcl.BUILD",
        sha256 = "c3924c4a32ca89e97c6f24c2d6451c2baf8259dfb1a2a1cb5a24b0ce2d405613",
        strip_prefix = "rcl-%s" % ROS2_RCL_VERSION,
        urls = ["https://github.com/ros2/rcl/archive/refs/tags/%s.zip" % ROS2_RCL_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_common_interfaces",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_common_interfaces.BUILD",
        sha256 = "0ac64283a46884a8a918c540bbd29fe82a88b690c43757b821c999b1b7ab8966",
        strip_prefix = "common_interfaces-%s" % ROS2_COMMON_INTERFACES_VERSION,
        urls = ["https://github.com/ros2/common_interfaces/archive/refs/tags/%s.zip" % ROS2_COMMON_INTERFACES_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_libstatistics_collector",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_libstatistics_collector.BUILD",
        sha256 = "3d7abaa1e3d83dad34988085bdaa9bb33fbd4c46c93a4e5afaaa7eff765d8d37",
        strip_prefix = "libstatistics_collector-%s" % ROS2_LIBSTATISTICS_COLLECTOR_VERSION,
        urls = ["https://github.com/ros-tooling/libstatistics_collector/archive/refs/tags/%s.zip" % ROS2_LIBSTATISTICS_COLLECTOR_VERSION],
    )

    maybe(
        http_archive,
        name = "ros2_rclcpp",
        build_file = "@com_github_camearle20_ros2bazel//:repository/ros2_rclcpp.BUILD",
        sha256 = "8db8ec82e0680f7ef28d6a56f67f1c8c497abd36f0eb0161aa38b7ff58ea4767",
        strip_prefix = "rclcpp-%s" % ROS2_RCLCPP_VERSION,
        urls = ["https://github.com/ros2/rclcpp/archive/refs/tags/%s.zip" % ROS2_RCLCPP_VERSION],
    )
