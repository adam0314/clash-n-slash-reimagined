extends Node2D

var time_elapsed = 0.0
onready var enemy_small = preload("res://scenes/enemy_small.tscn")
const time_to_spawn = 0.2

func _ready():
	pass

func _physics_process(delta):
	time_elapsed += delta
	var enemies = get_child_count()
	if time_elapsed > time_to_spawn and enemies < 100:
		time_elapsed = 0.0
		var e = enemy_small.instance()
		e.position = Vector2(Global.max_distance_from_planet,0.0).rotated(rand_range(0, 2*PI))
		add_child(e)
	pass
