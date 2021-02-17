extends KinematicBody2D

var alive : bool
var ttl : float # in seconds
var time_dead : float
var type
var max_speed : float
var hp : float

func init():
	alive = true
	time_dead = 0.0
	ttl = 2.0
	pass

