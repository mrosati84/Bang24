extends Node

@onready var bullet = load("res://characters/bullet.tscn")
@onready var spawn_path = get_node("/root/Main/Level/SpawnPath")

var seq = 0

@rpc("any_peer")
func fire(position, rotation):
	print("FIRE!")
	print(position)
	print(rotation)
	
	var b = bullet.instantiate()
	b.name = str(str(multiplayer.get_remote_sender_id()) + str(seq))
	spawn_path.add_child(b, true)
	seq += 1
	
	# QUESTA ROBA VIENE IGNORATA
	b.global_position = position
	b.global_rotation = rotation
