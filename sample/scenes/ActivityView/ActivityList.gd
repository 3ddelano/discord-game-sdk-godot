class_name ActivityList
extends MarginContainer

signal activity_pressed(node)

const Activity_LIST_ACHIEVEMENT = preload("res://scenes/ActivityView/ActivityListActivity.tscn")

func _ready() -> void:
	_clear()


func _clear() -> void:
	# Clear existing Activity
	for child in $SC/VB.get_children():
		child.queue_free()


func from_Activity_array(arr: Array):
	_clear()

	# Populate new Activity
	for activity_data in arr:
		var activity = Activity_LIST_ACHIEVEMENT.instantiate()
		$SC/VB.add_child(activity)

		activity.connect("pressed", Callable(self, "_on_activity_pressed"))
		activity.from_activity_data(activity_data)


func _on_activity_pressed(node: ActivityListActivity):
	emit_signal("activity_pressed", node)
