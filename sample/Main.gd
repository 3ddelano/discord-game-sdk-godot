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

	print("----- Activity: register_command: ", DiscordSDK.Activity.register_command("https://google.com"))
	print("----- Activity: register_steam: ", DiscordSDK.Activity.register_steam(12345))

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

	# print(activity)
	DiscordSDK.Activity.update_activity(activity)
	print("----- Activity: update_activity: result::", DiscordSDK.result_str(await DiscordSDK.Activity.get_instance().update_activity))

	await get_tree().create_timer(3).timeout
	DiscordSDK.Activity.clear_activity()
	print("----- Activity: clear_activity: result::", DiscordSDK.result_str(await DiscordSDK.Activity.get_instance().clear_activity))






func get_view_manager():
	return views


