class_name LogsView
extends VBoxContainer

@onready var logs_label = $PC/SC/LogsLabel


func _ready() -> void:
	DiscordSDK.Core.get_instance().connect("discord_log", Callable(self, "_on_discord_log"))
	Store.connect("discord_create", func ():
		DiscordSDK.Core.set_log_level(DiscordSDK.Core.LogLevel.Debug)
	)


func _on_discord_log(msg: Dictionary):
	log_msg(msg.level, msg.message)


func log_msg(level: int, msg: String):
	var color = "#ffffff"
	var level_str = "Info"
	match level:
		DiscordSDK.Core.LogLevel.Debug:
			color = "#aaaaaa"
			level_str = "Debug"
		DiscordSDK.Core.LogLevel.Warn:
			color = "#ffff00"
			level_str = "Warn"
		DiscordSDK.Core.LogLevel.Error:
			color = "#bb0000"
			level_str = "Error"


	var darkened_color = Color(color).darkened(0.2).to_html(true)
	var richtext = "[color=#%s]%s | [/color][color=%s]%s\n[/color]" % [darkened_color, level_str, color, msg]

	print_rich(richtext)

	logs_label.text += richtext
	logs_label.get_parent().set_deferred("scroll_vertical", 100000)
