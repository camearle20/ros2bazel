load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

_CPP_OUTPUT_HDRS = [
    "%s.hpp",
    "detail/%s__builder.hpp",
    "detail/%s__struct.hpp",
    "detail/%s__traits.hpp",
]

_TYPESUPPORT_CPP_OUTPUT_SRCS = [
    "%s__type_support.cpp",
]

_TYPESUPPORT_INTROSPECTION_CPP_OUTPUT_HDRS = [
    "detail/%s__rosidl_typesupport_introspection_cpp.hpp",
]

_TYPESUPPORT_INTROSPECTION_CPP_OUTPUT_SRCS = [
    "detail/%s__type_support.cpp",
]

_C_OUTPUT_HDRS = [
    "%s.h",
    "detail/%s__functions.h",
    "detail/%s__struct.h",
    "detail/%s__type_support.h",
]

_C_OUTPUT_SRCS = [
    "detail/%s__functions.c",
]

_TYPESUPPORT_C_OUTPUT_SRCS = [
    "%s__type_support.cpp",
]

_TYPESUPPORT_INTROSPECTION_C_OUTPUT_HDRS = [
    "detail/%s__rosidl_typesupport_introspection_c.h",
]

_TYPESUPPORT_INTROSPECTION_C_OUTPUT_SRCS = [
    "detail/%s__type_support.c",
]

Ros2InterfaceInfo = provider(
    "Provides sources, IDLs, and dependencies for a ROS2 interface library.",
    fields = [
        "info",
        "deps",
    ],
)

Ros2SourceGeneratorAspectInfo = provider(
    "Provides output files for the C++ generator aspect",
    fields = ["cc_info"],
)

def to_snake_case(not_snake_case):
    """ Converts camel-case to snake-case.

    Based on convert_camel_case_to_lower_case_underscore from rosidl_cmake.
    Unfortunately regex doesn't exist in Bazel.
    Args:
      not_snake_case: a camel-case string.
    Returns:
      A snake-case string.
    """
    result = ""
    not_snake_case_padded = " " + not_snake_case + " "
    for i in range(len(not_snake_case)):
        prev_char, char, next_char = not_snake_case_padded[i:i + 3].elems()
        if char.isupper() and next_char.islower() and prev_char != " ":
            # Insert an underscore before any upper case letter which is not
            # followed by another upper case letter.
            result += "_"
        elif char.isupper() and (prev_char.islower() or prev_char.isdigit()):
            # Insert an underscore before any upper case letter which is
            # preseded by a lower case letter or number.
            result += "_"
        result += char.lower()

    return result

def _get_output_dir(ctx, label, gen_language = None):
    """
    Produces the base output directory for IDL and generated source files given the rule context.
    """
    if gen_language:
        return paths.join(ctx.genfiles_dir.path, label.workspace_root, label.package, label.name, gen_language, label.name)
    else:
        return paths.join(ctx.genfiles_dir.path, label.workspace_root, label.package, label.name)

def _get_include_dir(ctx, label, gen_language):
    return paths.join(ctx.genfiles_dir.path, label.workspace_root, label.package, label.name, gen_language)


def _ros2_interface_library_impl(ctx):
    idl_files = []
    idl_tuples = []
    output_dir = _get_output_dir(ctx, ctx.label)
    for src in ctx.files.srcs:
        root, extension = paths.split_extension(src.basename)
        extension = extension.strip(".")

        f = ctx.actions.declare_file(
            "%s/%s/%s.idl" % (ctx.label.name, extension, root),
        )
        idl_files.append(f)
        idl_tuples.append("%s:%s/%s.idl" % (f.dirname[:-len(extension) - 1], extension, root))

    args = ctx.actions.args()
    args.add("--package", ctx.label.name)
    args.add("--output-dir", output_dir)  # The python script needs to know this so we don't just write to the runfiles root
    args.add_all("--interfaces", ctx.files.srcs)

    ctx.actions.run(
        inputs = ctx.files.srcs,
        outputs = idl_files,
        executable = ctx.executable._adapter,
        arguments = [args],
        progress_message = "Generating idl for %{input}",
    )
    return [
        DefaultInfo(
            files = depset(ctx.files.srcs),
        ),
        Ros2InterfaceInfo(
            info = struct(
                srcs = ctx.files.srcs,
                idl_files = idl_files,
                idl_tuples = idl_tuples,
            ),
            deps = depset(
                direct = [dep[Ros2InterfaceInfo].info for dep in ctx.attr.deps],
                transitive = [dep[Ros2InterfaceInfo].deps for dep in ctx.attr.deps],
            ),
        ),
    ]

ros2_interface_library = rule(
    implementation = _ros2_interface_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".action", ".msg", ".srv"],
            mandatory = True,
        ),
        "deps": attr.label_list(
            providers = [Ros2InterfaceInfo],
        ),
        "_adapter": attr.label(
            default = "@com_github_camearle20_ros2bazel//ros2/tools:rosidl_adapter_wrapper",
            executable = True,
            cfg = "exec",
        ),
    },
)

def _run_cmake_generator(ctx, package_name, output_dir, info, generator, templates, outputs, language, visibility_control_template = None, extra_args = {}):
    # Check that all templates are in the same directory (this is required by the generator)
    template_dir = templates[0].dirname
    for template in templates:
        if template.dirname != template_dir:
            fail("rosidl_cmake templates must all reside in the same directory")

    # Create the JSON arguments file for the generator
    args_dict = {
        "package_name": package_name,
        "idl_tuples": info.idl_tuples,
        "output_dir": output_dir,
        "template_dir": template_dir,
        "target_dependencies": [],
    }
    args_file = ctx.actions.declare_file("%s/%s_args.json" % (package_name, generator.basename))
    ctx.actions.write(args_file, json.encode(args_dict))

    # Create the command line arguments for the generator
    cmd_args = ctx.actions.args()
    cmd_args.add("--generator-arguments-file", args_file.path)
    for argname, argvalue in extra_args.items():
        cmd_args.add(argname, argvalue)

    # Calculate and declare outputs that the generator will produce
    generator_outputs = {}
    for src in info.srcs:
        root, extension = paths.split_extension(src.basename)
        extension = extension.strip(".")
        snake_case_root = to_snake_case(root)
        for out in outputs:
            relative_file = "%s/%s/%s/%s/%s" % (package_name, language, package_name, extension, out % snake_case_root)
            generator_outputs[relative_file] = ctx.actions.declare_file(relative_file)

    # Run the generator
    ctx.actions.run(
        inputs = info.idl_files + templates + [args_file],
        outputs = generator_outputs.values(),
        executable = generator,
        arguments = [cmd_args],
    )

    if visibility_control_template:
        root, _ = paths.split_extension(visibility_control_template.basename)

        # Filename is [name].h.in, so root will be [name].h
        filename = "%s/%s/%s/msg/%s" % (package_name, language, package_name, root)
        visibility_control_h = ctx.actions.declare_file(filename)
        generator_outputs[filename] = visibility_control_h

        ctx.actions.expand_template(
            template = visibility_control_template,
            output = visibility_control_h,
            substitutions = {
                "@PROJECT_NAME@": package_name,
                "@PROJECT_NAME_UPPER@": package_name.upper(),
            },
        )

    return generator_outputs

def _cpp_generator_aspect_impl(target, ctx):
    package_name = target.label.name
    target_info = target[Ros2InterfaceInfo].info
    output_dir = _get_output_dir(ctx, target.label, ctx.attr._language)
    include_dir = _get_include_dir(ctx, target.label, ctx.attr._language)

    has_visibility_control = ctx.attr._has_visibility_control
    interface_visibility_template = ctx.file._interface_visibility_template if has_visibility_control else None
    typesupport_visibility_template = ctx.file._typesupport_visibility_template if has_visibility_control else None
    typesupport_introspection_visibility_template = ctx.file._typesupport_introspection_visibility_template if has_visibility_control else None

    # Run the generators needed for cpp
    outs = dicts.add(
        _run_cmake_generator(
            # c or cpp
            ctx = ctx,
            package_name = package_name,
            output_dir = output_dir,
            info = target_info,
            generator = ctx.executable._interface_generator,
            templates = ctx.files._interface_generator_templates,
            outputs = ctx.attr._interface_outputs,
            language = ctx.attr._language,
            visibility_control_template = interface_visibility_template,
        ),
        _run_cmake_generator(
            # typesupport_c or typesupport_cpp
            ctx = ctx,
            package_name = package_name,
            output_dir = output_dir,
            info = target_info,
            generator = ctx.executable._typesupport_generator,
            templates = ctx.files._typesupport_generator_templates,
            outputs = ctx.attr._typesupport_outputs,
            language = ctx.attr._language,
            extra_args = {"--typesupports": ctx.attr._typesupport_type},
            visibility_control_template = typesupport_visibility_template,
        ),
        _run_cmake_generator(
            # typesupport_introspection_c or typesupport_introspection_cpp
            ctx = ctx,
            package_name = package_name,
            output_dir = output_dir,
            info = target_info,
            generator = ctx.executable._typesupport_introspection_generator,
            templates = ctx.files._typesupport_introspection_generator_templates,
            outputs = ctx.attr._typesupport_introspection_outputs,
            language = ctx.attr._language,
            visibility_control_template = typesupport_introspection_visibility_template,
        ),
    )

    # Generate the compilation configuration for the generated sources
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_config = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    srcs = [f for f in outs.values() if f.extension.startswith("c")]
    hdrs = [f for f in outs.values() if f.extension.startswith("h")]

    dep_compilation_contexts = [dep[CcInfo].compilation_context for dep in ctx.attr._rosidl_deps] + [dep[Ros2SourceGeneratorAspectInfo].cc_info.compilation_context for dep in ctx.rule.attr.deps]
    dep_linking_contexts = [dep[CcInfo].linking_context for dep in ctx.attr._rosidl_deps] + [dep[Ros2SourceGeneratorAspectInfo].cc_info.linking_context for dep in ctx.rule.attr.deps]

    compilation_context, compilation_outputs = cc_common.compile(
        actions = ctx.actions,
        feature_configuration = feature_config,
        cc_toolchain = cc_toolchain,
        srcs = srcs,
        public_hdrs = hdrs,
        includes = [include_dir],
        compilation_contexts = dep_compilation_contexts,
        name = package_name + "_" + ctx.attr._language,
    )

    linking_context, _ = cc_common.create_linking_context_from_compilation_outputs(
        actions = ctx.actions,
        feature_configuration = feature_config,
        cc_toolchain = cc_toolchain,
        compilation_outputs = compilation_outputs,
        name = package_name + "_" + ctx.attr._language,
        linking_contexts = dep_linking_contexts,
        alwayslink = True,  # TODO: determine if this is necessary (do introspection functions get called directly or through pointers?)
    )

    cc_info = CcInfo(
        compilation_context = compilation_context,
        linking_context = linking_context,
    )

    return [Ros2SourceGeneratorAspectInfo(cc_info = cc_info)]

cpp_generator_aspect = aspect(
    implementation = _cpp_generator_aspect_impl,
    attr_aspects = ["deps"],
    attrs = {
        "_interface_generator": attr.label(
            default = "@ros2_rosidl//:generator_cpp",
            executable = True,
            cfg = "exec",
        ),
        "_interface_generator_templates": attr.label(
            default = "@ros2_rosidl//:generator_cpp_templates",
        ),
        "_typesupport_generator": attr.label(
            default = "@ros2_rosidl_typesupport//:typesupport_generator_cpp",
            executable = True,
            cfg = "exec",
        ),
        "_typesupport_generator_templates": attr.label(
            default = "@ros2_rosidl_typesupport//:typesupport_generator_cpp_templates",
        ),
        "_typesupport_introspection_generator": attr.label(
            default = "@ros2_rosidl//:typesupport_introspection_cpp_generator",
            executable = True,
            cfg = "exec",
        ),
        "_typesupport_introspection_generator_templates": attr.label(
            default = "@ros2_rosidl//:typesupport_introspection_cpp_generator_templates",
        ),
        "_rosidl_deps": attr.label_list(
            default = [
                "@ros2_rosidl//:rosidl_runtime_cpp",
                "@ros2_rosidl//:rosidl_typesupport_introspection_cpp",
                "@ros2_rosidl_typesupport//:rosidl_typesupport_cpp",
            ],
        ),
        "_language": attr.string(default = "cpp"),
        "_interface_outputs": attr.string_list(default = _CPP_OUTPUT_HDRS),
        "_typesupport_outputs": attr.string_list(default = _TYPESUPPORT_CPP_OUTPUT_SRCS),
        "_typesupport_introspection_outputs": attr.string_list(default = _TYPESUPPORT_INTROSPECTION_CPP_OUTPUT_HDRS + _TYPESUPPORT_INTROSPECTION_CPP_OUTPUT_SRCS),
        "_typesupport_type": attr.string(default = "rosidl_typesupport_introspection_cpp"),
        "_has_visibility_control": attr.bool(default = False),
        "_cc_toolchain": attr.label(default = "@bazel_tools//tools/cpp:current_cc_toolchain"),
    },
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
    fragments = ["cpp"],
)

c_generator_aspect = aspect(
    implementation = _cpp_generator_aspect_impl,
    attr_aspects = ["deps"],
    attrs = {
        "_interface_generator": attr.label(
            default = "@ros2_rosidl//:generator_c",
            executable = True,
            cfg = "exec",
        ),
        "_interface_generator_templates": attr.label(
            default = "@ros2_rosidl//:generator_c_templates",
        ),
        "_typesupport_generator": attr.label(
            default = "@ros2_rosidl_typesupport//:typesupport_generator_c",
            executable = True,
            cfg = "exec",
        ),
        "_typesupport_generator_templates": attr.label(
            default = "@ros2_rosidl_typesupport//:typesupport_generator_c_templates",
        ),
        "_typesupport_introspection_generator": attr.label(
            default = "@ros2_rosidl//:typesupport_introspection_c_generator",
            executable = True,
            cfg = "exec",
        ),
        "_typesupport_introspection_generator_templates": attr.label(
            default = "@ros2_rosidl//:typesupport_introspection_c_generator_templates",
        ),
        "_rosidl_deps": attr.label_list(
            default = [
                "@ros2_rosidl//:rosidl_runtime_c",
                "@ros2_rosidl//:rosidl_typesupport_introspection_c",
                "@ros2_rosidl_typesupport//:rosidl_typesupport_c",
            ],
        ),
        "_language": attr.string(default = "c"),
        "_interface_outputs": attr.string_list(default = _C_OUTPUT_HDRS + _C_OUTPUT_SRCS),
        "_typesupport_outputs": attr.string_list(default = _TYPESUPPORT_C_OUTPUT_SRCS),
        "_typesupport_introspection_outputs": attr.string_list(default = _TYPESUPPORT_INTROSPECTION_C_OUTPUT_HDRS + _TYPESUPPORT_INTROSPECTION_C_OUTPUT_SRCS),
        "_typesupport_type": attr.string(default = "rosidl_typesupport_introspection_c"),
        "_has_visibility_control": attr.bool(default = True),
        "_interface_visibility_template": attr.label(
            default = "@ros2_rosidl//:generator_c_visibility_template",
            allow_single_file = True,
        ),
        "_typesupport_visibility_template": attr.label(
            default = "@ros2_rosidl_typesupport//:typesupport_generator_c_visibility_template",
            allow_single_file = True,
        ),
        "_typesupport_introspection_visibility_template": attr.label(
            default = "@ros2_rosidl//:typesupport_introspection_c_generator_visibility_template",
            allow_single_file = True,
        ),
        "_cc_toolchain": attr.label(default = "@bazel_tools//tools/cpp:current_cc_toolchain"),
    },
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
    fragments = ["cpp"],
)

def _cpp_generator_impl(ctx):
    cc_infos = [dep[Ros2SourceGeneratorAspectInfo].cc_info for dep in ctx.attr.deps]
    cc_info = cc_common.merge_cc_infos(direct_cc_infos = cc_infos)
    return [cc_info]

ros2_cpp_interface_library = rule(
    implementation = _cpp_generator_impl,
    attrs = {
        "deps": attr.label_list(
            mandatory = True,
            aspects = [cpp_generator_aspect],
            providers = [Ros2InterfaceInfo],
        ),
    },
)

ros2_c_interface_library = rule(
    implementation = _cpp_generator_impl,
    attrs = {
        "deps": attr.label_list(
            mandatory = True,
            aspects = [c_generator_aspect],
            providers = [Ros2InterfaceInfo],
        ),
    },
)

def ros2_all_interface_libraries(name, srcs, deps = [], visibility = None):
    """
    Macro for creating an interface library and all supported language bindings.

    Creates:
    ros2_interface_library: [name]
    ros2_cpp_interface_library: [name]_cpp
    """
    ros2_interface_library(
        name = name,
        srcs = srcs,
        deps = deps,
        visibility = visibility,
    )

    ros2_c_interface_library(
        name = name + "_c",
        deps = [":" + name],
        visibility = visibility,
    )

    ros2_cpp_interface_library(
        name = name + "_cpp",
        deps = [":" + name],
        visibility = visibility,
    )
