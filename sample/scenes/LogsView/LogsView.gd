class_name LogsView
extends VBoxContainer

@onready var logs_label = $PC/SC/LogsLabel


func _ready() -> void:
	DiscordSDK.Core.get_instance().discord_log.connect(_on_discord_log)

	Store.discord_create.connect(func ():
		DiscordSDK.Core.set_log_level(DiscordSDK.Core.LogLevel.Debug)
	)


func _on_discord_log(msg: DiscordLogData):
	log_msg(msg.level, msg.message)


func log_msg(level: DiscordSDK.Core.LogLevel, msg: String):
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
	var richtext = "[color=#%s]%s | [/color][color=%s]%s[/color]" % [darkened_color, level_str, color, msg]

	print_rich(richtext)
	logs_label.text += richtext + "\n"
