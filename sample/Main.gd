extends Control

# Testing IDs
const CLIENT_ID := 928212232213520454 # Paste your own here
const APPLICATION_ID := 928212232213520454 # Paste your own here

@onready var views: VBoxContainer = %ViewManager


func _ready() -> void:
	Store._main_node = self

	if CLIENT_ID == 0:
		Store.log_error("CLIENT_ID is not set in Main.gd")
		return
	if APPLICATION_ID == 0:
		Store.log_error("APPLICATION_ID is not set in Main.gd")
		return

	# Setup Discord GameSDK
	var create_res = DiscordSDK.Core.create(CLIENT_ID)
	if DiscordSDK.is_error(create_res):
		Store.log_error("Failed to create Discord GameSDK: Got result %s" % DiscordSDK.result_str(create_res))
		if create_res == DiscordSDK.Result.InternalError:
			Store.log_error("Is the Discord desktop app running?")
		return
	Store.log_info("Core: create: Ok - Initialized Discord GameSDK")

	Store.discord_create.emit()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_QUOTELEFT: # ` key to toggle Logs
			Store.get_view("Logs").visible = not Store.get_view("Logs").visible
		elif event.keycode == KEY_TAB:
			_on_tab_pressed()


# Dev testing stuff
func _on_tab_pressed():
	print("Tab key pressed")

	# ----- Activity
#	print("Activity: register_command: ", DiscordSDK.Activity.register_command("https://google.com"))
#	print("Activity: register_steam: ", DiscordSDK.Activity.register_steam(12345))
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
#	print("Activity: update_activity: result::", DiscordSDK.result_str(await DiscordSDK.Activity.get_instance().update_activity_cb))

#	await get_tree().create_timer(3).timeout
#	DiscordSDK.Activity.clear_activity()
#	print("Activity: clear_activity: result::", DiscordSDK.result_str(await DiscordSDK.Activity.get_instance().clear_activity_cb))


	# ----- Overlay
#	print("Overlay: is_enabled: ", DiscordSDK.Overlay.is_enabled())
#	print("Overlay: is_locked: ", DiscordSDK.Overlay.is_locked())

#	DiscordSDK.Overlay.open_activity_invite(DiscordSDK.Activity.ActionType.Join)
#	print("---- Overlay: open_activity_invite: result::", DiscordSDK.result_str(await DiscordSDK.Overlay.get_instance().open_activity_invite_cb))

#	DiscordSDK.Overlay.open_guild_invite("some code")
#	print("---- Overlay: open_guild_invite: result::", DiscordSDK.result_str(await DiscordSDK.Overlay.get_instance().open_guild_invite_cb))

#	DiscordSDK.Overlay.open_voice_settings()
#	print("---- Overlay: open_voice_settings: result::", DiscordSDK.result_str(await DiscordSDK.Overlay.get_instance().open_voice_settings_cb))


func get_view_manager():
	return views
