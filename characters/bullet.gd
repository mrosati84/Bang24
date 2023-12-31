extends Area2D

@export var bullet_speed : float = 200
@export var explosion : PackedScene
@export var direction : Vector2

var impacted : bool = false

func _ready():
	direction = Vector2.UP.rotated(rotation)

func _process(delta):
	if not impacted and is_multiplayer_authority():
		position += direction * delta * bullet_speed

func _on_body_entered(_body):
	pass
#	if _body.is_in_group("Player"):
#		# colpito il player
#		_body.get_node("Damageable").damage()
#	if not impacted and is_multiplayer_authority():
#		explode()

func explode():
	# hide the bullet sprite
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	impacted = true
	
	$GenericHit.play()
	
	# add the explosion and assign it the bullet position
	var e = explosion.instantiate()
	e.global_position = global_position
	
	# connect programmatically the animation_finished signal
	e.animation_finished.connect(_on_explosion_animation_finished)
	
	# add the explosion to the tree
	get_tree().root.add_child(e)

func _on_explosion_animation_finished():
	# explosion animation finished, delete the bullet
	queue_free()
