extends RichTextLabel

@export var richTextLabel : RichTextLabel

func _ready():
	append_log("Welcome to Bang24.")

func append_log(message: String):
	# Aggiungi il messaggio al RichTextLabel con il formato BBCode
	richTextLabel.append_text("[color=#000000][" + get_current_time() + "] " + message + "[/color]\n")

func get_current_time() -> String:
	var time = Time.get_time_dict_from_system()
	var current_time = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
	
	return current_time
