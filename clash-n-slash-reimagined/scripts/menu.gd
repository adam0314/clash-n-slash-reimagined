extends Node2D

func _ready():
	GameState.current_state = GameState.GameState.MENU
	pass

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/level.tscn")
	GameState.current_state = GameState.GameState.PLAYING
	pass
