extends Node

var BulletLaser
var player
var current_bullet
var timers = {}
var can_shoot = {}

func init(player_script):
	player = player_script
	BulletLaser = preload("res://scenes/bullet_laser.tscn")
	current_bullet = Global.BulletType.LASER
	for bullet in Global.BulletType.values():
		can_shoot[bullet] = true
	init_timers()
	pass

func init_timers():
	for bullet in Global.BulletType.values():
		timers[bullet] = Timer.new();
		timers[bullet].connect("timeout", self, "_on_timer_shoot", [bullet])
		timers[bullet].wait_time = 1.0 / Global.bullet_firerate[bullet]
		player.bullet_node.add_child(timers[bullet])
	pass

func _on_timer_shoot(bullet_type):
	can_shoot[bullet_type] = true
	timers[bullet_type].stop()
	pass

#func _process(delta):
#	pass

func shoot():
	if can_shoot[current_bullet]:
		instance_bullet()
		timers[current_bullet].start()
		can_shoot[current_bullet] = false
	pass

func instance_bullet():
	match current_bullet:
		Global.BulletType.LASER:
			var bullet_laser_instance = BulletLaser.instance()
			bullet_laser_instance.position = player.gun_front_pos.get_global_position()
			bullet_laser_instance.direction = Vector2.RIGHT.rotated(player.rotation)
			bullet_laser_instance.rotation = player.rotation
			player.bullet_node.add_child(bullet_laser_instance)
	pass
