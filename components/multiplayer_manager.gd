extends Node

@onready var bullet = load("res://characters/bullet.tscn")
@onready var spawn_path = get_node("/root/Main/Level/SpawnPath")

var seq = 0

@rpc("any_peer")
func fire():
	var b = bullet.instantiate()
	var sender_id = multiplayer.get_remote_sender_id()
	var sender : CharacterBody2D = get_node("/root/Main/Level/SpawnPath/" + str(sender_id))
	
	b.transform = sender.transform

	b.rotation = sender.get_node("Turret").global_rotation
	
	b.name = str(str(multiplayer.get_remote_sender_id()) + str(seq))
	spawn_path.add_child(b, true)
	seq += 1
