extends Camera2D

@export var max_zoom : float = 0.5
@export var min_zoom : float = 1.5
@export var zoom_increment : float = 0.05
@export var zoom_smoothing : float = 0.05

var zoom_target : float = 1.0

func _ready():
#	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	pass

func _process(_delta):
#	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():

	# usa interpolazione lineare per zoom morbido
	var new_zoom : float = lerpf(zoom.x, zoom_target, zoom_smoothing)
	zoom = Vector2(new_zoom, new_zoom)

# gestisce lo zoom, rispettando i limiti max_zoom e min_zoom.
# aggiorna la variabile globale zoom_target the viene usata
# da _process.
func _input(event):
#	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if event is InputEventMouse:
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					if zoom_target < min_zoom:
						zoom_target = zoom_target + zoom_increment
				elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					if zoom_target > max_zoom:
						zoom_target = zoom_target - zoom_increment
