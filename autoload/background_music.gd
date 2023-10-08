extends AudioStreamPlayer

#TODO tidy up this and make a manager or something

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/BackgroundMusic".connect("finished", Callable(self,"_on_loop_sound").bind($"/root/BackgroundMusic"))
	$"/root/BackgroundMusic".play()

func _on_loop_sound(_player):
	$"/root/BackgroundMusic".stream_paused = false
	$"/root/BackgroundMusic".play()
