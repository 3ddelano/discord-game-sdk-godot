class_name OverlayView
extends VBoxContainer


func _ready() -> void:
	DiscordSDK.Overlay.get_instance().toggle.connect(_on_overlay_toggle)


func _on_overlay_toggle(locked: bool):
	print("----- Overlay Toggle Event: ", locked)
