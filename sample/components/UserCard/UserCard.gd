class_name UserCard
extends PanelContainer

signal loaded

var user = null
var activity = null
var status = null

var premium_type: DiscordSDK.User.PremiumType
var has_partner = false
var has_hypesquad = false
var has_hype1 = false
var has_hype2 = false
var has_hype3 = false


@onready var avatar = %Avatar as NetworkImage
@onready var username_label = %UsernameLabel
@onready var bot_tag = %BotTag
@onready var id_label = %IDLabel as IDLabel
@onready var premium_label = %PremiumLabel
@onready var flags_label = %FlagsLabel
@onready var status_container = %Status
@onready var activity_container = %Activity
@onready var activity_type_label = %ActivityTypeLabel
@onready var activity_name_label = %ActivityNameLabel
@onready var activity_details_label = %ActivityDetailsLabel
@onready var activity_state_label = %ActivityStateLabel


func reset():
	username_label.text = "Username#1000"
	bot_tag.visible = true
	id_label.set_text_custom("Id")
	avatar.reset()
	_reset_status()
	_reset_activity()


func set_activity(p_activity: DiscordActivityData):
	activity = p_activity
	_update_activity()


func set_status(p_status: int):
	status = p_status
	_update_status()


func set_user(p_user: DiscordUserData):
	user = p_user
	reset()

	username_label.text = user["username"]
	if not user["discriminator"].is_empty():
		username_label.text += "#" + user["discriminator"]

	bot_tag.visible = user["bot"]
	id_label.set_text_custom(str(user["id"]))
	if not user["avatar"].is_empty():
		avatar.visible = true
		avatar.fetch_image("https://cdn.discordapp.com/avatars/%s/%s.png" % [str(user["id"]), user["avatar"]])
	else:
		avatar.visible = false
		call_deferred("emit_signal", "loaded")


func set_premium_type(new_value: DiscordSDK.User.PremiumType):
	premium_type = new_value
	_update_labels()


func set_partner(new_value: bool):
	has_partner = new_value
	_update_labels()


func set_hypesquad(new_value: bool):
	has_hypesquad = new_value
	_update_labels()


func set_hype1(new_value: bool):
	has_hype1 = new_value
	_update_labels()


func set_hype2(new_value: bool):
	has_hype2 = new_value
	_update_labels()


func set_hype3(new_value: bool):
	has_hype3 = new_value
	_update_labels()


func _ready():
	reset()
	_update_labels()

	avatar.loaded.connect(func ():
		loaded.emit())


func _update_labels():
	# Get the string representation of the PremiumType
	var premium_type_idx = DiscordSDK.User.PremiumType.values().find(premium_type)
	var premium_type_str = DiscordSDK.User.PremiumType.keys()[premium_type_idx]
	if premium_type_str:
		premium_label.text = "Premium: " + premium_type_str
	if premium_type != DiscordSDK.User.PremiumType.None:
		premium_label.visible = true
	else:
		premium_label.visible = false

	var flags = []
	if has_partner:
		flags.append("Partner")
	if has_hypesquad:
		flags.append("HypeSquadEvents")
	if has_hype1:
		flags.append("HypeSquadHouse1")
	if has_hype2:
		flags.append("HypeSquadHouse2")
	if has_hype3:
		flags.append("HypeSquadHouse3")

	var flags_str = " | ".join(flags)
	if flags_str:
		flags_label.text = "Flags: " + flags_str
		flags_label.visible = true
	else:
		flags_label.visible = false


func _reset_activity():
	activity_container.visible = false
	activity_type_label.text = ""
	activity_name_label.text = ""
	activity_details_label.text = ""
	activity_state_label.text = ""


func _update_activity():
	if activity == null:
		_reset_activity()
		return

	match activity.type:
		DiscordSDK.Activity.ActivityType.Playing:
			activity_type_label.text = "PLAYING A GAME"
		DiscordSDK.Activity.ActivityType.Streaming:
			activity_type_label.text = "STREAMING"
		DiscordSDK.Activity.ActivityType.Listening:
			activity_type_label.text = "LISTENING"
		DiscordSDK.Activity.ActivityType.Watching:
			activity_type_label.text = "WATCHING"

	activity_type_label.visible = not activity_name_label.text.is_empty()
	activity_name_label.text = activity.name
	activity_name_label.visible = not activity_name_label.text.is_empty()
	activity_details_label.text = activity.details
	activity_details_label.visible = not activity_details_label.text.is_empty()
	activity_state_label.text = activity.state
	activity_state_label.visible = not activity_state_label.text.is_empty()
	activity_container.visible = true


func _reset_status():
	status_container.visible = false


func _update_status():
	if status == null:
		_reset_status()
		return

	for child in status_container.get_children():
		child.visible = false

	status_container.get_child(status).visible = true
	status_container.visible = true

