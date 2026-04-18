extends Node

@export var search_bar:LineEdit
@export var punish_container:Node
@export var name_check: CheckButton
@export var uid_check: CheckButton
@export var description_check: CheckButton

func _ready() -> void:
	search_bar.text_changed.connect(update.unbind(1))
	name_check.toggled.connect(update.unbind(1))
	uid_check.toggled.connect(update.unbind(1))
	description_check.toggled.connect(update.unbind(1))

func update():
	var text = search_bar.text
	print("ss")
	if text:
		for child in punish_container.get_children():
			child.hide()
		var strings:PackedStringArray = text.split(";")
		for child in punish_container.get_children():
			if child is PunishShowcase:
				var valid:bool = true
				for string in strings:
					if string:
						var in_name:bool = (string.to_lower() in child.name_label.text.to_lower()) if name_check.button_pressed else false
						var in_uid:bool = (string.to_lower() in child.uid_label.text.to_lower()) if uid_check.button_pressed else false
						var in_decsciption:bool = (string.to_lower() in child.punishment.punish_reason.to_lower()) if description_check.button_pressed else false
						if !in_name and !in_uid and !in_decsciption:
							valid = false
				if valid:
					child.show()
	else:
		for child in punish_container.get_children():
			if child is PunishShowcase:
				child.show()
