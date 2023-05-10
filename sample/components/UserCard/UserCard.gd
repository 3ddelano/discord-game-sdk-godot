class_name UserCard
extends PanelContainer

signal loaded

var user = {}
var premium_type: DiscordSDK.User.PremiumType
var has_partner = false
var has_hypesquad = false
var has_hype1 = false
var has_hype2 = false
var has_hype3 = false


@onready var avatar: NetworkImage = %Avatar
@onready var username_label = %UsernameLabel
@onready var bot_tag = %BotTag
@onready var id_label = %IdLabel
@onready var premium_label = %PremiumLabel
@onready var flags_label = %FlagsLabel


func reset():
	username_label.text = "Username#1000"
	bot_tag.visible = true
	id_label.text = "Id"
	avatar.reset()


func set_user(p_user: Dictionary):
	user = p_user

	if user == null:
		reset()
		return

	username_label.text = user["username"] + "#" + user["discriminator"]
	bot_tag.visible = user["bot"]
	id_label.text = str(user["id"])
	if user["avatar"]:
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
