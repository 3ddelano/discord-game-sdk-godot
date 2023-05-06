# Copyright (c) 2023-present Delano Lourenco
# https://github.com/3ddelano/discord-game-sdk-godot/
# MIT License

extends RefCounted
class_name DiscordSDK


enum Result {
	Ok = 0,
	ServiceUnavailable = 1,
	InvalidVersion = 2,
	LockFailed = 3,
	InternalError = 4,
	InvalidPayload = 5,
	InvalidCommand = 6,
	InvalidPermissions = 7,
	NotFetched = 8,
	NotFound = 9,
	Conflict = 10,
	InvalidSecret = 11,
	InvalidJoinSecret = 12,
	NoEligibleActivity = 13,
	InvalidInvite = 14,
	NotAuthenticated = 15,
	InvalidAccessToken = 16,
	ApplicationMismatch = 17,
	InvalidDataUrl = 18,
	InvalidBase64 = 19,
	NotFiltered = 20,
	LobbyFull = 21,
	InvalidLobbySecret = 22,
	InvalidFilename = 23,
	InvalidFileSize = 24,
	InvalidEntitlement = 25,
	NotInstalled = 26,
	NotRunning = 27,
	InsufficientBuffer = 28,
	PurchaseCanceled = 29,
	InvalidGuild = 30,
	InvalidEvent = 31,
	InvalidChannel = 32,
	InvalidOrigin = 33,
	RateLimited = 34,
	OAuth2Error = 35,
	SelectChannelTimeout = 36,
	GetGuildTimeout = 37,
	SelectVoiceForceRequired = 38,
	CaptureShortcutAlreadyListening = 39,
	UnauthorizedForActivity = 40,
	InvalidGiftCode = 41,
	PurchaseError = 42,
	TransactionAborted = 43,
	DrawingInitFailed = 44,
}

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


class Core:
	enum CreateFlags {
		Default = 0,
		NoRequireDiscord = 1,
	}

	enum LogLevel {
		Error = 1,
		Warn,
		Info,
		Debug,
	}

	static func get_instance():
		return IDGSCore

	static func create(p_client_id: int, flags := CreateFlags.Default) -> Result:
		return IDGSCore.create_core(p_client_id, flags)

	static func set_log_level(p_min_level: LogLevel) -> void:
		IDGSCore.set_log_level(p_min_level)

	static func destroy():
		IDGSCore.destroy()


class Activity:
	enum Type {
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

	class Activity extends BaseClass:
		func _init(): super._init("Activity")

		var type: Type
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

	static func update_activity(p_activity: Activity.Activity) -> void:
		IDGSActivity.update_activity(p_activity)

	static func clear_activity() -> void:
		IDGSActivity.clear_activity()

	static func send_request_reply(p_user_id: int, p_reply: JoinRequestReply) -> void:
		IDGSActivity.send_request_reply(p_user_id, p_reply)

	static func send_invite(p_user_id: int, p_type: ActionType, p_content: String) -> void:
		IDGSActivity.send_invite(p_user_id, p_type, p_content)

	static func accept_invite(p_user_id: int) -> void:
		IDGSActivity.accept_invite(p_user_id)


class User extends RefCounted:
	var _iuser

	func set_id(p_user_id: int) -> void:
		_iuser.set_id(p_user_id)

	func get_id() -> int:
		return _iuser.get_id()

	func set_username(p_username: String) -> void:
		_iuser.set_username(p_username)

	func get_username() -> String:
		return _iuser.get_username()

	func set_discriminator(p_discriminator: String) -> void:
		_iuser.set_discriminator(p_discriminator)

	func get_discriminator() -> String:
		return _iuser.get_discriminator()

	func set_avatar(p_avatar: String) -> void:
		_iuser.set_avatar(p_avatar)

	func get_avatar() -> String:
		return _iuser.get_avatar()

	func set_bot(p_bot: bool) -> void:
		_iuser.set_bot(p_bot)

	func get_bot() -> bool:
		return _iuser.get_bot()


static func print_result(p_result: int) -> void:
	print_rich("[b]Discord Result[/b]:%s[code](%s)[/code]" % [result_str(p_result), p_result])


static func result_str(p_result) -> String:
	if typeof(p_result) == TYPE_DICTIONARY:
		p_result = p_result["result_code"]
	var idx := Result.values().find(p_result)
	return Result.keys()[idx]
