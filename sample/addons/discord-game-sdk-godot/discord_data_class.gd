# Copyright (c) 2022-present Delano Lourenco
# https://github.com/3ddelano/dataclasses-godot
# MIT License

## Class from the dataclasses-godot plugin to use in the Discord GameSDK Godot 4.x plugin.
## @tutorial(Dataclasses Godot): https://github.com/3ddelano/dataclasses-godot
class_name _DiscordDataClass
extends Dataclass


func _init(p_name: String, p_options: Dictionary = {}):
	super._init(p_name, p_options)
	p_options["print_newline"] = true
