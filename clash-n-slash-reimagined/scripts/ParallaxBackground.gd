extends ParallaxBackground

export(float) var speed = 200.0 #dist per second
const sprite_size = 720
var scroll_x = 0.0

func _ready():
	scroll_x = self.scroll_offset.x
	pass

func _process(delta):
	scroll_x += speed * delta
	self.scroll_offset.x = scroll_x
	if (scroll_x > sprite_size * 3):
		scroll_x -= sprite_size * 3
	#print(self.scroll_offset.x)
	pass
