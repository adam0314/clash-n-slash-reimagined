extends Node

### Global constants

var resolution = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

const max_distance_from_planet = 620.0

### Enemies

enum EnemyType {
	SMALL = 0,
	KEK = 1
}

const enemy_speed = {
	EnemyType.SMALL: 40.0
}

func get_gui_node():
	return get_tree().get_nodes_in_group("ui")[0]
