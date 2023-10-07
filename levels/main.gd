extends Node2D

@export var player : PackedScene

func _ready():
	# connette via codice il segnale "pressed" del pulsante di riavvio
	# nella HUD
	$HUD/GameOverPanel/GameOver/GameOverGrid/RestartButton.connect("pressed", _on_restart_button_pressed)

func _on_restart_button_pressed():
	$HUD/GameOverPanel/GameOver.visible = false
	$HUD/HUDContainer/MarginContainerLife/LifeGrid/LifeValue.text = str(100)
	var p = player.instantiate()
	p.controllable = true # non dovrebbe servire
	add_child(p)
