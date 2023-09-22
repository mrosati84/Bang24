extends CharacterBody2D

@export var speed = 150
@export var rotation_smoothing = 0.02

var last_mouse_position : Vector2 = Vector2.ZERO

func _physics_process(_delta):
	# gestisce rotazione del carro
	var body_rotation = Input.get_axis("left", "right")
	
	if body_rotation != 0:
		rotate(body_rotation * rotation_smoothing)
		
		# preserva la rotazione della torretta quando ruota anche il carro
		if last_mouse_position != Vector2.ZERO:
			rotate_turret(last_mouse_position)
		if not $Body.is_playing():
			$Body.play("walk")
	else:
		$Body.stop()
	
	# gestisce movimento avanti/indietro
	velocity = position.direction_to($Body/Marker2D.get_global_position()) * speed * Input.get_axis("down", "up")
	
	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		$Turret.fire()

func _input(event):
	if event is InputEventMouse:
		last_mouse_position = event.position
		rotate_turret(last_mouse_position)

func rotate_turret(mouse_position: Vector2):
	$Turret.look_at(mouse_position)
	$Turret.rotate(PI/2)
