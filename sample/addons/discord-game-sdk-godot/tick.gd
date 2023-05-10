extends Node


func _process(_delta: float):
	IDGSCore.tick()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		DiscordSDK.Core.destroy()
