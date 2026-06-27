class_name OverrideItemGroup extends OverrideItem
@export var name:String
@export var children:Array[LoadoutOverrideInfo]

func as_string() -> String:
	var string:String = ""
	string += name + "\n"
	for child:LoadoutOverrideInfo in children:
		string += "class: " + child.class_path + "\n"
		string += "slot: " + child.slot + "\n"
		string += "item: " + child.item_path + "\n"
		string += "users: " + str(child.users) + "\n"
		string += "groups: " + str(child.groups) + "\n"
	return string
