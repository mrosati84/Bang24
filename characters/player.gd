extends CharacterBody2D

@export var speed_module : float = 150.0
@export var body_rotation_smoothing = 0.02
@export var turret_rotation_smoothing = 0.05
@export var acceleration = 0.1
@export var controllable = true
@export var bullet : PackedScene
@export var explosion : PackedScene

# oggetto di riferimento che punta sempre davanti al carro
# e viene usato per dare la direzione di movimento in avanti
@onready var forward_marker : Marker2D = $Body/Marker2D
@onready var fire_marker : Marker2D = $Turret/Marker2D
@onready var body : AnimatedSprite2D = $Body
@onready var turret : AnimatedSprite2D = $Turret
@onready var camera : Camera2D = $PlayerCamera

var last_mouse_position : Vector2 = Vector2.ZERO

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	if not controllable:
		camera.queue_free()
	
	MessageBus.player_died.connect(_on_player_died)

func _physics_process(_delta):
	if not controllable or !is_multiplayer_authority():
		return

	# gestisce rotazione del carro
	var body_rotation = Input.get_axis("left", "right")
	
	if body_rotation != 0:
		rotate(body_rotation * body_rotation_smoothing)
		
		# preserva la rotazione della torretta quando ruota anche il carro
		if last_mouse_position != Vector2.ZERO:
			rotate_turret()
		if not body.is_playing():
			body.play("walk")
			$TankMove.play()
	else:
		body.stop()

	# gestisce movimento avanti/indietro
	# la velocità è scomposta in due parti, la direzione e il modulo.
	# la direzione è data dalla direzione verso il forward marker, che è sempre
	# diretto in avanti rispetto al carro, e all'asse up/down che decide se
	# andare avanti o indietro.
	var speed_direction : Vector2 = position.direction_to(forward_marker.get_global_position()) * Input.get_axis("down", "up")
	velocity = velocity.lerp(speed_direction * speed_module, acceleration)
	
	rotate_turret()
	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		if controllable:
			fire(fire_marker.global_position, fire_marker.global_rotation)

func rotate_turret():
	# usa lerp_angle per una rotazione morbida
	var v = get_global_mouse_position() - turret.global_position
	var angle = v.angle()
	var r = turret.global_rotation
	
	turret.global_rotation = lerp_angle(r, angle + PI/2, turret_rotation_smoothing)

func fire(pos, rot):
	# cooldown che dura quanto l'animazione
	if not turret.is_playing():
		turret.play("fire")
		$TankShoot.play()
		
		var b = bullet.instantiate()
		
		#@TODO: retrieve fields from $Turret instead of passing them
		b.global_position = pos
		b.global_rotation = rot
		
		get_tree().root.add_child(b)

func _on_player_died(player: CharacterBody2D):
	if player.get_instance_id() == get_instance_id():
		explode()
		player.queue_free()
		print("sono morto" + str(player.get_instance_id()))

func explode():
	var e = explosion.instantiate()
	e.global_position = global_position
	e.scale = Vector2(5, 5)
	$TankExplode.play()
	
	get_parent().add_child(e)
