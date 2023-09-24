extends AnimatedSprite2D

func _ready():
	var random_explosions = ["explosion_1", "explosion_2", "explosion_3"]
	play(random_explosions.pick_random())

func _on_animation_finished():
	queue_free()
