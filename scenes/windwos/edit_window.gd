class_name EditWindow extends Window
@onready var days_edit: SpinBox = $margin/VBoxContainer/ScrollContainer/Container/Ends/DaysEdit
@onready var years_edit: SpinBox = $margin/VBoxContainer/ScrollContainer/Container/Ends/YearsEdit
@onready var reason_edit: LineEdit = $"margin/VBoxContainer/ScrollContainer/Container/Reason/Reason Edit"
@onready var uid_edit: LineEdit = $"margin/VBoxContainer/ScrollContainer/Container/UID/UID Edit"
@onready var name_edit: LineEdit = $"margin/VBoxContainer/ScrollContainer/Container/Name/Name Edit"
@onready var donebutton: Button = $margin/VBoxContainer/Done
@onready var delete_check: CheckBox = $margin/VBoxContainer/ScrollContainer/Container/DeleteCheck
@onready var delete_button: Button = $margin/VBoxContainer/ScrollContainer/Container/DeleteButton
@onready var type_button: OptionButton = $margin/VBoxContainer/ScrollContainer/Container/Type/TypeButton

@export var opened_from:PunishShowcase
@export var punishment:Punishment

const id_to_name:Dictionary = {Punishment.punishment_types.BAN:"BAN",
								Punishment.punishment_types.MUTE:"MUTE"}

signal changed

func _ready() -> void:
	close_requested.connect(close)
	donebutton.pressed.connect(done)
	delete_button.pressed.connect(delete_this)
	for type in Punishment.punishment_types:
		type_button.add_item(type)

func delete_this():
	if opened_from:
		opened_from.queue_free()
		punishment = null
		hide()
		delete_check.button_pressed = false
	changed.emit()

func _process(delta: float) -> void:
	delete_button.disabled = !delete_check.button_pressed

func update(set_time:bool = false):
	if !punishment:
		printerr("!punishment is true")
		return
	name_edit.text = punishment.username
	uid_edit.text = punishment.uid
	reason_edit.text = punishment.punish_reason
	var from_time:int = punishment.punish_end
	var from_unix:Dictionary = Time.get_date_dict_from_unix_time(from_time)
	@warning_ignore("integer_division")
	var years:int = from_unix["year"]
	@warning_ignore("integer_division")
	var days:int = from_unix["day"]
	years_edit.value = years
	days_edit.value = days
	type_button.select(punishment.what_punishment)
	changed.emit()

func close():
	punishment = null
	opened_from = null
	delete_check.button_pressed = false
	hide()
	changed.emit()

func done():
	if opened_from:
		opened_from.punishment = get_punish()
		opened_from.update()
		hide()
	else:
		hide()
	delete_check.button_pressed = false
	changed.emit()

func get_punish() -> Punishment:
	var new_punishment:Punishment = Punishment.new()
	new_punishment.username = name_edit.text
	new_punishment.uid = uid_edit.text
	new_punishment.punish_reason = reason_edit.text
	var time:int = 0
	time += years_edit.value * 31536000 
	time += days_edit.value *86400
	var unixtime:float = Time.get_unix_time_from_datetime_dict({"year":years_edit.value,
											"day":days_edit.value,})
	new_punishment.punish_end = unixtime
	new_punishment.what_punishment = type_button.selected
	changed.emit()
	return new_punishment
