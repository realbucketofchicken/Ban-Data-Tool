extends Control

@export var user_parser: UserParser
@export var override_parser: OverrideParser

var users:Array[UserInfo]
var user_groups:Array[GroupInfo]
var override_categories:Array[OverrideItemGroup]
# Called when the node enters the scene tree for the first time.
func _ready() -> void: # "user://repo/loadout-overrides/default-loadout-overrides.txt"
	if FileAccess.file_exists("user://repo/users.txt") && FileAccess.file_exists("user://repo/loadout-overrides/default-loadout-overrides.txt"):
		var user_text:String = FileAccess.get_file_as_string("user://repo/users.txt")
		var override_text:String = FileAccess.get_file_as_string("user://repo/loadout-overrides/default-loadout-overrides.txt")
		users = user_parser.parse_people(user_text)
		#print("got ",users)
		user_groups = user_parser.parse_groups(user_text,users)
		override_categories = override_parser.parse_overrides(override_text,users,user_groups)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
