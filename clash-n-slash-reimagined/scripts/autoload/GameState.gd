extends Node

enum GameState {
	MENU,
	PLAYING
}

var current_state

var player_data = PlayerData.new()

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

class PlayerData:
	
	# Variables w/ setters / getters
	
	var xp = 0 setget , xp_get # setter not needed now
	var upgrades = 0
	var points = 0 setget points_set, points_get
	var current_weapon = Global.WeaponType.LASER1 setget current_weapon_set, current_weapon_get
	
	func xp_get():
		return xp
	
	func points_set(points_to_set):
		points = points_to_set
		pass
	
	func points_get():
		return points
	
	func current_weapon_set(wpn_to_set):
		current_weapon = wpn_to_set
	
	func current_weapon_get():
		return current_weapon
		
	# Methods
	
	func add_xp(xp_to_add):
		xp += xp_to_add
		points += xp_to_add
		if xp >= 1000: # Replace with some constant - maybe a XP per level table
			upgrades += 1
			xp = 0
		pass
	
	func upgrade_weapon():
		match current_weapon:
			Global.WeaponType.LASER1:
				current_weapon = Global.WeaponType.LASER2
			Global.WeaponType.LASER2:
				current_weapon = Global.WeaponType.LASER3
			_:
				print("fuck off this is the max I have made so far")
		pass
