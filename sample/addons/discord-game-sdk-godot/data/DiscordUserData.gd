## Represents a Discord user.
class_name DiscordUserData
extends _DiscordDataClass


func _init(): super._init("DiscordUserData")


## The user's ID.
var id: int
## The user's username.
var username: String
## The user's discriminator.
var discriminator: String
## The user's avatar hash.
var avatar: String
## Whether the user is a bot or not.
var bot: bool
