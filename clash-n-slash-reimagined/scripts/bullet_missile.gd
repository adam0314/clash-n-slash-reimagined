extends KinematicBody2D

var type = Weapons.BulletType.MISSILE
var direction : Vector2
var speed : float
var acceleration : float
var damage : float
var splash_radius : float
onready var blast_area : Area2D = $BlastArea
onready var blast_area_collision_shape : CollisionShape2D = $BlastArea/CollisionShape2D
onready var collision_node : CollisionShape2D = $CollisionShape2D
onready var sprite : Sprite = $Sprite
onready var sprite_explosion : AnimatedSprite = $BlastArea/SpriteExplosion
onready var audio_node : AudioStreamPlayer = $AudioStreamPlayer
onready var boom_audio = preload("res://sound/boom1.wav")
onready var particle_node = $Particles2D

var exploded : bool
var ttl : float
var time_after_boom : float

func _ready():
	exploded = false
	time_after_boom = 0.0
	ttl = 2.0
	sprite_explosion.visible = false
	set_blast_area()
	audio_node.play()
	pass

func set_blast_area():
	var shape : CircleShape2D = CircleShape2D.new()
	shape.set_radius(splash_radius)
	blast_area_collision_shape.set_shape(shape)
	var boom_sprite_scale = splash_radius * 0.75 / 36.0
	sprite_explosion.set_scale(Vector2(boom_sprite_scale, boom_sprite_scale))
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	if exploded:
		if time_after_boom >= ttl:
			queue_free()
		time_after_boom += delta
		return
		
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		if collision.collider.is_in_group("enemy"): #Direct hit lol
			collision.collider.deal_damage(damage)
		
		explode(collision)
	
	if global_position.length() > Global.max_distance_from_planet:
		queue_free()
	speed += acceleration * delta
	pass

func explode(collider_to_delete):
	exploded = true
	var splash_collisions = blast_area.get_overlapping_bodies()
	splash_collisions.erase(collider_to_delete)
	if splash_collisions.size() > 0: #Something is in radius of missile blast!
		for splash_col in splash_collisions:
			if splash_col.is_in_group("enemy"):
				var splash_distance = (splash_col.get_global_position() - blast_area.get_global_position()).length()
				var splash_damage = GameState.player_state.missiles.get_splash_damage(splash_distance)
				#print(splash_damage)
				splash_col.deal_damage(splash_damage)
	collision_node.disabled = true
	sprite.visible = false
	audio_node.stream = boom_audio
	audio_node.play()
	sprite_explosion.visible = true
	sprite_explosion.play("explode")
	particle_node.emitting = false
	
	#TODO: Add animation of explosion
	#TODO: Add animation (maybe particles) of thruster behind rocket
	
	pass
