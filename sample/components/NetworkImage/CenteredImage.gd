@tool
extends TextureRect


func _process(_delta: float) -> void:
	pivot_offset = get_rect().size / 2
