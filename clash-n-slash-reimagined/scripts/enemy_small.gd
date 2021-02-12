extends KinematicBody2D

var enemy_type = Global.EnemyType.SMALL

var speed = Global.enemy_speed[enemy_type]

const wander_radius = 2.0
const wander_distance = 15.0
const wander_jitter = 0.02

var wander_target : Vector2
var front

var alive = true
var time_to_delete_after_kill = 1.0 # in seconds
var dead_time = 0.0

onready var sprite : Sprite = $Sprite
onready var collision_shape : CollisionShape2D = $CollisionShape2D
onready var oof_player : AudioStreamPlayer = $OofPlayer

func _ready():
	var vector_to_planet = -global_position.normalized();
	set_rotation(vector_to_planet.angle())
	front = vector_to_planet
	wander_target = Vector2.RIGHT
	pass

func _physics_process(delta):
	
	if not alive:
		dead_time += delta
		if dead_time >= time_to_delete_after_kill:
			queue_free()
		return
		
	# Wander
	
	wander_target += Vector2(rand_range(-1.0, 1.0) * wander_jitter, rand_range(-1.0, 1.0) * wander_jitter)
	wander_target = wander_target.normalized()*wander_radius
	var target_local = (wander_target + Vector2(wander_distance, 0.0)).normalized()
	var dir_wander = target_local.rotated(get_rotation())
	
	# Arrive 
	
	var dir_planet = -global_position.normalized()
	
	# Combine based on how close to planet enemies are
	
	var multiplier = clamp((global_position.length() / Global.max_distance_from_planet), 0.0, 1.0)
	multiplier = range_lerp(multiplier, 0.0, 1.0, 0.05, 0.01)
	var dir_final = lerp(dir_wander, dir_planet, multiplier).normalized()
	
	#print(multiplier)
	
	# old
	
	#var direction_to_planet = -global_position.normalized()
	#set_rotation(direction_to_planet.angle())
	#direction_to_planet = -global_position.normalized()
	#move_and_collide(direction_to_planet * speed * delta)
	
	# end old
	
	set_rotation(dir_final.angle())
	move_and_collide(dir_final * speed * delta)
	pass

func register_hit(bullet_type):
	match bullet_type:
		Global.BulletType.LASER:
			die()
	pass

func die():
	get_parent().handle_enemy_death(enemy_type)
	alive = false
	sprite.visible = false
	collision_shape.disabled = true
	oof_player.pitch_scale = rand_range(0.9, 1.1)
	oof_player.play(0.4)
	# TODO: Add animation of enemy getting destroyed
	pass
