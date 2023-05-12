class_name DiscordPresenceData
extends _DiscordDataClass

func _init(): super._init("DiscordPresenceData")


var status: DiscordSDK.Status
var activity: DiscordActivityData


func from_dict(p_dict: Dictionary):
	super.from_dict(p_dict)

	if typeof(p_dict.activity) == TYPE_DICTIONARY:
		activity = DiscordActivityData.new().from_dict(p_dict.activity)
	else:
		activity = p_dict.activity
