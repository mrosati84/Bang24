extends Node2D

@export var life : int = 100
@export var alive : bool = true

var player : CharacterBody2D
var main : Node2D
var life_value : Label
var game_over : PanelContainer

func _ready():
	player = get_parent()
	main = player.get_parent()
	
	life_value = main.get_node("HUD/HUDContainer/MarginContainerLife/LifeGrid/LifeValue")
	game_over = main.get_node("HUD/GameOverPanel/")
	
	$ProgressBar.value = life

func damage():
	if alive:
		life -= 20
		$ProgressBar.value = life
		
		# set life value in the HUD
		if player.controllable:
			life_value.text = str(life)
		
		if life == 0:
			MessageBus.player_died.emit(player)
			alive = false
			
			if player.controllable:
				game_over.visible = true
