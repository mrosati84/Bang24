extends Area2D

@export var speed : float = 1.0

var direction : Vector2

func _ready():
	direction = Vector2.UP.rotated(rotation)

func _physics_process(_delta):
	position = position + direction * speed

func _on_body_entered(_body):
	queue_free()
