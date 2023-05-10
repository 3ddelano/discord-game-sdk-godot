# Copyright (c) 2023-present Delano Lourenco
# https://github.com/3ddelano/discord-game-sdk-godot/
# MIT License

@tool
extends EditorPlugin

func _enable_plugin():
	add_autoload_singleton("Discord_tick", "res://addons/discord-game-sdk-godot/tick.gd")


func _disable_plugin():
	remove_autoload_singleton("Discord_tick")
