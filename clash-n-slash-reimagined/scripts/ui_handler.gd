extends VBoxContainer

onready var points_label_node : Label = $PointsLabel
onready var upg_ready_node : Label = $UpgReadyNode
onready var upg_panel_node : PopupPanel = get_parent().find_node("UpgradePanel")

func _ready():
	upg_ready_node.visible = false
	pass

func _process(delta):
	if GameState.player_data.upgrades > 0:
		if not upg_ready_node.visible:
			upg_ready_node.visible = true
		if Input.is_action_just_pressed("key_f"):
			upg_panel_node.popup()
			GameState.pause()
	pass

func update_points(points_value):
	points_label_node.text = "points: " + str(points_value)

func _on_TextureButton_pressed():
	upg_panel_node.visible = false
	upg_ready_node.visible = false
	GameState.unpause()
	GameState.player_data.upgrades -= 1
	GameState.player_data.upgrade_weapon()
	pass # Replace with function body.
