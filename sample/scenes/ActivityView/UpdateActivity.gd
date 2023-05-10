extends PanelContainer


@onready var _activity_type_optionbtn: OptionButton = %ActivityTypeOptionButton
@onready var _application_id_lineedit: LineEdit = %ApplicationIdLineEdit
@onready var _state_lineedit: LineEdit = %StateLineEdit
@onready var _details_lineedit: LineEdit = %DetailsLineEdit
@onready var _start_spinbox: SpinBox = %StartSpinbox
@onready var _end_spinbox: SpinBox = %EndSpinbox
@onready var _large_asset_img_lineedit: LineEdit = %LargeAssetImageLineEdit
@onready var _large_asset_text_lineedit: LineEdit = %LargeAssetTextLineEdit
@onready var _small_asset_img_lineedit: LineEdit = %SmallAssetImageLineEdit
@onready var _small_asset_text_lineedit: LineEdit = %SmallAssetTextLineEdit
@onready var _party_id_lineedit: LineEdit = %PartyIdLineEdit
@onready var _party_current_size_spinbox: SpinBox = %PartySizeCurrentSpinBox
@onready var _party_max_size_spinbox: SpinBox = %PartySizeMaxSpinBox
@onready var _match_secret_lineedit: LineEdit = %MatchSecretLineEdit
@onready var _join_secret_lineedit: LineEdit = %JoinSecretLineEdit
@onready var _spectate_secret_lineedit: LineEdit = %SpectateSecretLineEdit
@onready var _instance_checkbox: CheckBox = %InstanceCheckBox

@onready var _update_activity_btn: Button = %UpdateActivityBtn
@onready var _clear_activity_btn: Button = %ClearActivityBtn
var _activity_data = DiscordSDK.Activity.ActivityData.new()


func _on_update_activity_btn():
	_activity_data.type = _activity_type_optionbtn.get_selected_id()
	_activity_data.application_id = int(_application_id_lineedit.text)
	_activity_data.state = _state_lineedit.text
	_activity_data.details = _details_lineedit.text
	_activity_data.timestamp_start = _start_spinbox.value
	_activity_data.timestamp_end = _end_spinbox.value
	_activity_data.asset_large_image = _large_asset_img_lineedit.text
	_activity_data.asset_large_text = _large_asset_text_lineedit.text
	_activity_data.asset_small_image = _small_asset_img_lineedit.text
	_activity_data.asset_small_text = _small_asset_text_lineedit.text
	_activity_data.party_id = _party_id_lineedit.text
	_activity_data.party_size_current = _party_current_size_spinbox.value
	_activity_data.party_size_max = _party_max_size_spinbox.value
	_activity_data.secrets_match = _match_secret_lineedit.text
	_activity_data.secrets_join = _join_secret_lineedit.text
	_activity_data.secrets_spectate = _spectate_secret_lineedit.text
	_activity_data.instance = _instance_checkbox.button_pressed

	DiscordSDK.Activity.update_activity(_activity_data)
	DiscordSDK.Activity.get_instance().update_activity_cb.connect(func (res):
		if DiscordSDK.is_error(res):
			Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- Activity: update_activity: Error: " + DiscordSDK.result_str(res))
			return

		Store.log_msg(DiscordSDK.Core.LogLevel.Info, "Activity:update_activity:Ok")
	)


func _on_clear_activity_btn():
	DiscordSDK.Activity.clear_activity()
	DiscordSDK.Activity.get_instance().clear_activity_cb.connect(func (res):
		if DiscordSDK.is_error(res):
			Store.log_msg(DiscordSDK.Core.LogLevel.Error, "----- Activity: clear_activity: Error: " + DiscordSDK.result_str(res))
			return

		Store.log_msg(DiscordSDK.Core.LogLevel.Info, "Activity:clear_activity:Ok")
	)


func _ready():
	_update_activity_btn.pressed.connect(_on_update_activity_btn)
	_clear_activity_btn.pressed.connect(_on_clear_activity_btn)

	Store.discord_create.connect(func ():
		_application_id_lineedit.text = str(Store._main_node.APPLICATION_ID)
	)
