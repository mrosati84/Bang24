extends CharacterBody2D

@export var speed = 150
@export var rotation_smoothing = 0.02

# oggetto di riferimento che punta sempre davanti al carro
# e viene usato per dare la direzione di movimento in avanti
@onready var forward_marker : Marker2D = $Body/Marker2D
@onready var body : AnimatedSprite2D = $Body
@onready var turret : AnimatedSprite2D = $Turret

var last_mouse_position : Vector2 = Vector2.ZERO

func _physics_process(_delta):
	# gestisce rotazione del carro
	var body_rotation = Input.get_axis("left", "right")
	
	if body_rotation != 0:
		rotate(body_rotation * rotation_smoothing)
		
		# preserva la rotazione della torretta quando ruota anche il carro
		if last_mouse_position != Vector2.ZERO:
			rotate_turret(last_mouse_position)
		if not body.is_playing():
			body.play("walk")
	else:
		body.stop()
	
	# gestisce movimento avanti/indietro
	velocity = position.direction_to(forward_marker.get_global_position()) * speed * Input.get_axis("down", "up")
	
	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		turret.fire()

func _input(event):
	if event is InputEventMouse:
		last_mouse_position = event.position
		rotate_turret(last_mouse_position)

func rotate_turret(mouse_position: Vector2):
	turret.look_at(mouse_position)
	turret.rotate(PI/2)
