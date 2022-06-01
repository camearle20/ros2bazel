load("@com_github_camearle20_ros2bazel//ros2:repositories.bzl", "LIBYAML_VERSION")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

_libyaml_config_content = """
#define YAML_VERSION_MAJOR {major}
#define YAML_VERSION_MINOR {minor}
#define YAML_VERSION_PATCH {patch}
#define YAML_VERSION_STRING "{version}"
""".format(
    major = LIBYAML_VERSION.split(".")[0],
    minor = LIBYAML_VERSION.split(".")[1],
    patch = LIBYAML_VERSION.split(".")[2],
    version = LIBYAML_VERSION,
)

write_file(
    name = "libyaml_config",
    out = "config.h",  # Put this here so it doesn't pollute include space
    content = [_libyaml_config_content],
)

cc_library(
    name = "libyaml",
    srcs = glob(["src/**/*.c", "src/**/*.h"]),
    hdrs = ["include/yaml.h", ":libyaml_config"],
    includes = ["include"],
    visibility = ["//visibility:public"],
    local_defines = ["HAVE_CONFIG_H"]
)