extends Node

func _ready():
	randomize()
	game_state = GameState.MENU
	pass

enum GameState {
	MENU,
	PLAYING,
	DIED
}

var game_state

var player_state = preload("res://scripts/PlayerData.gd").PlayerData.new()

func get_gui_node():
	return get_tree().get_nodes_in_group("ui")[0]

func pause():
	get_tree().paused = true
	get_tree().get_nodes_in_group("music")[0].volume_db = -20
	pass

func unpause():
	get_tree().paused = false
	get_tree().get_nodes_in_group("music")[0].volume_db = -2
	pass

func lose():
	game_state = GameState.DIED
	get_tree().change_scene("res://scenes/menu.tscn")
	pass
