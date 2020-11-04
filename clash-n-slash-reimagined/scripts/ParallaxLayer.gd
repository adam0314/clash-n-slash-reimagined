extends ParallaxLayer

export(float) var speed = 100.0 #dist per second

func _ready():
	pass

func _process(delta):
	self.motion_offset.x += -speed * delta * 10.0
	pass
