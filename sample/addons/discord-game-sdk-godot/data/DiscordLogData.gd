## Represents a Discord log message
class_name DiscordLogData
extends _DiscordDataClass

func _init(): super._init("DiscordLogData")

## The log level of the message.
## One of [enum DiscordSDK.Core.LogLevel]
var level: DiscordSDK.Core.LogLevel
## The contents of the message
var msg: String
