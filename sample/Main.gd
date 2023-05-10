extends Control

@onready var CLIENT_ID := int(Env.get_var("CLIENT_ID", 0)) # Paste your own here
@onready var APPLICATION_ID := int(Env.get_var("APPLICATION_ID", 0)) # Paste your own here

@export var _views_path: NodePath
@onready var views = get_node(_views_path) as VBoxContainer


func _ready() -> void:
	if CLIENT_ID == 0:
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "CLIENT_ID is not set")
	if APPLICATION_ID == 0:
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "APPLICATION_ID is not set")

	print("Ready!")
	Store._main_node = self

	# Boilerplate code
	DiscordSDK.Relationship.get_instance().refresh.connect(_on_refresh)
	var create_res = DiscordSDK.Core.create(CLIENT_ID)
	if DiscordSDK.is_error(create_res):
		print("Failed to create DiscordGameSDK: Got result %s" % DiscordSDK.result_str(create_res))
		return

	print("Initialzized DiscordGameSDK!")
	Store.discord_create.emit()

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
#	var activity = DiscordSDK.Activity.ActivityData.new()
#	activity.application_id = APPLICATION_ID
#	activity.state = "This is the state"
#	activity.details = "Here is the details"
#	activity.timestamp_start = 5
#	activity.asset_large_image = "logo_vertical_color"
#	activity.asset_large_text = "This is large image text"
#	activity.asset_small_image = "nativescript"
#	activity.asset_small_text = "This is small text"
#	activity.party_id = "foobar123"
#	activity.party_size_current = 1
#	activity.party_size_max = 50
#	activity.secrets_match = "foobar matchSecret"
#	activity.secrets_join = "foobar joinSecret"
#	activity.secrets_spectate = "foobar spectateSecret"
#	activity.instance = true
#
#	print(activity)
#	DiscordSDK.Activity.update_activity(activity)
#	print("----- Activity: update_activity: result::", DiscordSDK.result_str(await DiscordSDK.Activity.get_instance().update_activity_cb))

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


func get_view_manager():
	return views


func _on_refresh():
	DiscordSDK.Relationship.filter(Callable(self, "_on_refresh"))

	# ----- Relationships
	print("----- Relationship: count: ", DiscordSDK.Relationship.count())
	print("----- Relationship: get_user: ", DiscordSDK.Relationship.get_user(321233875776962560))
	print("----- Relationship: get_user: ", DiscordSDK.Relationship.get_user(753103238332416050))
	print("----- Relationship: get_user: ", DiscordSDK.Relationship.get_at(1))
	print('a')

