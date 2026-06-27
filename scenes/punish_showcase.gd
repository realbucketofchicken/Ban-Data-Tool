class_name PunishShowcase extends Control
@onready var name_label: Label = $Container/VBoxContainer/Name
@onready var uid_label: Label = $Container/VBoxContainer/UID
@onready var edit_button: Button = $Container/Edit
@onready var punishment_type_display: TextureRect = $Container/PunishmentTypeDisplay
@onready var container: FlowContainer = $Container
@export var punishment:Punishment

signal Edit(showcase:PunishShowcase)

func _ready() -> void:
	edit_button.pressed.connect(edit)
	if !punishment:
		punishment = Punishment.new()

func update() -> void:
	name_label.text = punishment.username
	uid_label.text = punishment.uid
	punishment_type_display.texture = (load("res://Textures/door.png") if \
							punishment.what_punishment == punishment.punishment_types.BAN else load("res://Textures/speaker.png")) if \
							punishment.what_punishment != punishment.punishment_types.WARN else load("res://Textures/Warn.png")

func edit():
	Edit.emit(self)

func _process(delta: float) -> void:
	custom_minimum_size.y = container.size.y
