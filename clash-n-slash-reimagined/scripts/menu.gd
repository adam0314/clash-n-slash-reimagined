extends Node2D

func _ready():
	randomize()
	GameState.current_state = GameState.GameState.MENU
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/level.tscn")
	GameState.current_state = GameState.GameState.PLAYING
	pass
