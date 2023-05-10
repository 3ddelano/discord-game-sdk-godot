class_name ActivityView
extends VBoxContainer


func _ready() -> void:
	DiscordSDK.Activity.get_instance().join.connect(_on_join)
	DiscordSDK.Activity.get_instance().spectate.connect(_on_spectate)
	DiscordSDK.Activity.get_instance().join_request.connect(_on_join_request)
	DiscordSDK.Activity.get_instance().invite.connect(_on_invite)


func _on_join(join_secret: String):
	print("----- Activity Join Event: ", join_secret)

func _on_spectate(spectate_secret: String):
	print("----- Activity Spectate Event: ", spectate_secret)

func _on_join_request(user: Dictionary):
	print("----- Activity Join Request Event: ", user)

func _on_invite(type: DiscordSDK.Activity.ActionType, user: Dictionary, activity: Dictionary):
	prints("----- Activity Invite Event:", type, user, activity)
