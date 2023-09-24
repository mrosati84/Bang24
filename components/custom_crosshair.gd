extends Node

@export var crosshair_file : Resource

func _ready():
	Input.set_custom_mouse_cursor(crosshair_file, Input.CURSOR_ARROW, Vector2(16, 16))
