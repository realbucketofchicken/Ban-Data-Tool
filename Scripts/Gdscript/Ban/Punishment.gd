class_name Punishment extends Resource

@export var username:String = ""
@export var uid:String = ""
@export var what_punishment:punishment_types
@export var punish_reason:String = ""
## in unix time, zero means forever
@export var punish_end:int

enum punishment_types{BAN,MUTE,WARN}
