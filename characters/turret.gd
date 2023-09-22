extends AnimatedSprite2D

func fire():
	# cooldown che dura quanto l'animazione
	if not is_playing():
		play("fire")
		print("FIRE!")
