extends Node

enum Level {
	ONE = 1
}

# Array of arrays
# [Time of spawn (in seconds), enemy type, position]

class SpawnData:
	var time_of_spawn : float
	var enemy_type
	var initial_position : Vector2
	
	func _init(t, e, i_p, rad):
		time_of_spawn = float(t)
		enemy_type = e
		initial_position = i_p + Vector2(float(rad), 0.0).rotated(rand_range(0, 2*PI))

func create_level_spawn_data(level):
	var spawn_data = []
	var file = File.new()
	match level:
		Levels.Level.ONE:
			file.open("res://constants/Level1.csv", file.READ)
			
	while !file.eof_reached():
		var csv = file.get_csv_line(";")
		if csv[0].left(1) == "#": # #line is a comment
			continue
		var enemy_to_add
		match int(csv[1]):
			Global.EnemyType.SMALL:
				enemy_to_add = Global.EnemyType.SMALL
		spawn_data.append(SpawnData.new(csv[0],enemy_to_add,Vector2(float(csv[2]),float(csv[3])),csv[4]))
		
	file.close()
	return spawn_data
