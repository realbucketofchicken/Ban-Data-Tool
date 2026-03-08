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
		content += "PUNISHMENT: " + ("MUTE" if punishment.what_punishment == 
									punishment.punishment_types.MUTE else "BAN") + "\n"
		content += "REASON: " + punishment.punish_reason + "\n"
		content += "END_DATE: " + str(punishment.punish_end) + "\n"
	content += "L!ListEnd\n"
	
	fileaccess.store_string(content)

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
