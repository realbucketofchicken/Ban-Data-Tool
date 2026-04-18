class_name OverrideParser extends Node

func parse_overrides(source:String,users:Array[UserInfo],user_groups:Array[GroupInfo]) -> Array[OverrideItemGroup]:
	var splits:PackedStringArray = source.split("\n")
	print("parsing with ",splits)
	var current_info:LoadoutOverrideInfo
	var infos:Array[LoadoutOverrideInfo]
	for line in splits:
		if line.begins_with("CLASS: "):
			var new_item:LoadoutOverrideInfo = LoadoutOverrideInfo.new()
			new_item.class_path = line.replace("CLASS: ","")
			current_info = new_item
			continue
		if line.begins_with("SLOT: "):
			var slot:String = line.replace("SLOT: ","")
			current_info.slot = slot
			continue
		if line.begins_with("ITEM: "):
			var item:String = line.replace("ITEM: ","")
			current_info.item_path = item
			continue
		if line.begins_with("PLAYERS: "):
			var players_raw:String = line.replace("PLAYERS: ","")
			var players:PackedStringArray = players_raw.split(",")
			for player in players:
				if player.begins_with("@"):
					var user_group_name:String = player.replace("@","")
					var found:bool = false
					for group in user_groups:
						if group.name == user_group_name:
							current_info.groups.append(group)
							found = true
							break
					if !found:
						push_error("didnt find group ",user_group_name)
				else:
					var user_name:String = player
					var found:bool = false
					for user in users:
						if user.name == user_name:
							current_info.users.append(user)
							found = true
							break
					if !found:
						push_warning("didnt find user ",user_name)
		if line.begins_with("TAG: "):
			current_info.tag = line.replace("TAG: ","")
			infos.append(current_info)
			current_info = null
	var groups:Array[OverrideItemGroup] = []
	for info in infos:
		var exists:bool = false
		for group in groups:
			if group.name == info.tag:
				exists = true
				group.children.append(info)
		if !exists:
			var new_group:OverrideItemGroup = OverrideItemGroup.new()
			new_group.name = info.tag
			groups.append(new_group)
	return groups
