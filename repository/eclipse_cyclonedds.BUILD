load("@//:deps.bzl", "CYCLONEDDS_VERSION")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

# ddsrt

_ddsrt_base_hdrs = [
    "src/ddsrt/include/dds/config.h",  # Generated
    "src/ddsrt/include/dds/features.h",  # Generated
    "src/ddsrt/include/dds/version.h",  # Generated
    "src/ddsrt/include/dds/export.h",  # Generated
    "src/ddsrt/include/dds/ddsrt/avl.h",
    "src/ddsrt/include/dds/ddsrt/fibheap.h",
    "src/ddsrt/include/dds/ddsrt/hopscotch.h",
    "src/ddsrt/include/dds/ddsrt/log.h",
    "src/ddsrt/include/dds/ddsrt/retcode.h",
    "src/ddsrt/include/dds/ddsrt/attributes.h",
    "src/ddsrt/include/dds/ddsrt/endian.h",
    "src/ddsrt/include/dds/ddsrt/arch.h",
    "src/ddsrt/include/dds/ddsrt/misc.h",
    "src/ddsrt/include/dds/ddsrt/mh3.h",
    "src/ddsrt/include/dds/ddsrt/io.h",
    "src/ddsrt/include/dds/ddsrt/process.h",
    "src/ddsrt/include/dds/ddsrt/sched.h",
    "src/ddsrt/include/dds/ddsrt/strtod.h",
    "src/ddsrt/include/dds/ddsrt/strtol.h",
    "src/ddsrt/include/dds/ddsrt/types.h",
    "src/ddsrt/include/dds/ddsrt/countargs.h",
    "src/ddsrt/include/dds/ddsrt/static_assert.h",
    "src/ddsrt/include/dds/ddsrt/circlist.h",
    "src/ddsrt/include/dds/ddsrt/atomics.h",
    "src/ddsrt/include/dds/ddsrt/atomics/arm.h",
    "src/ddsrt/include/dds/ddsrt/atomics/gcc.h",
    "src/ddsrt/include/dds/ddsrt/atomics/msvc.h",
    "src/ddsrt/include/dds/ddsrt/atomics/sun.h",
    "src/ddsrt/include/dds/ddsrt/dynlib.h",
    "src/ddsrt/include/dds/ddsrt/environ.h",
    "src/ddsrt/include/dds/ddsrt/heap.h",
    "src/ddsrt/include/dds/ddsrt/ifaddrs.h",
    "src/ddsrt/include/dds/ddsrt/md5.h",
    "src/ddsrt/include/dds/ddsrt/netstat.h",
    "src/ddsrt/include/dds/ddsrt/string.h",
    "src/ddsrt/include/dds/ddsrt/sockets.h",
    "src/ddsrt/src/sockets_priv.h",
    "src/ddsrt/include/dds/ddsrt/threads.h",
    "src/ddsrt/src/threads_priv.h",
    "src/ddsrt/include/dds/ddsrt/cdtors.h",
    "src/ddsrt/include/dds/ddsrt/random.h",
    # Added manually (not in CMake for some reason)
    "src/ddsrt/include/dds/ddsrt/sync.h",
    "src/ddsrt/include/dds/ddsrt/time.h",
    "src/ddsrt/include/dds/ddsrt/bswap.h",
    "src/ddsrt/include/dds/ddsrt/filesystem.h",
    "src/ddsrt/include/dds/ddsrt/iovec.h",
    "src/ddsrt/include/dds/ddsrt/expand_vars.h",
    "src/ddsrt/include/dds/ddsrt/xmlparser.h",
    "src/ddsrt/include/dds/ddsrt/rusage.h",
]

_ddsrt_win32_hdrs = [
    "src/ddsrt/include/dds/ddsrt/sockets/windows.h",
    "src/ddsrt/include/dds/ddsrt/filesystem/windows.h",
    "src/ddsrt/include/dds/ddsrt/sync/windows.h",
    "src/ddsrt/include/dds/ddsrt/threads/windows.h",
    "src/ddsrt/include/dds/ddsrt/types/windows.h",
]

_ddsrt_posix_hdrs = [
    "src/ddsrt/include/dds/ddsrt/sockets/posix.h",
    "src/ddsrt/include/dds/ddsrt/filesystem/posix.h",
    "src/ddsrt/include/dds/ddsrt/sync/posix.h",
    "src/ddsrt/include/dds/ddsrt/threads/posix.h",
    "src/ddsrt/include/dds/ddsrt/types/posix.h",
]

_ddsrt_base_srcs = [
    "src/ddsrt/src/atomics.c",
    "src/ddsrt/src/avl.c",
    "src/ddsrt/src/bswap.c",
    "src/ddsrt/src/io.c",
    "src/ddsrt/src/log.c",
    "src/ddsrt/src/retcode.c",
    "src/ddsrt/src/strtod.c",
    "src/ddsrt/src/strtol.c",
    "src/ddsrt/src/mh3.c",
    "src/ddsrt/src/environ.c",
    "src/ddsrt/src/expand_vars.c",
    "src/ddsrt/src/fibheap.c",
    "src/ddsrt/src/hopscotch.c",
    "src/ddsrt/src/circlist.c",
    "src/ddsrt/src/threads.c",
    "src/ddsrt/src/string.c",
    "src/ddsrt/src/sockets.c",
    "src/ddsrt/src/md5.c",
    "src/ddsrt/src/xmlparser.c",
    "src/ddsrt/src/ifaddrs.c",
    "src/ddsrt/src/cdtors.c",
    "src/ddsrt/src/random.c",
    "src/ddsrt/src/time.c",
]

_ddsrt_win32_srcs = [
    "src/ddsrt/src/ifaddrs/windows/ifaddrs.c",
    "src/ddsrt/src/sockets/windows/socket.c",
    "src/ddsrt/src/sockets/windows/gethostname.c",
    "src/ddsrt/src/dynlib/windows/dynlib.c",
    "src/ddsrt/src/environ/windows/environ.c",
    "src/ddsrt/src/filesystem/windows/filesystem.c",
    "src/ddsrt/src/netstat/windows/netstat.c",
    "src/ddsrt/src/process/windows/process.c",
    "src/ddsrt/src/random/windows/random.c",
    "src/ddsrt/src/rusage/windows/rusage.c",
    "src/ddsrt/src/sync/windows/sync.c",
    "src/ddsrt/src/threads/windows/threads.c",
    "src/ddsrt/src/time/windows/time.c",
]

_ddsrt_posix_srcs = [
    "src/ddsrt/src/ifaddrs/posix/ifaddrs.c",
    "src/ddsrt/src/sockets/posix/socket.c",
    "src/ddsrt/src/sockets/posix/gethostname.c",
    "src/ddsrt/src/dynlib/posix/dynlib.c",
    "src/ddsrt/src/environ/posix/environ.c",
    "src/ddsrt/src/filesystem/posix/filesystem.c",
    "src/ddsrt/src/process/posix/process.c",
    "src/ddsrt/src/random/posix/random.c",
    "src/ddsrt/src/sync/posix/sync.c",
    "src/ddsrt/src/threads/posix/threads.c",
    "src/ddsrt/src/rusage/posix/rusage.c",
]

_ddsrt_linux_srcs = [
    "src/ddsrt/src/netstat/linux/netstat.c",
    "src/ddsrt/src/time/posix/time.c",
]

_ddsrt_macos_srcs = [
    "src/ddsrt/src/netstat/darwin/netstat.c",
    "src/ddsrt/src/time/darwin/time.c",
]

_ddsrt_export_content = """
#ifndef DDS_EXPORT_H
#define DDS_EXPORT_H

#ifdef DDS_STATIC_DEFINE
#  define DDS_EXPORT
#  define DDS_NO_EXPORT
#else
#  ifndef DDS_EXPORT
#    ifdef ddsrt_internal_EXPORTS
        /* We are building this library */
#      define DDS_EXPORT 
#    else
        /* We are using this library */
#      define DDS_EXPORT 
#    endif
#  endif

#  ifndef DDS_NO_EXPORT
#    define DDS_NO_EXPORT 
#  endif
#endif

#ifndef DDS_DEPRECATED
#  define DDS_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef DDS_DEPRECATED_EXPORT
#  define DDS_DEPRECATED_EXPORT DDS_EXPORT DDS_DEPRECATED
#endif

#ifndef DDS_DEPRECATED_NO_EXPORT
#  define DDS_DEPRECATED_NO_EXPORT DDS_NO_EXPORT DDS_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef DDS_NO_DEPRECATED
#    define DDS_NO_DEPRECATED
#  endif
#endif

#ifndef DDS_INLINE_EXPORT
#  if __MINGW32__ && (!defined(__clang__) || !defined(ddsrt_internal_EXPORTS))
#    define DDS_INLINE_EXPORT
#  else
#    define DDS_INLINE_EXPORT DDS_EXPORT
#  endif
#endif

#endif /* DDS_EXPORT_H */
"""

_ddsrt_version_content = """
#ifndef DDS_VERSION_H
#define DDS_VERSION_H

#define DDS_VERSION "{version}"
#define DDS_VERSION_MAJOR {major}
#define DDS_VERSION_MINOR {minor}
#define DDS_VERSION_PATCH {patch}
#define DDS_VERSION_TWEAK 
#define DDS_PROJECT_NAME "CycloneDDS"

#define DDS_HOST_NAME "bazel"
#define DDS_TARGET_NAME "bazel"

#endif
""".format(
    major = CYCLONEDDS_VERSION.split(".")[0],
    minor = CYCLONEDDS_VERSION.split(".")[1],
    patch = CYCLONEDDS_VERSION.split(".")[2],
    version = CYCLONEDDS_VERSION,
)

_ddsrt_features_base = [
    "#define DDS_HAS_SECURITY 1",
    "#define DDS_HAS_LIFESPAN 1",
    "#define DDS_HAS_DEADLINE_MISSED 1",
    "#define DDS_HAS_NETWORK_PARTITIONS 1",
    "#define DDS_HAS_SSM 1",
]

_ddsrt_config_base = [
    "#define DDSRT_HAVE_DYNLIB 1",
    "#define DDSRT_HAVE_FILESYSTEM 1",
    "#define DDSRT_HAVE_NETSTAT 1",
    "#define DDSRT_HAVE_RUSAGE 1",
    "#define DDSRT_HAVE_IPV6 1",
    "#define DDSRT_HAVE_DNS 1",
    "#define DDSRT_HAVE_GETADDRINFO 1",
    "#define DDSRT_HAVE_GETHOSTNAME 1",
    "#define DDSRT_HAVE_INET_NTOP 1",
    "#define DDSRT_HAVE_INET_PTON 1",
]

_ddsrt_config_linux = [
    "#define DDSRT_HAVE_GETHOSTBYNAME_R 1",
]

write_file(
    name = "ddsrt_export",
    out = "src/ddsrt/include/dds/export.h",
    content = [_ddsrt_export_content],
)

write_file(
    name = "ddsrt_version",
    out = "src/ddsrt/include/dds/version.h",
    content = [_ddsrt_version_content],
)

write_file(
    name = "ddsrt_features",
    out = "src/ddsrt/include/dds/features.h",
    content = [
        "#ifndef _DDS_PUBLIC_FEATURES_H_",
        "#define _DDS_PUBLIC_FEATURES_H_",
    ] + _ddsrt_features_base + ["#endif"],
)

write_file(
    name = "ddsrt_config",
    out = "src/ddsrt/include/dds/config.h",
    content = [
        "#ifndef DDS_CONFIG_H",
        "#define DDS_CONFIG_H",
    ] + _ddsrt_config_base + select({
        "@platforms//os:linux": _ddsrt_config_linux,
        "//conditions:default": [],
    }) + ["#endif"],
)

cc_library(
    name = "ddsrt",
    srcs = _ddsrt_base_srcs + select({
        "@platforms//os:linux": _ddsrt_posix_srcs + _ddsrt_linux_srcs,
        "@platforms//os:macos": _ddsrt_posix_srcs + _ddsrt_macos_srcs,
        "@platforms//os:windows": _ddsrt_win32_srcs,
    }),
    hdrs = _ddsrt_base_hdrs + select({
        "@platforms//os:linux": _ddsrt_posix_hdrs,
        "@platforms//os:macos": _ddsrt_posix_hdrs,
        "@platforms//os:windows": _ddsrt_win32_hdrs,
    }),
    copts = ["-Iexternal/eclipse_cyclonedds/src/ddsrt/src"],
    includes = ["src/ddsrt/include"],
    linkopts = select({
        "@platforms//os:linux": ["-lpthread"],
        "@platforms//os:macos": ["-lpthread"],
        "@platforms//os:windows": [
            "/DEFAULTLIB:ws2_32.lib",
            "/DEFAULTLIB:iphlpapi.lib",
            "-Wl:bcrypt.lib",
        ],
    }),
    visibility = ["//visibility:public"],
)

# ddsi

_ddsi_base_hdrs = [
    "src/core/ddsi/include/dds/ddsi/ddsi_ssl.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_tcp.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_tran.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_udp.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_raweth.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_vnet.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_ipaddr.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_locator.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_mcgroup.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_plist_generic.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_security_util.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_security_omg.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_portmapping.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_handshake.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_serdata.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_sertype.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_serdata_default.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_serdata_pserop.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_serdata_plist.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_sertopic.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_statistics.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_iid.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_tkmap.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_vendor.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_threadmon.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_builtin_topic_if.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_rhc.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_guid.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_keyhash.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_entity_index.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_deadline.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_deliver_locally.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_domaingv.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_plist.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_xqos.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_cdrstream.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_time.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_ownip.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_cfgunits.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_cfgelems.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_config.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_config_impl.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_acknack.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_list_tmpl.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_list_genptr.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_wraddrset.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_typelib.h",
    "src/core/ddsi/include/dds/ddsi/q_addrset.h",
    "src/core/ddsi/include/dds/ddsi/q_bitset.h",
    "src/core/ddsi/include/dds/ddsi/q_bswap.h",
    "src/core/ddsi/include/dds/ddsi/q_ddsi_discovery.h",
    "src/core/ddsi/include/dds/ddsi/q_debmon.h",
    "src/core/ddsi/include/dds/ddsi/q_entity.h",
    "src/core/ddsi/include/dds/ddsi/q_feature_check.h",
    "src/core/ddsi/include/dds/ddsi/q_freelist.h",
    "src/core/ddsi/include/dds/ddsi/q_gc.h",
    "src/core/ddsi/include/dds/ddsi/q_hbcontrol.h",
    "src/core/ddsi/include/dds/ddsi/q_lat_estim.h",
    "src/core/ddsi/include/dds/ddsi/q_lease.h",
    "src/core/ddsi/include/dds/ddsi/q_log.h",
    "src/core/ddsi/include/dds/ddsi/q_misc.h",
    "src/core/ddsi/include/dds/ddsi/q_pcap.h",
    "src/core/ddsi/include/dds/ddsi/q_protocol.h",
    "src/core/ddsi/include/dds/ddsi/q_qosmatch.h",
    "src/core/ddsi/include/dds/ddsi/q_radmin.h",
    "src/core/ddsi/include/dds/ddsi/q_receive.h",
    "src/core/ddsi/include/dds/ddsi/q_rtps.h",
    "src/core/ddsi/include/dds/ddsi/q_sockwaitset.h",
    "src/core/ddsi/include/dds/ddsi/q_thread.h",
    "src/core/ddsi/include/dds/ddsi/q_transmit.h",
    "src/core/ddsi/include/dds/ddsi/q_inverse_uint32_set.h",
    "src/core/ddsi/include/dds/ddsi/q_unused.h",
    "src/core/ddsi/include/dds/ddsi/q_whc.h",
    "src/core/ddsi/include/dds/ddsi/q_xevent.h",
    "src/core/ddsi/include/dds/ddsi/q_xmsg.h",
    "src/core/ddsi/include/dds/ddsi/sysdeps.h",

    # Added manually:
    "src/core/ddsi/include/dds/ddsi/ddsi_lifespan.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_security_exchange.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_typewrap.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_typelookup.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_xt_typeinfo.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_xt_typemap.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_security_msg.h",
    "src/core/ddsi/include/dds/ddsi/q_init.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_pmd.h",
    "src/core/ddsi/include/dds/ddsi/ddsi_xt_typelookup.h",
    "src/core/ddsi/src/ddsi_cdrstream_write.part.c",
    "src/core/ddsi/src/ddsi_cdrstream_keys.part.c",
]

_ddsc_base_hdrs = [
    "src/core/ddsc/include/dds/dds.h",
    "src/core/ddsc/include/dds/ddsc/dds_public_error.h",
    "src/core/ddsc/include/dds/ddsc/dds_public_impl.h",
    "src/core/ddsc/include/dds/ddsc/dds_public_listener.h",
    "src/core/ddsc/include/dds/ddsc/dds_public_qos.h",
    "src/core/ddsc/include/dds/ddsc/dds_public_qosdefs.h",
    "src/core/ddsc/include/dds/ddsc/dds_public_status.h",
    "src/core/ddsc/include/dds/ddsc/dds_statistics.h",
    "src/core/ddsc/include/dds/ddsc/dds_rhc.h",
    "src/core/ddsc/include/dds/ddsc/dds_internal_api.h",
    "src/core/ddsc/include/dds/ddsc/dds_opcodes.h",
    "src/core/ddsc/include/dds/ddsc/dds_data_allocator.h",
    "src/core/ddsc/include/dds/ddsc/dds_loan_api.h",

    # Added manually:
    "src/core/ddsc/include/dds/ddsc/dds_basic_types.h",
    "src/core/ddsc/include/dds/ddsc/dds_public_alloc.h",
]

_security_api_base_hdrs = [
    "src/security/api/include/dds/security/dds_security_api.h",
    "src/security/api/include/dds/security/dds_security_api_access_control.h",
    "src/security/api/include/dds/security/dds_security_api_authentication.h",
    "src/security/api/include/dds/security/dds_security_api_cryptography.h",
    "src/security/api/include/dds/security/dds_security_api_defs.h",
    "src/security/api/include/dds/security/dds_security_api_err.h",
    "src/security/api/include/dds/security/dds_security_api_types.h",
]

_security_core_base_hdrs = [
    "src/security/core/include/dds/security/core/dds_security_fsm.h",
    "src/security/core/include/dds/security/core/dds_security_plugins.h",
    "src/security/core/include/dds/security/core/dds_security_serialize.h",
    "src/security/core/include/dds/security/core/dds_security_timed_cb.h",
    "src/security/core/include/dds/security/core/dds_security_types.h",
    "src/security/core/include/dds/security/core/dds_security_utils.h",
    "src/security/core/include/dds/security/core/shared_secret.h",
]

_security_core_base_srcs = [
    "src/security/core/src/dds_security_fsm.c",
    "src/security/core/src/dds_security_plugins.c",
    "src/security/core/src/dds_security_serialize.c",
    "src/security/core/src/dds_security_timed_cb.c",
    "src/security/core/src/dds_security_utils.c",
    "src/security/core/src/shared_secret.c",
]

_ddsi_base_srcs = [
    "src/core/ddsi/src/ddsi_eth.c",
    "src/core/ddsi/src/ddsi_ssl.c",
    "src/core/ddsi/src/ddsi_tcp.c",
    "src/core/ddsi/src/ddsi_tran.c",
    "src/core/ddsi/src/ddsi_udp.c",
    "src/core/ddsi/src/ddsi_raweth.c",
    "src/core/ddsi/src/ddsi_vnet.c",
    "src/core/ddsi/src/ddsi_ipaddr.c",
    "src/core/ddsi/src/ddsi_mcgroup.c",
    "src/core/ddsi/src/ddsi_security_util.c",
    "src/core/ddsi/src/ddsi_security_omg.c",
    "src/core/ddsi/src/ddsi_portmapping.c",
    "src/core/ddsi/src/ddsi_handshake.c",
    "src/core/ddsi/src/ddsi_serdata.c",
    "src/core/ddsi/src/ddsi_serdata_default.c",
    "src/core/ddsi/src/ddsi_serdata_pserop.c",
    "src/core/ddsi/src/ddsi_serdata_plist.c",
    "src/core/ddsi/src/ddsi_sertype.c",
    "src/core/ddsi/src/ddsi_sertype_default.c",
    "src/core/ddsi/src/ddsi_sertype_pserop.c",
    "src/core/ddsi/src/ddsi_sertype_plist.c",
    "src/core/ddsi/src/ddsi_sertopic.c",
    "src/core/ddsi/src/ddsi_statistics.c",
    "src/core/ddsi/src/ddsi_iid.c",
    "src/core/ddsi/src/ddsi_tkmap.c",
    "src/core/ddsi/src/ddsi_vendor.c",
    "src/core/ddsi/src/ddsi_threadmon.c",
    "src/core/ddsi/src/ddsi_rhc.c",
    "src/core/ddsi/src/ddsi_pmd.c",
    "src/core/ddsi/src/ddsi_entity_index.c",
    "src/core/ddsi/src/ddsi_deadline.c",
    "src/core/ddsi/src/ddsi_deliver_locally.c",
    "src/core/ddsi/src/ddsi_plist.c",
    "src/core/ddsi/src/ddsi_cdrstream.c",
    "src/core/ddsi/src/ddsi_config.c",
    "src/core/ddsi/src/ddsi_time.c",
    "src/core/ddsi/src/ddsi_ownip.c",
    "src/core/ddsi/src/ddsi_acknack.c",
    "src/core/ddsi/src/ddsi_list_genptr.c",
    "src/core/ddsi/src/ddsi_wraddrset.c",
    "src/core/ddsi/src/ddsi_typelib.c",
    "src/core/ddsi/src/q_addrset.c",
    "src/core/ddsi/src/q_bitset_inlines.c",
    "src/core/ddsi/src/q_bswap.c",
    "src/core/ddsi/src/q_ddsi_discovery.c",
    "src/core/ddsi/src/q_debmon.c",
    "src/core/ddsi/src/q_entity.c",
    "src/core/ddsi/src/q_gc.c",
    "src/core/ddsi/src/q_init.c",
    "src/core/ddsi/src/q_lat_estim.c",
    "src/core/ddsi/src/q_lease.c",
    "src/core/ddsi/src/q_misc.c",
    "src/core/ddsi/src/q_pcap.c",
    "src/core/ddsi/src/q_qosmatch.c",
    "src/core/ddsi/src/q_radmin.c",
    "src/core/ddsi/src/q_receive.c",
    "src/core/ddsi/src/q_sockwaitset.c",
    "src/core/ddsi/src/q_thread.c",
    "src/core/ddsi/src/q_transmit.c",
    "src/core/ddsi/src/q_inverse_uint32_set.c",
    "src/core/ddsi/src/q_whc.c",
    "src/core/ddsi/src/q_xevent.c",
    "src/core/ddsi/src/q_xmsg.c",
    "src/core/ddsi/src/q_freelist.c",
    "src/core/ddsi/src/sysdeps.c",

    # Added manually
    "src/core/ddsi/src/ddsi_lifespan.c",
    "src/core/ddsi/src/ddsi_security_exchange.c",
    "src/core/ddsi/src/ddsi_eth.h",
]

_ddsc_base_srcs = [
    "src/core/ddsc/src/dds_alloc.c",
    "src/core/ddsc/src/dds_builtin.c",
    "src/core/ddsc/src/dds_coherent.c",
    "src/core/ddsc/src/dds_participant.c",
    "src/core/ddsc/src/dds_reader.c",
    "src/core/ddsc/src/dds_writer.c",
    "src/core/ddsc/src/dds_init.c",
    "src/core/ddsc/src/dds_publisher.c",
    "src/core/ddsc/src/dds_rhc.c",
    "src/core/ddsc/src/dds_rhc_default.c",
    "src/core/ddsc/src/dds_domain.c",
    "src/core/ddsc/src/dds_instance.c",
    "src/core/ddsc/src/dds_qos.c",
    "src/core/ddsc/src/dds_handles.c",
    "src/core/ddsc/src/dds_entity.c",
    "src/core/ddsc/src/dds_matched.c",
    "src/core/ddsc/src/dds_querycond.c",
    "src/core/ddsc/src/dds_topic.c",
    "src/core/ddsc/src/dds_listener.c",
    "src/core/ddsc/src/dds_read.c",
    "src/core/ddsc/src/dds_waitset.c",
    "src/core/ddsc/src/dds_readcond.c",
    "src/core/ddsc/src/dds_guardcond.c",
    "src/core/ddsc/src/dds_statistics.c",
    "src/core/ddsc/src/dds_subscriber.c",
    "src/core/ddsc/src/dds_write.c",
    "src/core/ddsc/src/dds_whc.c",
    "src/core/ddsc/src/dds_whc_builtintopic.c",
    "src/core/ddsc/src/dds_serdata_builtintopic.c",
    "src/core/ddsc/src/dds_sertype_builtintopic.c",
    "src/core/ddsc/src/dds_data_allocator.c",
    "src/core/ddsc/src/dds_loan.c",
    "src/core/ddsc/src/dds__alloc.h",
    "src/core/ddsc/src/dds__builtin.h",
    "src/core/ddsc/src/dds__domain.h",
    "src/core/ddsc/src/dds__handles.h",
    "src/core/ddsc/src/dds__entity.h",
    "src/core/ddsc/src/dds__init.h",
    "src/core/ddsc/src/dds__listener.h",
    "src/core/ddsc/src/dds__participant.h",
    "src/core/ddsc/src/dds__publisher.h",
    "src/core/ddsc/src/dds__qos.h",
    "src/core/ddsc/src/dds__querycond.h",
    "src/core/ddsc/src/dds__readcond.h",
    "src/core/ddsc/src/dds__guardcond.h",
    "src/core/ddsc/src/dds__reader.h",
    "src/core/ddsc/src/dds__rhc_default.h",
    "src/core/ddsc/src/dds__statistics.h",
    "src/core/ddsc/src/dds__subscriber.h",
    "src/core/ddsc/src/dds__topic.h",
    "src/core/ddsc/src/dds__types.h",
    "src/core/ddsc/src/dds__write.h",
    "src/core/ddsc/src/dds__writer.h",
    "src/core/ddsc/src/dds__whc.h",
    "src/core/ddsc/src/dds__whc_builtintopic.h",
    "src/core/ddsc/src/dds__serdata_builtintopic.h",
    "src/core/ddsc/src/dds__get_status.h",
    "src/core/ddsc/src/dds__data_allocator.h",

    # Added manually:
    "src/core/ddsc/src/dds__loan.h",
]

cc_library(
    name = "ddsc",
    srcs = _ddsi_base_srcs + _ddsc_base_srcs + _security_core_base_srcs,
    hdrs = _ddsi_base_hdrs + _ddsc_base_hdrs + _security_api_base_hdrs + _security_core_base_hdrs,
    copts = ["-Iexternal/cyclonedds/src/core/ddsc/src"],
    includes = [
        "src/core/ddsc/include",
        "src/core/ddsi/include",
        "src/security/api/include",
        "src/security/core/include",
    ],
    deps = [":ddsrt"],
)
