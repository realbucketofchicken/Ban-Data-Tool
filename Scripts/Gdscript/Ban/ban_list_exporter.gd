class_name BanListExporter extends Node

func Export(Punishments:Array[Punishment],file:String) -> void:
	var fileaccess:FileAccess = FileAccess.open(file,FileAccess.WRITE)
	if !fileaccess:
		push_error("!fileaccess is true")
		return
	var content:String = ""
	content += "L!ListBegin\n"
	for punishment in Punishments:
		if !punishment.username:
			continue
		content += "NAME: " + punishment.username + "\n"
		content += "UID: " + punishment.uid + "\n"
		content += "PUNISHMENT: " + (get_punish_type(punishment)) + "\n"
		content += "REASON: " + punishment.punish_reason + "\n"
		content += "END_DATE: " + str(punishment.punish_end) + "\n"
	content += "L!ListEnd\n"
	
	fileaccess.store_string(content)

func get_punish_type(punishment:Punishment):
	match punishment.what_punishment:
		Punishment.punishment_types.BAN:
			return "BAN"
		Punishment.punishment_types.MUTE:
			return "MUTE"
		Punishment.punishment_types.WARN:
			return "WARN"

# DEPRECATED
func Exportv1(Punishments:Array[Punishment],file:String) -> void:
	var fileaccess:FileAccess = FileAccess.open(file,FileAccess.WRITE)
	if !fileaccess:
		push_error("!fileaccess is true")
		return
	var content:String = ""
	content += "L!ListBegin\n"
	for punishment in Punishments:
		if !punishment.username:
			continue
		content += "NAME: " + punishment.username + "\n"
		content += "UID: " + punishment.uid + "\n"
	content += "L!ListEnd\n"
	fileaccess.store_string(content)
