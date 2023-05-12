# Copyright (c) 2023-present Delano Lourenco
# https://github.com/3ddelano/discord-game-sdk-godot/
# MIT License

## A high level class to interact with the Discord GameSDK.
class_name DiscordSDK
extends RefCounted


## A result from Discord GameSDK
enum Result {
	Ok = 0, ## Everything is good
	ServiceUnavailable = 1, ## Discord isn't working
	InvalidVersion = 2, ## The SDK version may be outdated
	LockFailed = 3, ## An internal error on transactional operations
	InternalError = 4, ## Something on our side went wrong
	InvalidPayload = 5, ## The data you sent didn't match what we expect
	InvalidCommand = 6, ## That's not a thing you can do
	InvalidPermissions = 7, ## You aren't authorized to do that
	NotFetched = 8, ## Couldn't fetch what you wanted
	NotFound = 9, ## What you're looking for doesn't exist
	Conflict = 10, ## User already has a network connection open on that channel
	InvalidSecret = 11, ## Activity secrets must be unique and not match party id
	InvalidJoinSecret = 12, ## Join request for that user does not exist
	NoEligibleActivity = 13, ## You accidentally set an ApplicationId in your UpdateActivity() payload
	InvalidInvite = 14, ## Your game invite is no longer valid
	NotAuthenticated = 15, ## The internal auth call failed for the user, and you can't do this
	InvalidAccessToken = 16, ## The user's bearer token is invalid
	ApplicationMismatch = 17, ## Access token belongs to another application
	InvalidDataUrl = 18, ## Something internally went wrong fetching image data
	InvalidBase64 = 19, ## Not valid Base64 data
	NotFiltered = 20, ## You're trying to access the list before creating a stable list with Filter()
	LobbyFull = 21, ## The lobby is full
	InvalidLobbySecret = 22, ## The secret you're using to connect is wrong
	InvalidFilename = 23, ## File name is too long
	InvalidFileSize = 24, ## File is too large
	InvalidEntitlement = 25, ## The user does not have the right entitlement for this game
	NotInstalled = 26, ## Discord is not installed
	NotRunning = 27, ## Discord is not running
	InsufficientBuffer = 28, ## Insufficient buffer space when trying to write
	PurchaseCancelled = 29, ## User cancelled the purchase flow
	InvalidGuild = 30, ## Discord guild does not exist
	InvalidEvent = 31, ## The event you're trying to subscribe to does not exist
	InvalidChannel = 32, ## Discord channel does not exist
	InvalidOrigin = 33, ## The origin header on the socket does not match what you've registered (you should not see this)
	RateLimited = 34, ## You are calling that method too quickly
	OAuth2Error = 35, ## The OAuth2 process failed at some point
	SelectChannelTimeout = 36, ## The user took too long selecting a channel for an invite
	GetGuildTimeout = 37, ## Took too long trying to fetch the guild
	SelectVoiceForceRequired = 38, ## Push to talk is required for this channel
	CaptureShortcutAlreadyListening = 39, ## That push to talk shortcut is already registered
	UnauthorizedForAchievement = 40, ## Your application cannot update this achievement
	InvalidGiftCode = 41, ## The gift code is not valid
	PurchaseError = 42, ## Something went wrong during the purchase flow
	TransactionAborted = 43, ## Purchase flow aborted because the SDK is being torn down
}

enum Status {
	Offline = 0,
	Online = 1,
	Idle = 2,
	DoNotDisturb = 3,
}


## Prints the result of a Discord GameSDK function
## `p_result` can either be an integer representing the Result enum or a Dictionary/Object that has a `result` key.
static func print_result(p_result) -> void:
	print_rich("[b]Discord Result[/b]:%s[code](%s)[/code]" % [result_str(p_result), p_result])


## Returns the English string of a Discord GameSDK result.
## `p_result` can either be an integer representing the Result enum or a Dictionary/Object that has a `result` key.
static func result_str(p_result) -> String:
	if typeof(p_result) == TYPE_DICTIONARY:
		p_result = p_result["result"]
	var idx := Result.values().find(p_result)
	return Result.keys()[idx]


## Returns whether the Discord GameSDK result is error or not.
## `p_result` can either be an integer representing the Result enum or a Dictionary/Object that has a `result` key.
static func is_error(p_result) -> bool:
	if typeof(p_result) == TYPE_DICTIONARY:
		p_result = p_result["result"]
	return p_result != Result.Ok


# Handles initializing the Discord GameSDK
class Core:
	## Fired when Discord GameSDK logs something
	## It depends on what the log level is set to
	## See set_log_level()
	signal discord_log(log_msg: Dictionary)

	enum CreateFlags {
		Default = 0, ## Requires Discord to be running to play the game
		NoRequireDiscord = 1, ## Does not require Discord to be running, use this on other platforms
	}

	enum LogLevel {
		Error = 1, ## Log only errors
		Warn, ## Log warnings and errors
		Info, ## Log info, warnings, and errors
		Debug, ## Log all the things!
	}

	static func get_instance():
		return IDGSCore

	static func create(p_client_id: int, flags := CreateFlags.NoRequireDiscord) -> Result:
		return IDGSCore.create_core(p_client_id, flags)

	static func set_log_level(p_min_level: LogLevel) -> void:
		IDGSCore.set_log_level(p_min_level)

	static func destroy():
		IDGSCore.destroy()


## Handles activities in Discord GameSDK
class Activity:
	signal accept_invite_cb(result: Result)
	signal clear_activity_cb(result: Result)
	signal invite(data: Dictionary)
	signal join(join_secret: String)
	signal join_request(user: Dictionary)
	signal send_invite_cb(result: Result)
	signal send_request_reply_cb(result: Result)
	signal spectate(spectate_secret: String)
	signal update_activity_cb(result: Result)


	enum ActivityType {
		Playing,
		Streaming,
		Listening,
		Watching,
	}

	enum PartyPrivacy {
		Private = 0,
		Public = 1,
	}

	enum ActionType {
		Join = 1,
		Spectate,
	}

	enum JoinRequestReply {
		No,
		Yes,
		Ignore,
	}

	class ActivityData extends BaseClass:
		func _init(): super._init("Activity")

		var type: ActivityType
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
		var party_privacy: PartyPrivacy

		# Secrets
		var secrets_match: String
		var secrets_join: String
		var secrets_spectate: String

		var instance: bool

	static func get_instance():
		return IDGSActivity

	static func register_command(p_command: String) -> Result:
		return IDGSActivity.register_command(p_command)

	static func register_steam(p_steam_id: int) -> Result:
		return IDGSActivity.register_steam(p_steam_id)

	static func update_activity(p_activity: ActivityData) -> void:
		IDGSActivity.update_activity(p_activity)

	static func clear_activity() -> void:
		IDGSActivity.clear_activity()

	static func send_request_reply(p_user_id: int, p_reply: JoinRequestReply) -> void:
		IDGSActivity.send_request_reply(p_user_id, p_reply)

	static func send_invite(p_user_id: int, p_type: ActionType, p_content: String) -> void:
		IDGSActivity.send_invite(p_user_id, p_type, p_content)

	static func accept_invite(p_user_id: int) -> void:
		IDGSActivity.accept_invite(p_user_id)


class Overlay:
	static func get_instance():
		return IDGSOverlay

	static func is_enabled() -> bool:
		return IDGSOverlay.is_enabled()

	static func is_locked() -> bool:
		return IDGSOverlay.is_locked()

	static func set_locked(p_locked: bool) -> void:
		IDGSOverlay.set_locked(p_locked)

	static func open_activity_invite(p_type: Activity.ActionType) -> void:
		IDGSOverlay.open_activity_invite(p_type)

	static func open_guild_invite(p_code: String) -> void:
		IDGSOverlay.open_guild_invite(p_code)

	static func open_voice_settings() -> void:
		IDGSOverlay.open_voice_settings()


class User:
	enum UserFlag {
		Partner = 2,
		HypeSquadEvents = 4,
		HypeSquadHouse1 = 64,
		HypeSquadHouse2 = 128,
		HypeSquadHouse3 = 256,
	}

	enum PremiumType {
		None = 0,
		Tier1 = 1,
		Tier2 = 2,
	}

	static func get_instance():
		return IDGSUser

	static func get_current_user() -> Dictionary:
		return IDGSUser.get_current_user()

	static func get_user(p_user_id: int) -> void:
		IDGSUser.get_user(p_user_id)

	static func get_current_user_premium_type() -> Dictionary:
		return IDGSUser.get_current_user_premium_type()

	static func current_user_has_flag(p_flag: UserFlag) -> Dictionary:
		return IDGSUser.current_user_has_flag(p_flag)


class Relationship:
	enum RelationshipType {
		None,
		Friend,
		Blocked,
		PendingIncoming,
		PendingOutgoing,
		Implicit,
	}

	static func get_instance():
		return IDGSRelationship

#	static func count() -> Dictionary:
#		return IDGSRelationship.count()

	static func filter(p_filter_func: Callable) -> Array[Dictionary]:
		# Workaround for filtering Relationship since I was unable to get Callable to work in GDExtension
		# So we load all the relationships and filter them in GDScript
		IDGSRelationship.filter()
		var relationships: Array[Dictionary] = []
		var count: int = IDGSRelationship.count().count

		for i in range(count):
			var relationship = IDGSRelationship.get_at(i).relationship
			if not p_filter_func.call(relationship):
				continue
			relationships.append(relationship)
		return relationships

	static func get_user(p_user_id: int) -> Dictionary:
		return IDGSRelationship.get_user(p_user_id)

#	static func get_at(p_index: int) -> Dictionary:
#		return IDGSRelationship.get_at(p_index)
