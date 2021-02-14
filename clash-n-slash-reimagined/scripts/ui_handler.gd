extends VBoxContainer

onready var points_label_node : Label = $VBoxTopCont/PointsLabel
onready var upg_ready_node : Label = $VBoxTopCont/UpgReadyNode
onready var upg_panel_node : PopupPanel = get_parent().find_node("UpgradePanel")
onready var ammo_label_node : Label = $VBoxBtmCont/AmmoCont/AmmoLabel
onready var upg_button_node : Button = upg_panel_node.find_node("UpgradeButton")

onready var Crosshair = preload("res://scenes/crosshair.tscn")
var crosshair_node : Node2D

func _ready():
	upg_ready_node.visible = false
	GameState.player_state.current_weapon.connect_to_display()
	_on_update_ammo_display()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair_node = Crosshair.instance()
	add_child(crosshair_node)
	upg_button_node.connect("pressed", self, "_on_upgrade_button_pressed", [upg_button_node])
	pass

func _process(delta):
	crosshair_node.position = get_global_mouse_position()
	if GameState.player_state.upgrades > 0:
		if not upg_ready_node.visible:
			upg_ready_node.visible = true
		if Input.is_action_just_pressed("key_f"):
			set_available_upgrade()
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
	pass

func _on_upgrade_button_pressed(button):
	upg_panel_node.visible = false
	upg_ready_node.visible = false
	GameState.unpause()
	GameState.player_state.upgrades -= 1
	# TODO: Change that fucing method of passing a parameter (upgrade to apply)
	GameState.player_state.current_weapon.upgrade_weapon(int(button.text.left(1)))
	pass # Replace with function body.

func set_available_upgrade():
	var upg_array = GameState.player_state.current_weapon.get_available_upgrades()
	var upg = upg_array[randi() % upg_array.size()]
	var txt
	match upg:
		Weapons.WeaponUpgrades.BULLETS_TWO:
			txt = "Extra bullet"
		Weapons.WeaponUpgrades.BULLETS_THREE:
			txt = "Extra bullet"
		Weapons.WeaponUpgrades.FASTER_RELOAD:
			txt = "Faster reload"
		Weapons.WeaponUpgrades.FASTER_BULLET_SPEED:
			txt = "Faster bullet speed"
		Weapons.WeaponUpgrades.MORE_CLIP_SIZE:
			txt = "More clip size"
		Weapons.WeaponUpgrades.FASTER_FIRERATE:
			txt = "Faster firerate"
	upg_button_node.text = str(upg) + ": " + txt
	pass

func _on_reloading():
	crosshair_node.toggle_reloading(GameState.player_state.current_weapon.is_reloading)
	pass

