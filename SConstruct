#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")
lib_name = "libdgs"
bin_folder = "sample/addons/discord-game-sdk-godot/bin"

discord_game_sdk_folder = "thirdparty/discord_game_sdk/"

# For reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# Add source files
env.Append(CPPPATH=["src/", discord_game_sdk_folder + "c/"])
sources = Glob("src/*.cpp")

if env["platform"] == "windows":
    env.Append(LIBS=["discord_game_sdk.dll"])
env.Append(LIBPATH=[discord_game_sdk_folder + "lib/x86_64/"])


if env["platform"] == "macos":
    library = env.SharedLibrary(
        f"{bin_folder}/{lib_name}.{env['platform']}.{env['target']}.framework/{lib_name}.{env['platform']}.{env['target']}",
        source=sources,)
else:
    library = env.SharedLibrary(
        f"{bin_folder}/{lib_name}{env['suffix']}{env['SHLIBSUFFIX']}",
        source=sources,
    )

Default(library)
