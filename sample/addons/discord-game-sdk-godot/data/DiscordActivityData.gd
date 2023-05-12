# Represents a Discord activity
class_name DiscordActivityData
extends _DiscordDataClass


func _init(): super._init("DiscordActivityData")


## The type of activity. One of [enum DiscordSDK.Activity.ActivityType].
var type: DiscordSDK.Activity.ActivityType
## Your application ID.
var application_id: int
## Name of the application.
var name: String
## The player's current party status.
var state: String
## What the player is currently doing.
var details: String

# Timestamp
## Unix timestamp - Set this to have an "elapsed" timer.
var timestamp_start: int
## Unix timestamp - Set this to have an "remaining" timer.
var timestamp_end: int

# Asset
## Image key for the large image.
var asset_large_image: String
## Hover text for the large image.
var asset_large_text: String
## Image key for the small image.
var asset_small_image: String
## Hover text for the small image.
var asset_small_text: String

# Party
## A unique identifier for this party.
var party_id: String
## The current size of the party.
var party_size_current: int
## The max possible size of the party
var party_size_max: int
## Privacy state of the party. One of [enum DiscordSDK.Activity.PartyPrivacy].
var party_privacy: DiscordSDK.Activity.PartyPrivacy

# Secrets
## Unique hash for the given match context.
var secrets_match: String
## Unique hash for chat invites and Ask to Join.
var secrets_join: String
## Unique hash for Spectate button.
var secrets_spectate: String

## Whether this activity is an instanced context, like a match.
var instance: bool
