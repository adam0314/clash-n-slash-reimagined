extends KinematicBody2D

var speed = Global.enemy_speed[Global.EnemyType.SMALL]

func _ready():
	pass

func _physics_process(delta):
	
	# Set movement of enemy as wavy towards planet
	
	
	var direction_to_planet = -global_position.normalized();
	
	# Deviate
	
	direction_to_planet = direction_to_planet.rotated(rand_range(-PI*2/90.0, PI*2/90.0))
	
	set_rotation(direction_to_planet.angle())
	move_and_collide(direction_to_planet * speed * delta)
	pass

func register_hit(bullet_type):
	match bullet_type:
		Global.BulletType.LASER:
			queue_free()
	pass
