extends KinematicBody2D

export(float) var rotation_speed = PI / 6.0
onready var sprite = $Sprite

func _ready():
	pass # Replace with function body.

func _process(delta):
	sprite.rotate(delta * rotation_speed)
	pass
