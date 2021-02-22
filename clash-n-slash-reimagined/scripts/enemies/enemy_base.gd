extends KinematicBody2D

var alive : bool
var ttl : float # in seconds
var time_dead : float
var type
var max_speed : float
var hp : float
var sprite : Sprite
var flashred_bool : bool
var flashred_time : float
var flashred_time_elapsed : float

func init():
	alive = true
	time_dead = 0.0
	ttl = 2.0
	flashred_time = 0.4
	pass
	
func deal_damage(dmg):
	hp -= dmg
	flash_red()
	pass

func flash_red():
	flashred_bool = true
	flashred_time_elapsed = 0.0
	pass

func _process(delta):
	if flashred_bool:
		var tint = range_lerp(flashred_time_elapsed, 0.0, flashred_time, 0.0, 1.0)
		var color = Color(1,tint,tint,1)
		sprite.set_self_modulate(color)
		flashred_time_elapsed += delta
		if flashred_time_elapsed >= flashred_time:
			flashred_bool = false
	pass
