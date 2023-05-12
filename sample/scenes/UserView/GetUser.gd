extends PanelContainer

enum States {
	Default,
	Loading,
	Loaded,
}

var _state: States = States.Default

@export_node_path("LineEdit") var _id_lineedit_path
@onready var _id_lineedit: LineEdit = get_node(_id_lineedit_path)

@export_node_path("Button") var _getuser_btn_path
@onready var _getuser_btn: Button = get_node(_getuser_btn_path)

@export_node_path("NetworkImage") var _loading_path
@onready var _loading: NetworkImage = get_node(_loading_path)

@export_node_path("UserCard") var _user_card_path
@onready var _user_card: UserCard = get_node(_user_card_path)


func _on_getuser_btn_pressed():
	var user_id = _id_lineedit.text
	if user_id.is_empty():
		return

	set_state(States.Loading)
	DiscordSDK.User.get_user(int(user_id))


func _on_getuser_cb(res: Dictionary):
	if DiscordSDK.is_error(res):
		Store.log_error("User: get_user: Error: " + DiscordSDK.result_str(res))
		set_state(States.Default)
		return

	var user = res.user
	_user_card.set_user(user)
	await _user_card.loaded
	set_state(States.Loaded)


func _ready() -> void:
	set_state(States.Default)
	_getuser_btn.pressed.connect(_on_getuser_btn_pressed)
	DiscordSDK.User.get_instance().get_user_cb.connect(_on_getuser_cb)


func set_state(new_state: States):
	_state = new_state

	match _state:
		States.Default:
			_loading.visible = false
			_user_card.visible = false
			_getuser_btn.disabled = false
		States.Loading:
			_loading.visible = true
			_user_card.visible = false
			_getuser_btn.disabled = true
		States.Loaded:
			_loading.visible = false
			_user_card.visible = true
			_getuser_btn.disabled = false
