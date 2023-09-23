extends AnimatedSprite2D

@export var bullet :PackedScene

func fire(pos, rot):
	# cooldown che dura quanto l'animazione
	if not is_playing():
		play("fire")
		
		var b = bullet.instantiate()
		#@TODO: retrieve fields from $Turret instead of passing them
		b.global_position = pos
		b.global_rotation = rot
		
		get_tree().root.add_child(b)
