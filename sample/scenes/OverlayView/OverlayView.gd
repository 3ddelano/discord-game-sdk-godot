class_name OverlayView
extends VBoxContainer


func _ready() -> void:
	DiscordSDK.Overlay.connect("toggle", Callable(self, "_on_overlay_toggle"))


func _on_overlay_toggle(locked: bool):
    print("----- Overlay Toggle Event: ", locked)
