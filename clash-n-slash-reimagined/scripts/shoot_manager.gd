extends Node

var BulletLaser
var player
var timers = {}
var can_shoot = {}

func init(player_script):
	player = player_script
	BulletLaser = preload("res://scenes/bullet_laser.tscn")
	player.gun_sound_node.stream = Global.weapon_sounds[GameState.player_data.current_weapon]
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
	if can_shoot[GameState.player_data.current_weapon]:
		instance_bullets()
		timers[GameState.player_data.current_weapon].start()
		can_shoot[GameState.player_data.current_weapon] = false
	pass

func instance_bullets():
	match GameState.player_data.current_weapon:
		Global.WeaponType.LASER1:
			var b_l_inst = BulletLaser.instance()
			b_l_inst.position = player.gun_front_pos.get_global_position()
			b_l_inst.direction = Vector2.RIGHT.rotated(player.rotation)
			b_l_inst.rotation = player.rotation
			player.bullet_node.add_child(b_l_inst)
			
		Global.WeaponType.LASER2:
			var b_l_insts = [BulletLaser.instance(), BulletLaser.instance()]
			b_l_insts[0].position = player.gun_left_pos.get_global_position()
			b_l_insts[1].position = player.gun_right_pos.get_global_position()
			for b in b_l_insts:
				b.direction = Vector2.RIGHT.rotated(player.rotation)
				b.rotation = player.rotation
				player.bullet_node.add_child(b)
			
		Global.WeaponType.LASER3:
			var b_l_insts = [
				BulletLaser.instance(),
				BulletLaser.instance(),
				BulletLaser.instance()]
			b_l_insts[0].position = player.gun_left_pos.get_global_position()
			b_l_insts[1].position = player.gun_front_pos.get_global_position()
			b_l_insts[2].position = player.gun_right_pos.get_global_position()
			for b in b_l_insts:
				b.direction = Vector2.RIGHT.rotated(player.rotation)
				b.rotation = player.rotation
				player.bullet_node.add_child(b)
	player.gun_sound_node.play()
	pass
