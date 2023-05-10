# Copyright (c) 2023-present Delano Lourenco
# https://github.com/3ddelano/discord-game-sdk-godot/
# MIT License

@tool
extends EditorExportPlugin

func _get_name() -> String:
	return "Discord Game SDK Godot"

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int):
	print("\n\n----------------")
	printt(features)
	var target_platform = features[2]

	match target_platform:
		"windows":
			add_shared_object("res://addons/discord-game-sdk-godot/bin/discord_game_sdk.dll", [], "/")
		"linux":
			add_shared_object("res://addons/discord-game-sdk-godot/bin/discord_game_sdk.so", [], "/")
		"macos":
			add_shared_object("res://addons/discord-game-sdk-godot/bin/discord_game_sdk.dylib", [], "/")
