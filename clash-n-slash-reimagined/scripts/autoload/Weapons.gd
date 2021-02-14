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

const weapon_firerate = {
	WeaponType.LASER: 3.0,
}

const weapon_sounds = {
	WeaponType.LASER: preload("res://sound/pewpews/pewpew_1.wav")
}

const bullet_nodes = {
	BulletType.LASER: preload("res://scenes/bullet_laser.tscn")
}

func get_gui_node():
	return get_tree().get_nodes_in_group("ui")[0]

### Weapon models

func create_new_weapon(weapon_type):
	match weapon_type:
		WeaponType.LASER:
			return LaserModel.new(weapon_firerate[weapon_type], 1.0, 1, 8, self, bullet_nodes[BulletType.LASER], bullet_speed[BulletType.LASER])
		_:
			return null

func add_timer(timer):
	add_child(timer)
	pass

### Weapon models classes

class WeaponModel:
	
	var type
	var firerate : float
	var firerate_timer : Timer
	var reload_time : float
	var reload_timer : Timer
	var weapons_global_node
	var shot_sound
	var can_shoot : bool
	var is_reloading : bool
	
	signal update_ammo_label
	signal update_cursor_reloading
	
	func _init(w, f, r_t, t_p_n):
		type = w
		firerate = f
		reload_time = r_t
		weapons_global_node = t_p_n
		
		firerate_timer = Timer.new()
		reload_timer = Timer.new()
		firerate_timer.connect("timeout", self, "_on_firerate_timer_timeout")
		reload_timer.connect("timeout", self, "_on_reload_timer_timeout")
		firerate_timer.wait_time = 1.0 / firerate
		reload_timer.wait_time = 1.0 / reload_time
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

class LaserModel extends WeaponModel:
	
	var bullets_per_shot : int
	var clip_size : int
	var ammo_left : int
	var bullet_node
	var bullet_speed : float
	
	func _init(f, r_t, bps, c_s, t_p_n, b_n, b_s).(WeaponType.LASER, f, r_t, t_p_n):
		bullets_per_shot = bps
		clip_size = c_s
		shot_sound = weapon_sounds[WeaponType.LASER]
		bullet_node = b_n
		bullet_speed = b_s
		ammo_left = clip_size
	
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
		can_shoot = false
		is_reloading = true
		if not firerate_timer.is_stopped():
			firerate_timer.stop()
		reload_timer.start()
		self.emit_signal("update_ammo_label")
		self.emit_signal("update_cursor_reloading")
		pass
