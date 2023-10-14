extends Node

@onready var bullet = load("res://characters/bullet.tscn")
@onready var spawn_path = get_node("/root/Main/Level/SpawnPath")

var seq = 0

@rpc("any_peer")
func fire():
	var b = bullet.instantiate()
	var sender_id = multiplayer.get_remote_sender_id()
	var sender : CharacterBody2D = get_node("/root/Main/Level/SpawnPath/" + str(sender_id))
	var sender_turret = sender.get_node("Turret")
	var turret_rotation = sender_turret.global_rotation
	
	b.transform = sender.transform.translated(Vector2(0, -60).rotated(turret_rotation))
	b.rotation = turret_rotation
	b.name = str(str(multiplayer.get_remote_sender_id()) + str(seq))
	
	spawn_path.add_child(b, true)
	seq += 1
