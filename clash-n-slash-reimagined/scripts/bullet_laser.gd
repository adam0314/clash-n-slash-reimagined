extends KinematicBody2D

var direction : Vector2
var speed : float
var damage : float

func _ready():
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		if collision.collider.is_in_group("enemy"):
			collision.collider.deal_damage(damage)
			queue_free()
	
	if global_position.length() > Global.max_distance_from_planet:
		queue_free()
	pass
