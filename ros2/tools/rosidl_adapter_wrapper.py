# Wraps the ROS2 IDL generator, since it wants absolute paths in the tuples.

import sys
import os
import argparse
import pathlib

from rosidl_adapter import convert_to_idl

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--package")
    parser.add_argument("--output-dir")
    parser.add_argument("--interfaces", nargs="+")
    args = parser.parse_args()
    for interface in args.interfaces:
        path = pathlib.Path(os.path.abspath(interface))
        abs_idl_file = convert_to_idl(
            path.parent,
            args.package,
            path.relative_to(path.parent),
            pathlib.Path(os.path.join(args.output_dir))
        )
