extends PanelContainer

@onready var _steamid_lineedit: LineEdit = %SteamLineEdit
@onready var _btn: Button = %RegisterSteamBtn


func _on_btn_pressed():
	var steam_id = _steamid_lineedit.text
	if steam_id.is_empty():
		return

	var res = DiscordSDK.Activity.register_steam(int(steam_id))
	if DiscordSDK.is_error(res):
		Store.log_error("----- Activity: register_steam: Error: " + DiscordSDK.result_str(res))
		return

	Store.log_info("Activity:register_steam:Ok")


func _ready() -> void:
	_btn.pressed.connect(_on_btn_pressed)
