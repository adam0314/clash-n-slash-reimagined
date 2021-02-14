extends VBoxContainer

onready var points_label_node : Label = $VBoxTopCont/PointsLabel
onready var upg_ready_node : Label = $VBoxTopCont/UpgReadyNode
onready var upg_panel_node : PopupPanel = get_parent().find_node("UpgradePanel")
onready var ammo_label_node : Label = $VBoxBtmCont/AmmoCont/AmmoLabel

onready var Crosshair = preload("res://scenes/crosshair.tscn")
var crosshair_node : Node2D

func _ready():
	upg_ready_node.visible = false
	GameState.player_state.current_weapon.connect_to_display()
	_on_update_ammo_display()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair_node = Crosshair.instance()
	add_child(crosshair_node)
	pass

func _process(delta):
	crosshair_node.position = get_global_mouse_position()
	if GameState.player_state.upgrades > 0:
		if not upg_ready_node.visible:
			upg_ready_node.visible = true
		if Input.is_action_just_pressed("key_f"):
			upg_panel_node.popup()
			GameState.pause()
	pass

func update_points(points_value):
	points_label_node.text = "points: " + str(points_value)

func _on_update_ammo_display():
	match GameState.player_state.current_weapon.type:
		Weapons.WeaponType.LASER:
			ammo_label_node.text = "laser: " + str(GameState.player_state.current_weapon.ammo_left) + \
			" / " + str(GameState.player_state.current_weapon.clip_size)
			ammo_label_node.text += "(reloading)" if GameState.player_state.current_weapon.is_reloading else ""
	pass

func _on_TextureButton_pressed():
	upg_panel_node.visible = false
	upg_ready_node.visible = false
	GameState.unpause()
	GameState.player_state.upgrades -= 1
	GameState.player_state.upgrade_weapon()
	pass # Replace with function body.

func _on_reloading():
	crosshair_node.toggle_reloading(GameState.player_state.current_weapon.is_reloading)
	pass
