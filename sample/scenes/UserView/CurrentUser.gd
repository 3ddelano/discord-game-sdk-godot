extends PanelContainer

enum States {
	Loading,
	Loaded,
}

var _state = States.Loading

@onready var _loading: NetworkImage = %Loading
@onready var _user_card: UserCard = %Card


func _ready() -> void:
	DiscordSDK.User.get_instance().current_user_update.connect(_on_current_user_update)
	set_state(States.Loading)


func set_state(new_state: States):
	_state = new_state

	match _state:
		States.Loading:
			_loading.visible = true
			_user_card.visible = false
		States.Loaded:
			_loading.visible = false
			_user_card.visible = true


func _on_current_user_update():
	var user_res = DiscordSDK.User.get_current_user()

	if DiscordSDK.is_error(user_res):
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- User: get_current_user: Error: " + DiscordSDK.result_str(user_res))
		return

	var user = user_res.user
	print("----- User: get_current_user: ", user)

	var premium_res = DiscordSDK.User.get_current_user_premium_type()
	if DiscordSDK.is_error(premium_res):
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- User: get_current_user_premium_type: Error: " + DiscordSDK.result_str(premium_res))

	var partner_flag_res = DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.Partner)
	if DiscordSDK.is_error(partner_flag_res):
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- User: current_user_has_flag(Partner): Error: " + DiscordSDK.result_str(partner_flag_res))

	var hypesquad_flag_res = DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.HypeSquadEvents)
	if DiscordSDK.is_error(hypesquad_flag_res):
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- User: current_user_has_flag(HypeSquadEvents): Error: " + DiscordSDK.result_str(hypesquad_flag_res))

	var hype1_flag_res = DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.HypeSquadHouse1)
	if DiscordSDK.is_error(hype1_flag_res):
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- User: current_user_has_flag(HypeSquadHouse1): Error: " + DiscordSDK.result_str(hype1_flag_res))

	var hype2_flag_res = DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.HypeSquadHouse2)
	if DiscordSDK.is_error(hype2_flag_res):
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- User: current_user_has_flag(HypeSquadHouse2): Error: " + DiscordSDK.result_str(hype2_flag_res))

	var hype3_flag_res = DiscordSDK.User.current_user_has_flag(DiscordSDK.User.UserFlag.HypeSquadHouse3)
	if DiscordSDK.is_error(hype3_flag_res):
		Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- User: current_user_has_flag(HypeSquadHouse3): Error: " + DiscordSDK.result_str(hype3_flag_res))


	_user_card.set_user(user)
	_user_card.set_premium_type(premium_res.premium_type)
	_user_card.set_hypesquad(hypesquad_flag_res.has_flag)
	_user_card.set_hype1(hype1_flag_res.has_flag)
	_user_card.set_hype2(hype2_flag_res.has_flag)
	_user_card.set_hype3(hype3_flag_res.has_flag)

	await _user_card.loaded
	set_state(States.Loaded)
