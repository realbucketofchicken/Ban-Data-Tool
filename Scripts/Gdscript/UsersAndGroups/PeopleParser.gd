class_name UserParser extends Node

func parse_people(source:String) -> Array[UserInfo]:
	var splits_users:PackedStringArray = source.split("#region USERS")[1].split("#endregion")[0].split("\n")
	#print("parsing: ",splits_users," on a source of, ", source)
	var current_user:UserInfo = null
	var users:Array[UserInfo]
	for line in splits_users:
		if line.begins_with("NAME: "):
			var user:UserInfo = UserInfo.new()
			user.name = line.replace("NAME: ","")
			current_user = user
			continue
		if line.begins_with("UID: "):
			if current_user:
				current_user.uid = line.replace("UID: ","")
				users.append(current_user)
			else:
				push_error("Error parsing people, no user object")
			current_user = null
			continue
	return users
func parse_groups(source:String,users:Array[UserInfo]) -> Array[GroupInfo]:
	var splits_groups:PackedStringArray = source.split("#region GROUPS")[1].split("#endregion")[0].split("\n")
	var groups:Array[GroupInfo]
	var current_group:GroupInfo
	for line in splits_groups:
		if line.begins_with("GROUP: "):
			var group:GroupInfo = GroupInfo.new()
			group.name = line.replace("GROUP: ","")
			current_group = group
		if line.begins_with("MEMBERS: "):
			var people:PackedStringArray = line.replace("MEMBERS: ","").split(",")
			for person in people:
				current_group.users.append(find_user(person,users))
			groups.append(current_group)
			current_group = null
	return groups

func find_user(user_name:String,users:Array[UserInfo]) -> UserInfo:
	for user in users:
		if user.name == user_name:
			return user
	push_error("User is not found")
	return null
