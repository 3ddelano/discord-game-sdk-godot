extends VBoxContainer

@onready var _load_all_btn = %LoadAllBtn
@onready var _count_label = %CountLabel
@onready var _relationships_container = %Relationships

var RelationshipCardScene = preload("res://components/RelationshipCard/RelationshipCard.tscn")

func _ready() -> void:
	DiscordSDK.Relationship.get_instance().refresh.connect(func ():
		_load_all_btn.pressed.connect(_on_load_all_btn_pressed)
	)


func _remove_all_cards():
	for child in _relationships_container.get_children():
		child.queue_free()


func _on_load_all_btn_pressed():
	var relationships: Array[DiscordRelationshipData] = DiscordSDK.Relationship.filter(func (_relationship):
		return true
	)
	var count = len(relationships)
	Store.log_info("Relationship: filter: count=" + str(count))

	_remove_all_cards()
	_count_label.text = "Count: " + str(count)

	for relationship in relationships:
		var card = RelationshipCardScene.instantiate()
		_relationships_container.add_child(card)
		match relationship.type:
			DiscordSDK.Relationship.RelationshipType.None:
				card.get_type_label().text = "None"
			DiscordSDK.Relationship.RelationshipType.Friend:
				card.get_type_label().text = "Friend"
			DiscordSDK.Relationship.RelationshipType.Blocked:
				card.get_type_label().text = "Blocked"
			DiscordSDK.Relationship.RelationshipType.PendingIncoming:
				card.get_type_label().text = "Pending Incoming"
			DiscordSDK.Relationship.RelationshipType.PendingOutgoing:
				card.get_type_label().text = "Pending Outgoing"
			DiscordSDK.Relationship.RelationshipType.Implicit:
				card.get_type_label().text = "Implicit"

		var user_card: UserCard = card.get_user_card()
		user_card.set_user(relationship.user)
		user_card.set_status(relationship.presence.status)
		user_card.set_activity(relationship.presence.activity)
