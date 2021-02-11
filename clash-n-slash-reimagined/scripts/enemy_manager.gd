extends Node2D

var time_elapsed = 0.0
onready var enemy_tscn = {
	Global.EnemyType.SMALL: preload("res://scenes/enemy_small.tscn")
	}

var enemies_array : Array = Levels.create_level_spawn_data(Levels.Level.ONE)

func _ready():
	pass

func _physics_process(delta):
	for enemy in enemies_array:
		if time_elapsed >= enemy.time_of_spawn:
			#print("spawned!")
			var e = enemy_tscn[enemy.enemy_type].instance()
			e.position = enemy.initial_position
			enemies_array.erase(enemy)
			add_child(e)
	time_elapsed += delta
	pass

func handle_enemy_death(enemy_type):
	match enemy_type:
		Global.EnemyType.SMALL:
			GameState.player_data.add_xp(100)
	GameState.get_gui_node().update_points(GameState.player_data.points)
	pass
