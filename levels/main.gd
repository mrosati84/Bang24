extends Node2D

@export var player : PackedScene

@onready var restart_button : Button = $HUD/GameOverPanel/GameOver/GameOverGrid/RestartButton
@onready var game_over : PanelContainer = $HUD/GameOverPanel
@onready var life_value : Label = $HUD/HUDContainer/MarginContainerLife/LifeGrid/LifeValue

func _ready():
	# connette via codice il segnale "pressed" del pulsante di riavvio
	# nella HUD
	restart_button.connect("pressed", _on_restart_button_pressed)

func _on_restart_button_pressed():
	$TankRespawn.play()
	
	game_over.visible = false
	life_value.text = str(100)
	var p = player.instantiate()
	add_child(p)
