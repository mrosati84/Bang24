extends Node2D

@export var player : PackedScene

@onready var restart_button : Button = $HUD/GameOverPanel/GameOver/GameOverGrid/RestartButton
@onready var game_over : PanelContainer = $HUD/GameOverPanel
@onready var life_value : Label = $HUD/HUDContainer/MarginContainerLife/LifeGrid/LifeValue

func _ready():
	# connette via codice il segnale "pressed" del pulsante di riavvio
	# nella HUD
	restart_button.connect("pressed", _on_restart_button_pressed)
	
	# aggiunge i player
	var player_index = 0
	
	# aggiunge tutti i player connessi nella scena.
	# TODO: gestire il single player quando MultiplayerManager.players è vuoto
	for p in MultiplayerManager.players:
		var current_player = player.instantiate()

		for spawn_point in get_tree().get_nodes_in_group("SpawnPoint"):
			if spawn_point.name == str(player_index):
				current_player.global_position = spawn_point.global_position
				
				if p != multiplayer.get_unique_id():
					current_player.controllable = false
				
				add_child(current_player)
		
		player_index += 1

func _on_restart_button_pressed():
	$TankRespawn.play()
	
	game_over.visible = false
	life_value.text = str(100)
	var p = player.instantiate()
	add_child(p)
