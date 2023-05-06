class_name ActivityPopup
extends PopupPanel

@onready var id_label = $VB/MC/VB/IdLabel
@onready var flavor_label = $VB/MC/VB/FlavorLabel
@onready var is_visible_label = $VB/MC/VB/IsVisibleLabel
@onready var is_unlocked_label = $VB/MC/VB/IsUnlockedLabel
@onready var locked_image = $VB/MC/VB/HB/VB/LockedImage
@onready var locked_label = $VB/MC/VB/HB/VB/LockedLabel
@onready var locked_desc_label = $VB/MC/VB/HB/VB/LockedDescLabel
@onready var unlocked_image = $VB/MC/VB/HB/VB2/UnlockedImage
@onready var unlocked_label = $VB/MC/VB/HB/VB2/UnlockedLabel
@onready var unlocked_desc_label = $VB/MC/VB/HB/VB2/UnlockedDescLabel

@onready var unlock_btn = $VB/MC/VB/UnlockBtn
@onready var close_btn = $VB/CloseBtn

var activity_node: ActivityListActivity


func _ready() -> void:
	unlock_btn.connect("pressed", Callable(self, "_on_unlock_btn_pressed"))
	close_btn.connect("pressed", Callable(self, "set_visible").bind(false))


func from_activity_node(node: ActivityListActivity):
	activity_node = node
	var data = activity_node.get_data()

	id_label.text = "Id: " + data.activity_id
	flavor_label.text = "Flavor Text: " + data.flavor_text
	if data.is_hidden != null:
		if data.is_hidden:
			is_visible_label.text = "Is Visible: False"
		else:
			is_visible_label.text = "Is Visible: True"
	else:
		is_visible_label.text = "Is Visible: NA"

	if data.unlock_time == "":
		is_unlocked_label.text = "Is Unlocked: No"
		unlock_btn.disabled = false
	else:
		is_unlocked_label.text = "Is Unlocked: Yes on " + data.unlock_time
		unlock_btn.disabled = true

	locked_image.fetch_image(data.locked_icon_url)
	locked_label.text = "Locked Name: " + data.locked_display_name
	locked_desc_label.text = "Locked Desc: " + data.locked_description

	unlocked_image.fetch_image(data.unlocked_icon_url)
	unlocked_label.text = "Locked Name: " + data.unlocked_display_name
	unlocked_desc_label.text = "Locked Desc: " + data.unlocked_description


func _on_unlock_btn_pressed():
	unlock_btn.disabled = true
	visible = false
