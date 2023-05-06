extends Control

@onready var CLIENT_ID := int(Env.get_var("CLIENT_ID")) # Paste your own here
@onready var APPLICATION_ID := int(Env.get_var("APPLICATION_ID")) # Paste your own here

@export var _views_path: NodePath
@onready var views = get_node(_views_path) as VBoxContainer


func _ready() -> void:
	print("Ready!")
	Store._main_node = self

	# Boilerplate code
	var create_res = DiscordSDK.Core.create(CLIENT_ID)
	if create_res != DiscordSDK.Result.Ok:
		print("Failed to create DiscordGameSDK: Got result %s" % DiscordSDK.result_str(create_res))
		return
	DiscordSDK.User.get_instance().connect("current_user_update", Callable(self, "_on_current_user_update"))

	Store.emit_signal("discord_create")

	# Debug purpose
	_on_tab_pressed()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_QUOTELEFT: # ` key to toggle Logs
			Store.get_view("Logs").visible = not Store.get_view("Logs").visible
		elif event.keycode == KEY_TAB:
			_on_tab_pressed()


# Dev testing stuff
func _on_tab_pressed():
	print("Tab pressed")

	# ----- Activity
#	print("----- Activity: register_command: ", DiscordSDK.Activity.register_command("https://google.com"))
#	print("----- Activity: register_steam: ", DiscordSDK.Activity.register_steam(12345))
#
	var activity = DiscordSDK.Activity.Activity.new()
	activity.application_id = APPLICATION_ID
	activity.state = "This is the state"
	activity.details = "Here is the details"
	activity.timestamp_start = 5
	activity.asset_large_image = "logo_vertical_color"
	activity.asset_large_text = "This is large text"
	activity.asset_small_image = "nativescript"
	activity.asset_small_text = "This is small text"
	activity.party_id = "foobar123"
	activity.party_size_current = 1
	activity.party_size_max = 50
	activity.secrets_match = "foobar matchSecret"
	activity.secrets_join = "foobar joinSecret"
	activity.secrets_spectate = "foobar spectateSecret"
	activity.instance = true

	print(activity)
	DiscordSDK.Activity.update_activity(activity)
	print("----- Activity: update_activity: result::", DiscordSDK.result_str(await DiscordSDK.Activity.get_instance().update_activity_cb))

#	await get_tree().create_timer(3).timeout
#	DiscordSDK.Activity.clear_activity()
#	print("----- Activity: clear_activity: result::", DiscordSDK.result_str(await DiscordSDK.Activity.get_instance().clear_activity_cb))


	# ----- Overlay
#	print("----- Overlay: is_enabled: ", DiscordSDK.Overlay.is_enabled())
#	print("----- Overlay: is_locked: ", DiscordSDK.Overlay.is_locked())

#	DiscordSDK.Overlay.open_activity_invite(DiscordSDK.Activity.ActionType.Join)
#	print("---- Overlay: open_activity_invite: result::", DiscordSDK.result_str(await DiscordSDK.Overlay.get_instance().open_activity_invite_cb))

#	DiscordSDK.Overlay.open_guild_invite("some code")
#	print("---- Overlay: open_guild_invite: result::", DiscordSDK.result_str(await DiscordSDK.Overlay.get_instance().open_guild_invite_cb))

#	DiscordSDK.Overlay.open_voice_settings()
#	print("---- Overlay: open_voice_settings: result::", DiscordSDK.result_str(await DiscordSDK.Overlay.get_instance().open_voice_settings_cb))
	DiscordSDK.User.get_user(321233875776962560)
	print("----- User: get user id=321233875776962560", await DiscordSDK.User.get_instance().get_user_cb)

	print("----- User: get_current_user_premium_type: ", DiscordSDK.User.get_current_user_premium_type())
	print("----- User: current_user_has_flag: Partner=", DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.Partner))
	print("----- User: current_user_has_flag: HypeSquadEvents=", DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.HypeSquadEvents))
	print("----- User: current_user_has_flag: HypeSquadHouse1=", DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.HypeSquadHouse1))
	print("----- User: current_user_has_flag: HypeSquadHouse2=", DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.HypeSquadHouse2))
	print("----- User: current_user_has_flag: HypeSquadHouse3=", DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.HypeSquadHouse3))


func _on_current_user_update():
	# ----- User
	print("----- User: get_current_user: ", DiscordSDK.User.get_current_user())



func get_view_manager():
	return views


