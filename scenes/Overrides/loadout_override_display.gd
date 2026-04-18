extends Control
@export var class_option: OptionButton
@export var custom_class_edit: LineEdit
@export var class_custom: HBoxContainer
@export var slot_option: OptionButton
@export var slot_custom: HBoxContainer
@export var custom_slot_edit: LineEdit
@export var item_edit: LineEdit
var loadout_override:LoadoutOverrideInfo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_from_loadout()

func load_from_loadout(_n=null):
	var class_path:int = get_class_idx(loadout_override.class_path)
	class_option.selected = class_path
	if class_path == 9:
		custom_class_edit.text = loadout_override.class_path
	
	var slot:int = slot_to_idx(loadout_override.slot)
	slot_option.select(slot)
	if slot == 5:
		custom_slot_edit.text = loadout_override.slot
	
	item_edit.text = loadout_override.item_path

func update_loadout():
	loadout_override.class_path = get_class_path()

func get_class_idx(string:String) -> int:
	match string:
		"/Game/tf2_commons_v142/Loadout/Loadouts/Scout/TF2_Scout_HolderInfo.TF2_Scout_HolderInfo":
			return 0
		"/Game/tf2_commons_v142/Loadout/Loadouts/Soldier/TF2_Soldier_HolderInfo.TF2_Soldier_HolderInfo":
			return 1
		"/Game/tf2_commons_v142/Loadout/Loadouts/Medic/TF2_Medic_HolderInfo.TF2_Medic_HolderInfo":
			return 2
		"/Game/tf2_commons_v142/Loadout/Loadouts/Engineer/TF2_Engineer_HolderInfo.TF2_Engineer_HolderInfo":
			return 3
		"/Game/tf2_commons_v142/Loadout/Loadouts/Heavy/TF2_Heavy_HolderInfo.TF2_Heavy_HolderInfo":
			return 4
		"/Game/tf2_commons_v142/Loadout/Loadouts/Sniper/TF2_Sniper_HolderInfo.TF2_Sniper_HolderInfo":
			return 5
		"/Game/tf2_commons_v142/Loadout/Loadouts/Spy/TF2_Spy_HolderInfo.TF2_Spy_HolderInfo":
			return 6
		"/Game/tf2_commons_v142/Loadout/Loadouts/Demoman/TF2_Demoman_HolderInfo.TF2_Demoman_HolderInfo":
			return 7
		"/Game/tf2_commons_v142/Loadout/Loadouts/Pyro/TF2_Pyro_HolderInfo.TF2_Pyro_HolderInfo":
			return 8
		_:
			return 9

func slot_to_idx(slot:String) -> int:
	match slot:
		"Hat":
			return 0 
		"Misc":
			return 1
		"Melee":
			return 2
		"Primary":
			return 3
		"Sidearm":
			return 4
		_:
			return 5

func get_class_path():
	match class_option.selected:
		0:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Scout/TF2_Scout_HolderInfo.TF2_Scout_HolderInfo"
		1:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Soldier/TF2_Soldier_HolderInfo.TF2_Soldier_HolderInfo"
		2:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Medic/TF2_Medic_HolderInfo.TF2_Medic_HolderInfo"
		3:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Engineer/TF2_Engineer_HolderInfo.TF2_Engineer_HolderInfo"
		4:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Heavy/TF2_Heavy_HolderInfo.TF2_Heavy_HolderInfo"
		5:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Sniper/TF2_Sniper_HolderInfo.TF2_Sniper_HolderInfo"
		6:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Spy/TF2_Spy_HolderInfo.TF2_Spy_HolderInfo"
		7:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Demoman/TF2_Demoman_HolderInfo.TF2_Demoman_HolderInfo"
		8:
			return "/Game/tf2_commons_v142/Loadout/Loadouts/Pyro/TF2_Pyro_HolderInfo.TF2_Pyro_HolderInfo"
		9:
			return custom_class_edit.text
