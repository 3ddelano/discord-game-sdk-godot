#!/usr/bin/env python
import os
import sys
import shutil


def copy_file(expected_filepath: str, source_filepath: str):
    # Get absolute paths relative to the SConstruct file location
    base_dir = Dir('.').abspath
    abs_expected = os.path.join(base_dir, expected_filepath)
    abs_source = os.path.join(base_dir, source_filepath)
    print(f"Copying {abs_source} to {abs_expected}")
    shutil.copyfile(abs_source, abs_expected)

env = SConscript("godot-cpp/SConstruct")
lib_name = "libdgs"
plugin_bin_folder = "sample/addons/discord-game-sdk-godot/bin"
discord_game_sdk_folder = "thirdparty/discord_game_sdk/"


# Add source files
env.Append(CPPPATH=["src/", discord_game_sdk_folder + "c/"])
sources = Glob("src/*.cpp")

arch = env["arch"]
platform = env["platform"]
build_target = env["target"]

dgs_lib_path = discord_game_sdk_folder + "lib/"
dgs_lib_name = "discord_game_sdk"
if arch == "x86_64":
    dgs_lib_path += "x86_64/"
elif arch == "arm64":
    dgs_lib_path += "aarch64/"

env.Append(LIBPATH=[dgs_lib_path])

if platform == "windows":
    env.Append(LIBS=["discord_game_sdk.dll"])
else:
    copy_file(dgs_lib_path + "lib" + dgs_lib_name + ".dylib", dgs_lib_path + dgs_lib_name + ".dylib")
    env.Append(LIBS=["discord_game_sdk"])



genv = env
def on_complete(target, source, env):
    if platform == "macos":
        framework_folder = plugin_bin_folder + f"/macos/{lib_name}.{platform}.{build_target}.framework"
        copy_file(framework_folder + "/" + dgs_lib_name + ".dylib", dgs_lib_path + dgs_lib_name + ".dylib")
        lib_path = f"{framework_folder}/{lib_name}.{platform}.{build_target}"
        print(f"Setting install name for {lib_path}")
        os.system(f"install_name_tool -change @rpath/discord_game_sdk.dylib @loader_path/discord_game_sdk.dylib {lib_path}")


if env["platform"] == "macos":
    library = env.SharedLibrary(
        f"{plugin_bin_folder}/{platform}/{lib_name}.{env['platform']}.{env['target']}.framework/{lib_name}.{env['platform']}.{env['target']}",
        source=sources,)
else:
    library = env.SharedLibrary(
        f"{plugin_bin_folder}/{platform}/{lib_name}{env['suffix']}{env['SHLIBSUFFIX']}",
        source=sources,
    )


complete_command = Command('complete', library, on_complete)
Depends(complete_command, library)
Default(complete_command)
