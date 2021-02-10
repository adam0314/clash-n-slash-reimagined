extends Node

var BulletLaser
var player
var current_weapon
var timers = {}
var can_shoot = {}

func init(player_script):
	player = player_script
	BulletLaser = preload("res://scenes/bullet_laser.tscn")
	current_weapon = Global.WeaponType.LASER1
	player.gun_sound_node.stream = Global.weapon_sounds[current_weapon]
	for weapon in Global.WeaponType.values():
		can_shoot[weapon] = true
	init_timers()
	pass

func init_timers():
	for weapon in Global.WeaponType.values():
		timers[weapon] = Timer.new();
		timers[weapon].connect("timeout", self, "_on_timer_shoot", [weapon])
		timers[weapon].wait_time = 1.0 / Global.weapon_firerate[weapon]
		player.bullet_node.add_child(timers[weapon])
	pass

func _on_timer_shoot(weapon_type):
	can_shoot[weapon_type] = true
	timers[weapon_type].stop()
	pass

#func _process(delta):
#	pass

func change_weapon(to_weapon):
	player.gun_sound_node.stream = Global.weapon_sounds[to_weapon]
	pass

func shoot():
	if can_shoot[current_weapon]:
		instance_bullets()
		timers[current_weapon].start()
		can_shoot[current_weapon] = false
	pass

func instance_bullets():
	match current_weapon:
		Global.WeaponType.LASER1:
			var bullet_laser_instance = BulletLaser.instance()
			bullet_laser_instance.position = player.gun_front_pos.get_global_position()
			bullet_laser_instance.direction = Vector2.RIGHT.rotated(player.rotation)
			bullet_laser_instance.rotation = player.rotation
			player.bullet_node.add_child(bullet_laser_instance)
			player.gun_sound_node.play()
	pass
