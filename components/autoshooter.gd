extends Node2D

func _on_timer_timeout():
	var parent : CharacterBody2D = get_parent()
	var fire_marker = parent.fire_marker
	
	get_parent().fire(fire_marker.global_position, fire_marker.global_rotation)
