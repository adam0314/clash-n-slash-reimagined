class PlayerState:
	
	# Variables w/ setters / getters
	
	var hp : int
	var max_hp : int
	var xp setget , xp_get # setter not needed now
	var upgrades
	var points setget points_set, points_get
	var current_weapon setget current_weapon_set, current_weapon_get
	var missiles
	
	func _init():
		hp = 100
		max_hp = 100
		xp = 0
		upgrades = 0
		points = 0
		current_weapon = Weapons.create_new_weapon(Weapons.WeaponType.LASER)
		missiles = Weapons.create_new_weapon(Weapons.WeaponType.MISSILE)
	
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
		Global.get_gui_node().update_xp()
		pass
	
	func get_xp_percentage():
		return floor((float(xp) / 1000.0)*100.0)
	
	func register_damage(dmg):
		hp -= dmg
		Global.get_gui_node().update_player_hp()
		if hp <= 0:
			die()
		pass
	
	func die():
		GameState.lose()
		pass
