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

Ros2InterfaceInfo = provider(
    "Provides sources, IDLs, and dependencies for a ROS2 interface library.",
    fields = [
        "info",
        "deps",
    ],
)

Ros2CppGeneratorAspectInfo = provider(
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

def _get_output_dir(ctx, label):
    """
    Produces the base output directory for IDL and generated source files given the rule context.
    """
    return "%s/%s/%s" % (ctx.genfiles_dir.path, label.package, label.name)

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

def _run_cmake_generator(ctx, package_name, output_dir, info, generator, templates, outputs, extra_args = {}):
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
            relative_file = "%s/%s/%s" % (package_name, extension, out % snake_case_root)
            generator_outputs[relative_file] = ctx.actions.declare_file(relative_file)

    # Run the generator
    ctx.actions.run(
        inputs = info.idl_files + templates + [args_file],
        outputs = generator_outputs.values(),
        executable = generator,
        arguments = [cmd_args],
    )

    return generator_outputs

def _cpp_generator_aspect_impl(target, ctx):
    package_name = target.label.name
    target_info = target[Ros2InterfaceInfo].info
    output_dir = _get_output_dir(ctx, target.label)

    # Run the generators needed for cpp
    outs = dicts.add(
        _run_cmake_generator(
            # cpp
            ctx = ctx,
            package_name = package_name,
            output_dir = output_dir,
            info = target_info,
            generator = ctx.executable._interface_generator,
            templates = ctx.files._interface_generator_templates,
            outputs = _CPP_OUTPUT_HDRS,
        ),
        _run_cmake_generator(
            # typesupport
            ctx = ctx,
            package_name = package_name,
            output_dir = output_dir,
            info = target_info,
            generator = ctx.executable._typesupport_generator,
            templates = ctx.files._typesupport_generator_templates,
            outputs = _TYPESUPPORT_CPP_OUTPUT_SRCS,
            extra_args = {"--typesupports": "rosidl_typesupport_introspection_cpp"},
        ),
        _run_cmake_generator(
            # typesupport_introspection
            ctx = ctx,
            package_name = package_name,
            output_dir = output_dir,
            info = target_info,
            generator = ctx.executable._typesupport_introspection_generator,
            templates = ctx.files._typesupport_introspection_generator_templates,
            outputs = _TYPESUPPORT_INTROSPECTION_CPP_OUTPUT_HDRS + _TYPESUPPORT_INTROSPECTION_CPP_OUTPUT_SRCS,
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

    dep_compilation_contexts = [dep[CcInfo].compilation_context for dep in ctx.attr._rosidl_deps] + [dep[Ros2CppGeneratorAspectInfo].cc_info.compilation_context for dep in ctx.rule.attr.deps]
    dep_linking_contexts = [dep[CcInfo].linking_context for dep in ctx.attr._rosidl_deps] + [dep[Ros2CppGeneratorAspectInfo].cc_info.linking_context for dep in ctx.rule.attr.deps]

    compilation_context, compilation_outputs = cc_common.compile(
        actions = ctx.actions,
        feature_configuration = feature_config,
        cc_toolchain = cc_toolchain,
        srcs = srcs,
        public_hdrs = hdrs,
        includes = [ctx.genfiles_dir.path + "/" + target.label.package],
        compilation_contexts = dep_compilation_contexts,
        name = package_name,
    )

    linking_context, _ = cc_common.create_linking_context_from_compilation_outputs(
        actions = ctx.actions,
        feature_configuration = feature_config,
        cc_toolchain = cc_toolchain,
        compilation_outputs = compilation_outputs,
        name = package_name,
        linking_contexts = dep_linking_contexts,
        alwayslink = True,  # TODO: determine if this is necessary (do introspection functions get called directly or through pointers?)
    )

    cc_info = CcInfo(
        compilation_context = compilation_context,
        linking_context = linking_context
    )

    return [Ros2CppGeneratorAspectInfo(cc_info = cc_info)]

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
        "_cc_toolchain": attr.label(default = "@bazel_tools//tools/cpp:current_cc_toolchain"),
    },
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
    fragments = ["cpp"],
)

def _cpp_generator_impl(ctx):
    cc_infos = [dep[Ros2CppGeneratorAspectInfo].cc_info for dep in ctx.attr.deps]
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
