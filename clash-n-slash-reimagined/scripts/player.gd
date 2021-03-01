extends KinematicBody2D

export(float) var radius_from_planet = 100.0
export(float) var angle_to_mouse_interp = 0.2
export(float) var angle_rotation_interp = 0.2

var planet_position
onready var planet_node = get_parent().get_node("planet")
onready var gun_front_pos = $GunFrontPos2D
onready var gun_left_pos = $GunLeftPos2D
onready var gun_right_pos = $GunRightPos2D
onready var bullet_node = get_parent().get_node("bullets")
onready var gun_sound_node = $GunSound

var state = GameState.player_state

const ShootManager = preload("res://scripts/shoot_manager.gd")
var shoot_manager

func _ready():
	planet_position = planet_node.position
	shoot_manager = ShootManager.new()
	shoot_manager.init(self)
	pass

#func _process(delta):
#	pass

func _physics_process(delta):
	var cursor_pos = planet_node.get_local_mouse_position()
	var current_pos_from_planet = self.global_position - planet_node.global_position
	
	### START MOVEMENT
	
	# Move ship to cursor pos
	
	var angle = current_pos_from_planet.angle_to(cursor_pos)
	var angle_lerp = lerp(0.0, angle, angle_to_mouse_interp) * min(delta * 20.0, 1.0)
	
	self.position = planet_position + current_pos_from_planet.rotated(angle_lerp).normalized() * radius_from_planet
	
	# Rotate ship to cursor
	
	var cursor_pos_local = get_global_mouse_position() - self.global_position
	#var angle_ship = Vector2.UP.angle_to(cursor_pos_local) - self.rotation
	#var angle_ship_lerp = lerp(0.0, angle_ship, angle_rotation_interp)
	
	#print(angle_ship_lerp)
	
	#self.look_at(cursor_pos_local)
	
	#var angle_ship = cursor_pos_local.angle() - self.rotation + PI/2
	#var angle_ship_lerp = lerp(0.0, angle_ship, angle_rotation_interp)
	
	self.rotation = cursor_pos_local.angle()
	
	### END MOVEMENT
	
	### START SHOOT
	if Input.is_action_pressed("shoot"):
		shoot_manager.shoot()
	if Input.is_action_just_pressed("launch_missile"):
		shoot_manager.launch_missile()
	if Input.is_action_just_pressed("key_r"):
		state.current_weapon.reload()
	if Input.is_action_just_pressed("ui_down"):
		GameState.lose()
	
	### END SHOOT
	
	pass
