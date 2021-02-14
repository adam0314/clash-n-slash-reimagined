extends Node

var player

func init(player_script):
	player = player_script
	player.gun_sound_node.stream = player.state.current_weapon.shot_sound
	pass

#func _process(delta):
#	pass

# unused yet
#func change_weapon(to_weapon):
#	player.gun_sound_node.stream = Weapons.weapon_sounds[to_weapon]
#	pass

func shoot():
	if player.state.current_weapon.shoot_if_possible():
		instance_bullets()
	pass

func instance_bullets():
	match player.state.current_weapon.type:
		Weapons.WeaponType.LASER:
			match player.state.current_weapon.bullets_per_shot:
				1:
					var b_l_inst = player.state.current_weapon.bullet_node.instance()
					b_l_inst.speed = player.state.current_weapon.bullet_speed
					b_l_inst.position = player.gun_front_pos.get_global_position()
					b_l_inst.direction = Vector2.RIGHT.rotated(player.rotation)
					b_l_inst.rotation = player.rotation
					player.bullet_node.add_child(b_l_inst)
				2:
					var b_l_insts = [player.state.current_weapon.bullet_node.instance(),\
									player.state.current_weapon.bullet_node.instance()]
					b_l_insts[0].position = player.gun_left_pos.get_global_position()
					b_l_insts[1].position = player.gun_right_pos.get_global_position()
					for b in b_l_insts:
						b.speed = player.state.current_weapon.bullet_speed
						b.direction = Vector2.RIGHT.rotated(player.rotation)
						b.rotation = player.rotation
						player.bullet_node.add_child(b)
				3:
					var b_l_insts = [player.state.current_weapon.bullet_node.instance(),\
									player.state.current_weapon.bullet_node.instance(),\
									player.state.current_weapon.bullet_node.instance()]
					b_l_insts[0].position = player.gun_left_pos.get_global_position()
					b_l_insts[1].position = player.gun_right_pos.get_global_position()
					b_l_insts[2].position = player.gun_front_pos.get_global_position()
					for b in b_l_insts:
						b.speed = player.state.current_weapon.bullet_speed
						b.direction = Vector2.RIGHT.rotated(player.rotation)
						b.rotation = player.rotation
						player.bullet_node.add_child(b)
						
	player.gun_sound_node.play()
	pass
