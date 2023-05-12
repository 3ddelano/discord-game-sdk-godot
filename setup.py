import shutil

lib_folder = "thirdparty/discord_game_sdk/lib/x86_64/"
bin_folder = "sample/addons/discord-game-sdk-godot/bin/"
shutil.copyfile(lib_folder + "discord_game_sdk.so", lib_folder + "libdiscord_game_sdk.so")
shutil.copyfile(lib_folder + "discord_game_sdk.dylib", lib_folder + "libdiscord_game_sdk.dylib")

shutil.copyfile(lib_folder + "discord_game_sdk.dll", bin_folder + "discord_game_sdk.dll")
shutil.copyfile(lib_folder + "libdiscord_game_sdk.so", bin_folder + "libdiscord_game_sdk.so")
shutil.copyfile(lib_folder + "libdiscord_game_sdk.dylib", bin_folder + "libdiscord_game_sdk.dylib")
