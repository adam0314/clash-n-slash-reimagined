extends Node2D

onready var crosshair_sprite = $CrosshairSprite
onready var reload_sprite = $ReloadSprite

func _ready():
	reload_sprite.visible = false
	pass

func toggle_reloading(is_reloading):
	reload_sprite.visible = is_reloading
	crosshair_sprite.visible = not is_reloading
	pass

func _process(delta):
	if reload_sprite.visible:
		var percent_reloaded = GameState.player_state.current_weapon.get_percent_reloaded()
		reload_sprite.rotation = PI/2 + 2*PI*percent_reloaded
	pass
