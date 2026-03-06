extends Node

@export var search_bar:LineEdit
@export var punish_container:Node

func _ready() -> void:
	search_bar.text_changed.connect(update)

func update(text:String):
	if text:
		for child in punish_container.get_children():
			if child is PunishShowcase:
				if (text.to_lower() in child.name_label.text.to_lower()) or (text.to_lower() in child.uid_label.text.to_lower()):
					child.show()
				else:
					child.hide()
	else:
		for child in punish_container.get_children():
			if child is PunishShowcase:
				child.show()
