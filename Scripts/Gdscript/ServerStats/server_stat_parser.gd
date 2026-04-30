class_name ServerStatParser extends Node
@export var server_stat_getter: Node

var parsed:bool
var users_month:int
var users_all_time:int
var all_time_kills:int
var month_kills:int
var gamemodes_month:Dictionary
var gamemodes:Dictionary
var maps_month:Dictionary
var maps:Dictionary
var players_total:Array[PlayerInfo]
signal just_parsed
func _process(delta: float) -> void:
	if !parsed:
		if server_stat_getter.get("resulting_txt") != null:
			var result:String = server_stat_getter.get("resulting_txt")
			if result:
				var json:Dictionary = JSON.parse_string(result)
				if json is Dictionary:
					parsed = true
					for server:Dictionary in json.values():
						#print(server)
						var time:float = Time.get_unix_time_from_datetime_string(server["created"])
						var current_time:float = Time.get_unix_time_from_system()
						var diff:float = current_time - time
						var this_month:bool = diff < 60*60*24*30
						if server.has("gamemode"):
							var previous:int = 0
							if gamemodes.has(server["gamemode"]):
								previous = gamemodes[server["gamemode"]]
							gamemodes[server["gamemode"]] = previous + 1
						if server.has("map"):
							var previous:int = 0
							if maps.has(server["map"]):
								previous = maps[server["map"]]
							maps[server["map"]] = previous + 1
						if this_month:
							if server.has("gamemode"):
								var previous:int = 0
								if gamemodes_month.has(server["gamemode"]):
									previous = gamemodes_month[server["gamemode"]]
								gamemodes_month[server["gamemode"]] = previous + 1
							if server.has("map"):
								var previous:int = 0
								if maps_month.has(server["map"]):
									previous = maps_month[server["map"]]
								maps_month[server["map"]] = previous + 1
						for player in server["players"]:
							var exists_yet:bool = false
							for found_player in players_total:
								if found_player.uid == player:
									exists_yet = true
									found_player.times_played += 1
									found_player.total_kills += int(server["players"][player]["kills"])
									var classes = server["players"][player]["classes"]
									if classes is Dictionary:
										print(classes)
										for player_class:Dictionary in classes.values():
											if player_class.has("stats"):
												if player_class["stats"].has("deaths"):
													found_player.total_deaths += int(player_class["stats"]["deaths"])
									break
							if !exists_yet:
								if this_month:
									users_month += 1
								#print(player)
								var new_player:PlayerInfo = PlayerInfo.new()
								new_player.uid = player
								new_player.username = str(server["players"][player]["username"])
								new_player.times_played = 1
								new_player.total_kills += int(server["players"][player]["kills"])
								var classes = server["players"][player]["classes"]
								if classes is Dictionary:
									print(classes)
									for player_class:Dictionary in classes.values():
										if player_class.has("stats"):
											if player_class["stats"].has("deaths"):
												new_player.total_deaths += int(player_class["stats"]["deaths"])
								players_total.append(new_player)
							var dict:Dictionary = server["players"]
							if dict.has("kills"):
								all_time_kills += dict["kills"]
					just_parsed.emit()
