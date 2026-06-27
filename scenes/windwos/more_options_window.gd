class_name MoreOptionsWindow extends Window

@export var dupe_clear_button: Button
@export var save_v_1_button: Button
@export var repo_edit: LineEdit
@export var email_edit: LineEdit
@export var name_edit: LineEdit
@export var key_edit: LineEdit
@export var clone_repo_button: Button
@export var clone_log: Label
@export var reset_repo_button:Button



signal remove_dupes
signal save_v_one
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_v_1_button.pressed.connect(save_v_one.emit)
	dupe_clear_button.pressed.connect(remove_dupes.emit)
	close_requested.connect(close)

func close():
	hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
