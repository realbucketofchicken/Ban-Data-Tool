class_name ServerStatParser extends Node

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
signal player_parsed
func _ready() -> void:
	var player_request:HTTPRequest = HTTPRequest.new()
	add_child(player_request)
	player_request.request("https://tfvr-server.fly.dev/query?entity=item&group=name&metric=stats.kills&metric=stats.deaths&metric=stats.time&metric=_count")
	player_request.request_completed.connect(parse_players)

func parse_players(_result_num: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	print(body)
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json is Dictionary:
		for key in json:
			for player_key in json[key]:
				if !is_player_dupe(player_key):
					var player:PlayerInfo = PlayerInfo.new()
					player.uid = player_key
					player.username = json[key][player_key]["meta"]["username"]
					player.times_played = json[key][player_key]["metrics"]["_count"]
					player.total_deaths = json[key][player_key]["metrics"]["stats.deaths"]
					player.total_kills = json[key][player_key]["metrics"]["stats.kills"]
	player_parsed.emit()

func is_player_dupe(uid:String) -> bool:
	for player in players_total:
		if player.uid == uid:
			return true
	return false
