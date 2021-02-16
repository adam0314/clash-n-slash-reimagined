extends KinematicBody2D

var type = Weapons.BulletType.MISSILE
var direction : Vector2
var speed : float
var acceleration : float
onready var blast_area : Area2D = $BlastArea

func _ready():
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		if collision.collider.is_in_group("enemy"): #Direct hit lol
			collision.collider.register_hit(type)
		
		var splash_collisions = blast_area.get_overlapping_bodies()
		if splash_collisions.size() > 0: #Something is in radius of missile blast!
			for splash_col in splash_collisions:
				if splash_col.is_in_group("enemy"):
					var splash_distance = (splash_col.get_global_position() - self.get_global_position()).length()
					splash_col.register_hit(type, splash_distance)
		queue_free()
	
	if global_position.length() > Global.max_distance_from_planet:
		queue_free()
	speed += acceleration * delta
	pass
