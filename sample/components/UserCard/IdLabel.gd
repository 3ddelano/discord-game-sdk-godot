class_name IDLabel
extends Label

var _original_text: String


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func set_text_custom(p_text: String):
	_original_text = p_text
	text = censor_discord_id(_original_text)


# Show the orignal ID
func _on_mouse_entered():
	text = _original_text


# Censor the ID
func _on_mouse_exited():
	text = censor_discord_id(_original_text)


# Given a discord id like 123456789123456789, return 123************789
func censor_discord_id(p_discord_id: String, p_censor_char := "x"):
	if p_discord_id.is_empty():
		return ""

	var censored = p_discord_id
	if p_discord_id.length() > 6:
		censored = p_discord_id.substr(0, 3)
		censored += p_censor_char.repeat(p_discord_id.length() - 6)
		censored += p_discord_id.substr(p_discord_id.length() - 3, text.length())
	return censored
