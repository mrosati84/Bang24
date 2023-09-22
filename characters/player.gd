extends CharacterBody2D

@export var speed = 150
@export var body_rotation_smoothing = 0.02
@export var turret_rotation_smoothing = 0.05
@export var acceleration = 0.1

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
		rotate(body_rotation * body_rotation_smoothing)
		
		# preserva la rotazione della torretta quando ruota anche il carro
		if last_mouse_position != Vector2.ZERO:
			rotate_turret()
		if not body.is_playing():
			body.play("walk")
	else:
		body.stop()
	
	# gestisce movimento avanti/indietro
	velocity = velocity.lerp(position.direction_to(forward_marker.get_global_position()) * speed * Input.get_axis("down", "up"), acceleration)
	
	rotate_turret()
	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		turret.fire()

func rotate_turret():
	# usa lerp_angle per una rotazione morbida
	var v = get_global_mouse_position() - turret.global_position
	var angle = v.angle()
	var r = turret.global_rotation
	
	turret.global_rotation = lerp_angle(r, angle + PI/2, turret_rotation_smoothing)
