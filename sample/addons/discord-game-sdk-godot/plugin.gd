# Copyright (c) 2023-present Delano Lourenco
# https://github.com/3ddelano/discord-game-sdk-godot/
# MIT License

@tool
extends EditorPlugin

var _export_plugin = preload("res://addons/discord-game-sdk-godot/export_plugin.gd").new()

func _enable_plugin():
	add_autoload_singleton("Discord_tick", "res://addons/discord-game-sdk-godot/tick.gd")
	add_export_plugin(_export_plugin)


func _disable_plugin():
	remove_autoload_singleton("Discord_tick")
	remove_export_plugin(_export_plugin)
