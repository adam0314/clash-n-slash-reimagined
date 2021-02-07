extends KinematicBody2D

var direction : Vector2
var speed = Global.bullet_speed[Global.BulletType.LASER]

func _ready():
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		if collision.collider.is_in_group("enemy"):
			collision.collider.register_hit(Global.BulletType.LASER)
			queue_free()
	
	if global_position.length() > Global.max_distance_from_planet:
		queue_free()
	pass
