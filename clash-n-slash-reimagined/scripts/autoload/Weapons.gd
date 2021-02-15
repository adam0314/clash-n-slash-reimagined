extends Node

### Bullets

enum BulletType {LASER}

const bullet_speed = {
	BulletType.LASER: 400.0
}

### Weapons

enum WeaponType {
	LASER
}

const weapon_params = {
	WeaponType.LASER: {
		"firerate": 3.0,
		"reload_time": 1.0,
		"bullets_per_shot": 1,
		"clip_size": 8,
		"sound": preload("res://sound/pewpews/pewpew_1.wav"),
		"bullet": {
			"node": preload("res://scenes/bullet_laser.tscn"),
			"speed": 400.0
		},
		"max_parameters": {
			"firerate": 8.0,
			"reload_time": 0.4,
			"bullet_speed": 800.0,
			"clip_size": 16
		}
		
		# TODO: Maybe add maximum (or minimum) values of some parameters here, like max clip_size
	}
}

enum WeaponUpgrades {
	BULLETS_TWO, BULLETS_THREE, FASTER_RELOAD, FASTER_BULLET_SPEED, MORE_CLIP_SIZE, FASTER_FIRERATE
}

func get_gui_node():
	return get_tree().get_nodes_in_group("ui")[0]

### Weapon models

func create_new_weapon(weapon_type):
	match weapon_type:
		WeaponType.LASER:
			return LaserModel.new(self, weapon_params[WeaponType.LASER])
		_:
			return null

func add_timer(timer):
	add_child(timer)
	pass

### Weapon models classes

class WeaponModel:
	
	var type
	var firerate : float setget set_firerate
	var firerate_timer : Timer
	var reload_time : float setget set_reload_time
	var reload_timer : Timer
	var weapons_global_node
	var shot_sound
	var can_shoot : bool
	var is_reloading : bool
	
	signal update_ammo_label
	signal update_cursor_reloading
	
	func _init(wpn_glb_node, w, f, r_t):
		type = w
		firerate = f
		reload_time = r_t
		weapons_global_node = wpn_glb_node
		
		firerate_timer = Timer.new()
		reload_timer = Timer.new()
		firerate_timer.connect("timeout", self, "_on_firerate_timer_timeout")
		reload_timer.connect("timeout", self, "_on_reload_timer_timeout")
		firerate_timer.wait_time = 1.0 / firerate
		reload_timer.wait_time = reload_time
		weapons_global_node.add_child(firerate_timer)
		weapons_global_node.add_child(reload_timer)
		
		can_shoot = true
		
		pass
	
	func _on_firerate_timer_timeout():
		if not is_reloading:
			can_shoot = true
		firerate_timer.stop()
		pass
	
	func _on_reload_timer_timeout():
		assert(false) # shouldn't run
		pass
	
	func connect_to_display():
		self.connect("update_ammo_label", weapons_global_node.get_gui_node(), "_on_update_ammo_display")
		self.connect("update_cursor_reloading", weapons_global_node.get_gui_node(), "_on_reloading")
		pass
	
	func get_percent_reloaded():
		return clamp((reload_time - reload_timer.time_left)/reload_time, 0.0, 1.0)
	
	func set_firerate(firerate_to_set):
		firerate = firerate_to_set
		firerate_timer.wait_time = 1.0 / firerate_to_set
		pass
	
	func set_reload_time(reload_time_to_set):
		reload_time = reload_time_to_set
		reload_timer.wait_time = reload_time_to_set
		pass

class LaserModel extends WeaponModel:
	
	var bullets_per_shot : int
	var clip_size : int
	var ammo_left : int
	var bullet_node
	var bullet_speed : float
	
	func _init(weapons_global_node, weapon_params).(weapons_global_node, WeaponType.LASER, weapon_params.firerate, weapon_params.reload_time):
		bullets_per_shot = weapon_params.bullets_per_shot
		clip_size = weapon_params.clip_size
		shot_sound = weapon_params.sound
		bullet_node = weapon_params.bullet.node
		bullet_speed = weapon_params.bullet.speed
		ammo_left = weapon_params.clip_size
	
	func shoot_if_possible():
		if can_shoot:
			can_shoot = false
			ammo_left -= 1
			self.emit_signal("update_ammo_label")
			if ammo_left <= 0:
				reload()
				#return true
			firerate_timer.start()
			return true
		else:
			return false
	
	func _on_reload_timer_timeout():
		can_shoot = true
		is_reloading = false
		ammo_left = clip_size
		reload_timer.stop()
		self.emit_signal("update_ammo_label")
		self.emit_signal("update_cursor_reloading")
		pass
	
	func reload():
		if ammo_left >= clip_size or is_reloading:
			return
		can_shoot = false
		is_reloading = true
		if not firerate_timer.is_stopped():
			firerate_timer.stop()
		reload_timer.start()
		self.emit_signal("update_ammo_label")
		self.emit_signal("update_cursor_reloading")
		pass
	
	func get_available_upgrades():
		var av_upgs = Weapons.WeaponUpgrades.values()
		match bullets_per_shot:
			1:
				av_upgs.erase(Weapons.WeaponUpgrades.BULLETS_THREE)
			2:
				av_upgs.erase(Weapons.WeaponUpgrades.BULLETS_TWO)
			_:
				av_upgs.erase(Weapons.WeaponUpgrades.BULLETS_TWO)
				av_upgs.erase(Weapons.WeaponUpgrades.BULLETS_THREE)
		if reload_time <= 0.4:
			av_upgs.erase(Weapons.WeaponUpgrades.FASTER_RELOAD)
		if bullet_speed >= 800.0:
			av_upgs.erase(Weapons.WeaponUpgrades.FASTER_BULLET_SPEED)
		if clip_size >= 16:
			av_upgs.erase(Weapons.WeaponUpgrades.MORE_CLIP_SIZE)
		if firerate >= 8.0:
			av_upgs.erase(Weapons.WeaponUpgrades.MORE_CLIP_SIZE)
		return av_upgs
	
	func upgrade_weapon(upgrade_to_apply):
		var max_params = Weapons.weapon_params[type].max_parameters
		match upgrade_to_apply:
			Weapons.WeaponUpgrades.BULLETS_TWO:
				bullets_per_shot += 1
			Weapons.WeaponUpgrades.BULLETS_THREE:
				bullets_per_shot += 1
			Weapons.WeaponUpgrades.FASTER_RELOAD:
				set_reload_time(max(reload_time - 0.1, max_params.reload_time)) # Minimum reload time
			Weapons.WeaponUpgrades.FASTER_BULLET_SPEED:
				bullet_speed = min(bullet_speed + 50.0, max_params.bullet_speed) # Maximum bullet speed
			Weapons.WeaponUpgrades.MORE_CLIP_SIZE:
				clip_size = min(clip_size + 2, max_params.clip_size) # Maximum clip size
				self.emit_signal("update_ammo_label")
			Weapons.WeaponUpgrades.FASTER_FIRERATE:
				set_firerate(min(firerate + 0.4, max_params.firerate))
		pass
