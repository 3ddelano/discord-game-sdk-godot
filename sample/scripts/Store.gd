extends Node

signal discord_create


var _main_node: Control

func get_view(view_name: String):
	return _main_node.get_view_manager().get_view(view_name)

func set_view(view_name: String):
	return _main_node.get_view_manager().set_view(view_name)


# NetworkImage cache Dictionary of {url: Texture}
var network_image_cache = {}
