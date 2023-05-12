class_name RelationshipCard
extends PanelContainer


@onready var _type_label = %RelationshipTypeLabel
@onready var _user_card = %UserCard


func get_type_label():
	return _type_label


func get_user_card():
	return _user_card
