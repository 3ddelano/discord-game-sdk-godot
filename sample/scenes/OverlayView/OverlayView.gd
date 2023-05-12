extends VBoxContainer

@onready var _is_enabled_label: Label = %IsEnabledLabel
@onready var _is_locked_label: Label = %IsLockedLabel
@onready var _locked_checkbox: CheckBox = %LockedCheckBox
@onready var _set_locked_btn: Button = %SetLockedBtn
@onready var _activity_action_type_option_btn: OptionButton = %ActivityActionTypeOptionButton
@onready var _open_activity_invite_btn: Button = %OpenActivityInviteBtn
@onready var _guild_invite_code_lineedit: LineEdit = %GuildInviteCodeLineEdit
@onready var _open_guild_invite_btn: Button = %OpenGuildInviteBtn
@onready var _open_voice_settings_btn: Button = %OpenVoiceSettingsBtn


func _on_set_locked_btn_pressed():
	var is_locked = _locked_checkbox.button_pressed
	DiscordSDK.Overlay.set_locked(is_locked)
	DiscordSDK.Overlay.get_instance().set_locked_cb.connect(func (res):
		if DiscordSDK.is_error(res):
			Store.log_error("----- Overlay: set_locked: Error: " + DiscordSDK.result_str(res))
			return

		Store.log_info("Overlay:set_locked:Ok")
		_check_booleans()
	)


func _on_open_activity_invite_btn_pressed():
	var activity_type = _activity_action_type_option_btn.get_selected_id()
	DiscordSDK.Overlay.open_activity_invite(activity_type)
	DiscordSDK.Overlay.get_instance().open_activity_invite_cb.connect(func (res):
		if DiscordSDK.is_error(res):
			Store.log_error("----- Overlay: open_activity_invite: Error: " + DiscordSDK.result_str(res))
			return

		Store.log_info("Overlay:open_activity_invite:Ok")
	)


func _on_open_guild_invite_btn_pressed():
	var guild_invite_code = _guild_invite_code_lineedit.text
	if guild_invite_code.is_empty():
		return
	DiscordSDK.Overlay.open_guild_invite(guild_invite_code)
	DiscordSDK.Overlay.get_instance().open_guild_invite_cb.connect(func (res):
		if DiscordSDK.is_error(res):
			Store.log_error("----- Overlay: open_guild_invite: Error: " + DiscordSDK.result_str(res))
			return

		Store.log_info("Overlay:open_guild_invite:Ok")
	)


func _on_open_voice_settings_btn_pressed():
	DiscordSDK.Overlay.open_voice_settings()
	DiscordSDK.Overlay.get_instance().open_voice_settings_cb.connect(func (res):
		if DiscordSDK.is_error(res):
			Store.log_error("----- Overlay: open_voice_settings: Error: " + DiscordSDK.result_str(res))
			return

		Store.log_info("Overlay:open_voice_settings:Ok")
	)


func _ready() -> void:
	DiscordSDK.Overlay.get_instance().toggle.connect(_on_overlay_toggle)
	Store.discord_create.connect(func ():
		_check_booleans()
	)

	_set_locked_btn.pressed.connect(_on_set_locked_btn_pressed)
	_open_activity_invite_btn.pressed.connect(_on_open_activity_invite_btn_pressed)
	_open_guild_invite_btn.pressed.connect(_on_open_guild_invite_btn_pressed)
	_open_voice_settings_btn.pressed.connect(_on_open_voice_settings_btn_pressed)


func _on_overlay_toggle(locked: bool):
	Store.log_info("----- Overlay: Toggle Event: " + str(locked))


func _check_booleans():
	var is_enabled = "Yes" if DiscordSDK.Overlay.is_enabled() else "No"
	_is_enabled_label.text = "Is enabled? - " + is_enabled

	var is_locked = "Yes" if DiscordSDK.Overlay.is_locked() else "No"
	_is_locked_label.text = "Is locked? - " + is_locked
