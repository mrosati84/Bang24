extends CharacterBody2D

@export var speed = 150

func _physics_process(_delta):
	var movement = Input.get_vector("left", "right", "up", "down")
	velocity = movement * speed
	
	if velocity != Vector2.ZERO:
		$Body.play("walk")
	else:
		$Body.stop()
	
	# TODO: va ruotato verso la direzione di movimento prima di muovere
	move_and_slide()

func _input(event):
	if event is InputEventMouse:
		# TODO: la rotazione è sbagliata
		$Turret.look_at(event.position)
		$Turret.rotate(PI/2)
