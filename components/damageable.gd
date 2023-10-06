extends Node2D

signal die

@export var life : int = 100
@export var alive : bool = true

var parent : CharacterBody2D

func _ready():
	parent = get_parent()
	$ProgressBar.value = life

func _process(_delta):
	rotation = -parent.global_rotation

func damage():
	if alive:
		life -= 20
		$ProgressBar.value = life
		
		if life == 0:
			alive = false
			die.emit()
