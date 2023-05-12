class_name DiscordActivityData
extends _DiscordDataClass

func _init(): super._init("DiscordActivityData")

var type: DiscordSDK.Activity.ActivityType
var application_id: int
var name: String
var state: String
var details: String

# Timestamp
var timestamp_start: int
var timestamp_end: int

# Asset
var asset_large_image: String
var asset_large_text: String
var asset_small_image: String
var asset_small_text: String

# Party
var party_id: String
var party_size_current: int
var party_size_max: int
var party_privacy: DiscordSDK.Activity.PartyPrivacy

# Secrets
var secrets_match: String
var secrets_join: String
var secrets_spectate: String

var instance: bool
