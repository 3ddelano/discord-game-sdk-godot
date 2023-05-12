extends PanelContainer

@onready var _cmd_lineedit: LineEdit = %CmdLineEdit
@onready var _btn: Button = %RegisterCommandBtn


func _on_btn_pressed():
	var cmd = _cmd_lineedit.text
	if cmd.is_empty():
		return

	var res = DiscordSDK.Activity.register_command(cmd)
	if DiscordSDK.is_error(res):
		Store.log_error("----- Activity: register_command: Error: " + DiscordSDK.result_str(res))
		return

	Store.log_info("Activity:register_command:Ok")


func _ready() -> void:
	_btn.pressed.connect(_on_btn_pressed)
