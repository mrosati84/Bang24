extends Node2D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in MultiplayerManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		
#		currentPlayer.name = MultiplayerManager.Players[i].name
#		currentPlayer.id = str(MultiplayerManager.Players[i].id)
		
		currentPlayer.name = str(MultiplayerManager.Players[i].id)
		
		# @FIXME just testing if we can remove the "server player"
		if (currentPlayer.name != "1"):
			add_child(currentPlayer)
			
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				if spawn.name == str(index):
					currentPlayer.global_position = spawn.global_position

			index += 1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
