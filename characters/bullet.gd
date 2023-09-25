extends Area2D

# @TODO
# cancellare / far explodere il proiettile dopo tot tempo/pixel
# oppure limitare l'area di gioco con dei collider e farlo esplodere?

@export var bullet_speed : float = 200
@export var explosion : PackedScene

var direction : Vector2

func _ready():
	direction = Vector2.UP.rotated(rotation)

func _process(delta):
	position += direction * delta * bullet_speed

func _on_body_entered(_body):
	explode()

func explode():
	# hide the bullet sprite
	hide()
	
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
