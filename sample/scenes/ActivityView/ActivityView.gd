extends VBoxContainer


func _ready() -> void:
	DiscordSDK.Activity.get_instance().join.connect(_on_join)
	DiscordSDK.Activity.get_instance().spectate.connect(_on_spectate)
	DiscordSDK.Activity.get_instance().join_request.connect(_on_join_request)
	DiscordSDK.Activity.get_instance().invite.connect(_on_invite)


func _on_join(join_secret: String):
	Store.log_info("Activity Join Event: join_secret=" + str(join_secret))


func _on_spectate(spectate_secret: String):
	Store.log_info("Activity Spectate Event: spectate_secret=" + str(spectate_secret))


func _on_join_request(user: DiscordUserData):
	Store.log_info("Activity Join Request Event: user=" + str(user))


func _on_invite(type: DiscordSDK.Activity.ActionType, user: DiscordUserData, activity: DiscordActivityData):
	Store.log_info("Activity Invite Event: type=" + str(type) + " user=" + str(user) + " activity=" + str(activity))
