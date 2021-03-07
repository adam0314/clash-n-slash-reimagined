extends VBoxContainer

onready var points_label_node : RichTextLabel = $BtmCont/XpPtsCont/PointsLabel
onready var upg_panel_node : PopupPanel = get_parent().find_node("UpgradePanel")
onready var ammo_label_node : Label = $BtmCont/PlayerDataCont/AmmoCont/AmmoLabel
onready var missiles_node : TextureRect = $BtmCont/PlayerDataCont/AmmoCont/Missiles

onready var upg_button_1 : TextureButton = upg_panel_node.find_node("UpgButton1")
onready var upg_button_2 : TextureButton = upg_panel_node.find_node("UpgButton2")
onready var upg_label_node : Label = upg_panel_node.find_node("UpgTooltipLabel")
var upg_1 : int
var upg_2 : int

onready var Crosshair = preload("res://scenes/crosshair.tscn")
var crosshair_node : Node2D

onready var hp_player_node : TextureProgress = $BtmCont/PlayerDataCont/HpPlayer
onready var hp_planet_node : TextureProgress = $BtmCont/PlanetDataCont/HpPlanet
onready var xp_node : ProgressBar = $BtmCont/XpPtsCont/CenterContainer/Xp

var upg_textures = {
	Weapons.WeaponUpgrades.BULLETS_TWO: preload("res://sprite/icons/bullets_two.png"),
	Weapons.WeaponUpgrades.BULLETS_THREE: preload("res://sprite/icons/bullets_three.png"),
	Weapons.WeaponUpgrades.FASTER_RELOAD: preload("res://sprite/icons/faster_reload.png"),
	Weapons.WeaponUpgrades.FASTER_BULLET_SPEED: preload("res://sprite/icons/faster_bullet_speed.png"),
	Weapons.WeaponUpgrades.MORE_CLIP_SIZE: preload("res://sprite/icons/more_clip_size.png"),
	Weapons.WeaponUpgrades.FASTER_FIRERATE: preload("res://sprite/icons/faster_firerate.png")
}

var upg_tooltips = {
	Weapons.WeaponUpgrades.BULLETS_TWO: "Gain extra bullet (double-shot)",
	Weapons.WeaponUpgrades.BULLETS_THREE: "Gain extra bullet (triple-shot)",
	Weapons.WeaponUpgrades.FASTER_RELOAD: "Decrease reload time",
	Weapons.WeaponUpgrades.FASTER_BULLET_SPEED: "Increase bullet speed",
	Weapons.WeaponUpgrades.MORE_CLIP_SIZE: "Increase magazine size",
	Weapons.WeaponUpgrades.FASTER_FIRERATE: "Increase firerate"
}

func _ready():
	GameState.player_state.current_weapon.connect_to_display()
	GameState.player_state.missiles.connect_to_display()
	_on_update_ammo_display()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair_node = Crosshair.instance()
	add_child(crosshair_node)
	upg_button_1.connect("pressed", self, "_on_upgrade_button_pressed", [upg_button_1])
	upg_button_2.connect("pressed", self, "_on_upgrade_button_pressed", [upg_button_2])
	upg_button_1.connect("mouse_entered", self, "_on_upg_button_mouse_entered", [upg_button_1])
	upg_button_2.connect("mouse_entered", self, "_on_upg_button_mouse_entered", [upg_button_2])
	upg_button_1.connect("mouse_exited", self, "_on_upg_button_mouse_exited")
	upg_button_2.connect("mouse_exited", self, "_on_upg_button_mouse_exited")
	_on_update_missiles()
	update_player_hp()
	pass

func _process(delta):
	crosshair_node.position = get_global_mouse_position()
	var pts_txt = "[center]" + str(GameState.player_state.points) + "[/center]"
	if GameState.player_state.upgrades > 0:
		pts_txt = "[color=green]" + pts_txt + "[/color]"
		if Input.is_action_just_pressed("key_f"):
			if upg_panel_node.visible:
				return
			set_available_upgrade()
			upg_panel_node.popup()
			crosshair_node.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GameState.pause()
	points_label_node.bbcode_text = pts_txt
	pass

func _on_update_ammo_display():
	match GameState.player_state.current_weapon.type:
		Weapons.WeaponType.LASER:
			ammo_label_node.text = "laser: " + str(GameState.player_state.current_weapon.ammo_left) + \
			" / " + str(GameState.player_state.current_weapon.clip_size)
	pass

func _on_upgrade_button_pressed(button):
	var upg_to_apply = upg_1 if button.name == "UpgButton1" else upg_2
	upg_1 = -1
	upg_2 = -1
	upg_panel_node.visible = false
	crosshair_node.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameState.unpause()
	GameState.player_state.upgrades -= 1
	GameState.player_state.current_weapon.upgrade_weapon(upg_to_apply)
	pass

func _on_upg_button_mouse_entered(button):
	var upg_tooltip = upg_tooltips[upg_1] if button.name == "UpgButton1" else upg_tooltips[upg_2]
	upg_label_node.text = upg_tooltip
	pass

func _on_upg_button_mouse_exited():
	upg_label_node.text = ""
	pass

func set_available_upgrade():
	var upg_array : Array = GameState.player_state.current_weapon.get_available_upgrades()
	upg_1 = upg_array[randi() % upg_array.size()]
	upg_array.erase(upg_1)
	upg_2 = upg_array[randi() % upg_array.size()]
	upg_button_1.set_normal_texture(upg_textures[upg_1])
	upg_button_2.set_normal_texture(upg_textures[upg_2])
	upg_label_node.text = ""
	pass

func _on_reloading():
	crosshair_node.toggle_reloading(GameState.player_state.current_weapon.is_reloading)
	pass

func _on_update_missiles():
	var missile_texture_size_x = missiles_node.texture.get_size().x
	var missiles_left = GameState.player_state.missiles.missiles_left
	if missiles_left <= 0:
		missiles_node.visible = false
	else:
		missiles_node.set_custom_minimum_size(Vector2(missiles_left * missile_texture_size_x,0))
		missiles_node.visible = true
	pass

func update_player_hp():
	hp_player_node.value = GameState.player_state.hp
	pass

func update_planet_hp():
	hp_planet_node.value = GameState.planet_state.hp
	pass

func update_xp():
	xp_node.value = GameState.player_state.get_xp_percentage()
	pass
