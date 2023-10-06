extends Node2D

signal die

@export var life : int = 100
@export var alive : bool = true

var player : CharacterBody2D
var main : Node2D

func _ready():
	player = get_parent()
	main = player.get_parent()
	$ProgressBar.value = life

func _process(_delta):
	rotation = -player.global_rotation

func damage():
	if alive:
		life -= 20
		$ProgressBar.value = life
		
		# set life value in the HUD
		if player.controllable:
			var life_value : Label = main.get_node("HUD/PanelContainer/MarginContainer/Life/LifeValue")
			life_value.text = str(life)
		
		if life == 0:
			alive = false
			die.emit()
