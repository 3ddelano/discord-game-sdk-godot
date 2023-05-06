class_name ViewManager
extends VBoxContainer

@onready var user_btn = $HB/UserBtn
@onready var activity_btn = $HB/ActivityBtn
@onready var overlay_btn = $HB/OverlayBtn
@onready var relationships_btn = $HB/RelationshipsBtn


func _ready() -> void:
	user_btn.connect("pressed", Callable(self, "set_view").bind("User"))
	activity_btn.connect("pressed", Callable(self, "set_view").bind("Activity"))
	overlay_btn.connect("pressed", Callable(self, "set_view").bind("Overlay"))
	relationships_btn.connect("pressed", Callable(self, "set_view").bind("Relationships"))


func get_view(view_name: String):
	if view_name == "Logs":
		return $VSC/LogsView

	elif view_name == "Notifications":
		return $VSC/VB/NotificationsLayer/NotificationsView

	return get_node("VSC/VB/" + view_name + "View")


func set_view(view_name: String):
	for child in $VSC/VB.get_children():
		if child is CanvasItem:
			child.visible = false

	get_view(view_name).visible = true
