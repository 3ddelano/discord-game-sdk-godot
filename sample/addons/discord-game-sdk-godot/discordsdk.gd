# Copyright (c) 2023-present Delano Lourenco
# https://github.com/3ddelano/discord-game-sdk-godot/
# MIT License

## A high level class to interact with the Discord GameSDK.
##
## Contains useful enums and functions for using the Discord GameSDK.
##
## @tutorial(Sample project): https://github.com/3ddelano/discord-game-sdk-godot/
class_name DiscordSDK
extends RefCounted


## A result from Discord GameSDK.
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

## A Discord user's presence status.
enum Status {
	Offline = 0, ## The user is offline
	Online = 1, ## The user is online
	Idle = 2, ## The user is idle
	DoNotDisturb = 3, ## The user is in Do Not Disturb mode
}


## Prints the result of a Discord GameSDK function.
## [param p_result] can either be an integer representing the [enum Result] enum or a [Dictionary] / [Object] that has a [code]result[/code] key.
static func print_result(p_result) -> void:
	print_rich("[b]Discord Result[/b]:%s[code](%s)[/code]" % [result_str(p_result), p_result])


## Returns the English string of a Discord GameSDK result.
## [param p_result] can either be an integer representing the [enum Result] enum or a [Dictionary] / [Object] that has a [code]result[/code] key.
static func result_str(p_result) -> String:
	if typeof(p_result) == TYPE_DICTIONARY:
		p_result = p_result["result"]
	var idx := Result.values().find(p_result)
	return Result.keys()[idx]


## Returns whether the Discord GameSDK result is an error or not.
## [param p_result] can either be an integer representing the [enum Result] enum or a [Dictionary] / [Object] that has a [code]result[/code] key.[br]
## Example with an [enum Result].
## [codeblock]
## var result = DiscordSDK.Result.InternalError
## if DiscordSDK.is_error(result):
##     print("Result is not Ok!")
##     print("Result is " + DiscordSDK.result_str(result))
## [/codeblock][br]
## Example with a [Dictionary].
## [codeblock]
## var result = await DiscordSDK.Activity.get_instance().update_activity_cb
## if DiscordSDK.is_error(result):
##     print("Result is not Ok!")
##     print("Result is " + DiscordSDK.result_str(result))
## [/codeblock]
static func is_error(p_result) -> bool:
	if typeof(p_result) == TYPE_DICTIONARY:
		p_result = p_result["result"]
	return p_result != Result.Ok


## Handles initializing the Discord GameSDK
## @tutorial(Sample project): https://github.com/3ddelano/discord-game-sdk-godot/
class Core:
	## Fired when Discord GameSDK logs something.
	## It depends on what the log level is set to in [method set_log_level][br]
	## Example:
	## [codeblock]
	## func _ready():
	##     # Connect to the signal
	##     DiscordSDK.Core.get_instance().discord_log.connect(_on_discord_log)
	##     ...
	##
	## func _on_discord_log(log_msg: DiscordLogData):
	##     print(str(log_msg.level) + " " + log_msg.message)
	## [/codeblock]
	signal discord_log(log_msg: DiscordLogData)


	## Flags to use when creating the Discord GameSDK core.
	enum CreateFlags {
		Default = 0, ## Requires Discord to be running to play the game
		NoRequireDiscord = 1, ## Does not require Discord to be running, use this on other platforms
	}

	## Log level to use when logging Discord GameSDK messages.
	enum LogLevel {
		Error = 1, ## Log only errors
		Warn, ## Log warnings and errors
		Info, ## Log info, warnings, and errors
		Debug, ## Log all the things!
	}


	## Get the active instance of the Discord Core singleton. [b]Use this when connecting signals.[/b]
	static func get_instance():
		return IDGSCore

	## Initializes the Discord GameSDK core.[br]
	## [param p_client_id] - The Client ID of the Discord application (from Discord Developer Portal)[br]
	## [param p_flags]: [enum CreateFlags] - The flags to initialize the Discord GameSDK with[br]
	## returns: [enum DiscordSDK.Result]
	static func create(p_client_id: int, p_flags := CreateFlags.NoRequireDiscord) -> Result:
		return IDGSCore.create_core(p_client_id, p_flags)

	## Set the log level to receive Discord GameSDK messages.[br]
	## [param p_min_level]: [enum LogLevel] - The minimum log level to receive
	static func set_log_level(p_min_level: LogLevel) -> void:
		IDGSCore.set_log_level(p_min_level)

	## Destroys and shutsdown the Discord GameSDK.
	static func destroy():
		IDGSCore.destroy()


## Handles activities in Discord GameSDK
## @tutorial(Sample project): https://github.com/3ddelano/discord-game-sdk-godot/
class Activity:
	## Fired when [method update_activity] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal update_activity_cb(result: Result)
	## Fired when [method clear_activity] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal clear_activity_cb(result: Result)
	## Fired when [method send_request_reply] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal send_request_reply_cb(result: Result)
	## Fired when [method send_invite] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal send_invite_cb(result: Result)
	## Fired when [method accept_invite] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal accept_invite_cb(result: Result)
	## Fires when the user receives a join or spectate request.[br]
	## [param type]: [enum ActionType] - Whether the invite is to join or spectate[br]
	## [param user]: [DiscordUserData] - The user sending the invite[br]
	## [param activity]: [DiscordActivityData] - The inviting user's current activity
	signal invite(type: ActionType, user: DiscordUserData, activity: DiscordActivityData)
	## Fires when the user accepts a game chat invite or receives confirmation from Asking to Join.[br]
	## [param join_secret]: [String]
	signal join(join_secret: String)
	## Fires when a user accepts a spectate chat invite or clicks the Spectate button on a user's profile.[br]
	## [param spectate_secret]: [String]
	signal spectate(spectate_secret: String)
	## Fires when a user asks to join the current user's game.[br]
	## [param user]: [DiscordUserData] - The user asking to join
	signal join_request(user: DiscordUserData)


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


	## Get the active instance of the Discord Activity singleton. [b]Use this when connecting signals.[/b]
	static func get_instance():
		return IDGSActivity

	## Registers a command by which Discord can launch your game.
	## This might be a custom protocol, like [code]my-awesome-game://[/code], or a path to an executable. It also supports any launch parameters that may be needed, like [code]game.exe --full-screen --no-hax[/code].[br]
	## [param returns]: [enum DiscordSDK.Result]
	static func register_command(p_command: String) -> Result:
		return IDGSActivity.register_command(p_command)

	## Used if you are distributing this SDK on Steam. Registers your game's Steam app id for the protocol [code]steam://run-game-id/<id>[/code].[br]
	## [param returns]: [enum DiscordSDK.Result]
	static func register_steam(p_steam_id: int) -> Result:
		return IDGSActivity.register_steam(p_steam_id)

	## Sets a user's presence in Discord to a new activity.
	## This has a rate limit of 5 updates per 20 seconds.[br]
	## This method returns via [signal update_activity_cb]
	static func update_activity(p_activity: DiscordActivityData) -> void:
		IDGSActivity.update_activity(p_activity)

	## Clear's a user's presence in Discord to make it show nothing.[br]
	## This method returns via [signal clear_activity_cb]
	static func clear_activity() -> void:
		IDGSActivity.clear_activity()

	## Sends a reply to an Ask to Join request.[br]
	## This method returns via [signal send_request_reply_cb]
	static func send_request_reply(p_user_id: int, p_reply: JoinRequestReply) -> void:
		IDGSActivity.send_request_reply(p_user_id, p_reply)

	## Sends a game invite to a given user.
	## If you do not have a valid activity with all the required fields, this call will error.[br]
	## [param p_type]: [enum ActionType][br]
	## This method returns via [signal send_invite_cb]
	static func send_invite(p_user_id: int, p_type: ActionType, p_content: String) -> void:
		IDGSActivity.send_invite(p_user_id, p_type, p_content)

	## Accepts a game invitation from a given userId.[br]
	## This method returns via [signal accept_invite_cb]
	static func accept_invite(p_user_id: int) -> void:
		IDGSActivity.accept_invite(p_user_id)


## Handles the overlay in Discord GameSDK
## @tutorial(Sample project): https://github.com/3ddelano/discord-game-sdk-godot/
class Overlay:
	## Fired when [method set_locked] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal set_locked_cb(result: Result)
		## Fired when [method open_activity_invite] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal open_activity_invite_cb(result: Result)
	## Fired when [method open_voice_settings] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal open_voice_settings_cb(result: Result)
	## Fired when [method open_guild_invite] finishes.[br]
	## [param result]: [enum DiscordSDK.Result]
	signal open_guild_invite_cb(result: Result)
	## Fires when the overlay is locked or unlocked (a.k.a. opened or closed)[br]
	## [param result]: [enum DiscordSDK.Result]
	signal toggle(locked: bool)

	## Get the active instance of the Discord Overlay singleton. [b]Use this when connecting signals.[/b]
	static func get_instance():
		return IDGSOverlay

	## Check whether the user has the overlay enabled or disabled.
	## If the overlay is disabled, all the functionality in this manager will still work. The calls will instead focus the Discord client and show the modal there instead.
	static func is_enabled() -> bool:
		return IDGSOverlay.is_enabled()

	## Check if the overlay is currently locked or unlocked
	static func is_locked() -> bool:
		return IDGSOverlay.is_locked()

	## Locks or unlocks input in the overlay.
	## Calling [code]set_locked(true)[/code] will also close any modals in the overlay or in-app from things like IAP purchase flows and disallow input.[br]
	## This method returns via [signal set_locked_cb]
	static func set_locked(p_locked: bool) -> void:
		IDGSOverlay.set_locked(p_locked)

	## Opens the overlay modal for sending game invitations to users, channels, and servers.
	## If you do not have a valid activity with all the required fields, this call will error[br]
	## [param p_type]: [enum Activity.ActionType][br]
	## This method returns via [signal open_activity_invite_cb]
	static func open_activity_invite(p_type: Activity.ActionType) -> void:
		IDGSOverlay.open_activity_invite(p_type)

	## Opens the overlay modal for joining a Discord guild, given its invite code.
	## An invite code for a server may look something like [code]fortnite[/code] for a verified server — the full invite being [code]discord.gg/fortnite[/code] — or something like [code]FZY9TqW[/code] for a non-verified server, the full invite being [code]discord.gg/FZY9TqW[/code].[br]
	## This method returns via [signal open_guild_invite_cb]
	static func open_guild_invite(p_code: String) -> void:
		IDGSOverlay.open_guild_invite(p_code)

	## Opens the overlay widget for voice settings for the currently connected application.
	## These settings are unique to each user within the context of your application. That means that a user can have different favorite voice settings for each of their games![br]
	## This method returns via [signal open_voice_settings_cb]
	static func open_voice_settings() -> void:
		IDGSOverlay.open_voice_settings()


## Handles the user in Discord GameSDK
## @tutorial(Sample project): https://github.com/3ddelano/discord-game-sdk-godot/
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


## Handles relationships in Discord GameSDK
## @tutorial(Sample project): https://github.com/3ddelano/discord-game-sdk-godot/
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
