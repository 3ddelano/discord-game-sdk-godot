extends Label


func _ready() -> void:
	var config = ConfigFile.new()
	var _err = config.load("res://addons/discord-game-sdk-godot/plugin.cfg")
	var version = config.get_value("plugin", "version")
	text = "v" + version
