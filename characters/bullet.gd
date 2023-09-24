extends Area2D

@export var speed : float = 1.0

var direction : Vector2

func _ready():
	direction = Vector2(0,-1).rotated(rotation)
	print(direction)

func _physics_process(_delta):
	position = position + direction * speed
