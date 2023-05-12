## Represents a Discord relationship
class_name DiscordRelationshipData
extends _DiscordDataClass


func _init(): super._init("DiscordRelationshipData")


## What kind of relationship it is.
## One of [enum DiscordSDK.Relationship.RelationshipType]
var type: DiscordSDK.Relationship.RelationshipType
## The user the relationship is for.
var user: DiscordUserData
## That user's current presence.
var presence: DiscordPresenceData


func from_dict(p_dict: Dictionary):
	super.from_dict(p_dict)

	if typeof(p_dict.user) == TYPE_DICTIONARY:
		user = DiscordUserData.new().from_dict(p_dict.user)
	else:
		user = p_dict.user

	if typeof(p_dict.presence) == TYPE_DICTIONARY:
		presence = DiscordPresenceData.new().from_dict(p_dict.presence)
	else:
		presence = p_dict.presence
