## Represents a Discord user's presence
class_name DiscordPresenceData
extends _DiscordDataClass


func _init(): super._init("DiscordPresenceData")


## The user's current online status.
## One of [DiscordSDK.Status].
var status: DiscordSDK.Status
## The user's current activity.
var activity: DiscordActivityData


func from_dict(p_dict: Dictionary):
	super.from_dict(p_dict)

	if typeof(p_dict.activity) == TYPE_DICTIONARY:
		activity = DiscordActivityData.new().from_dict(p_dict.activity)
	else:
		activity = p_dict.activity
