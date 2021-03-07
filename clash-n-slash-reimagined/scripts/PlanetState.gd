class PlanetState:
	
	var hp : int
	var max_hp : int
	var xp : int
	var upgrades : int
	
	func _init():
		hp = 100
		max_hp = 100
		xp = 0
		upgrades = 0
	
	func register_damage(dmg):
		hp -= dmg
		Global.get_gui_node().update_planet_hp()
		if hp <= 0:
			die()
		pass
	
	func die():
		GameState.lose()
		pass
