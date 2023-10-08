extends AudioStreamPlayer

#TODO tidy up this and make a manager or something

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/BackgroundMusic".connect("finished", Callable(self,"_on_loop_sound").bind($"/root/BackgroundMusic"))
	$"/root/BackgroundMusic".play()

func _on_loop_sound(player):
	$"/root/BackgroundMusic".stream_paused = false
	$"/root/BackgroundMusic".play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
