extends Node2D

var menu_music = preload("res://sound/music/_009_system.ogg")
var lose_music = preload("res://sound/music/mission_failed.ogg")

onready var tab_container : TabContainer = $MainLayer/TabContainer
onready var music_player : AudioStreamPlayer = $MusicPlayer

func _ready():
	update_tab()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func update_tab():
	match GameState.game_state:
		GameState.GameState.MENU:
			tab_container.current_tab = 0
			music_player.stream = menu_music
		GameState.GameState.DIED:
			tab_container.current_tab = 1
			music_player.stream = lose_music
		_:
			print("wtf jedse")
			assert(false)
	music_player.playing = true
	pass

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/level.tscn")
	GameState.game_state = GameState.GameState.PLAYING
	pass

func _on_back_to_menu_button_pressed():
	GameState.game_state = GameState.GameState.MENU
	update_tab()
	pass
