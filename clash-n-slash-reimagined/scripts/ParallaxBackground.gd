extends ParallaxBackground

export(float) var speed_x = 200.0 #dist x per second
export(float) var speed_y = 0.0 #dist y per second
onready var sprite_size = get_node("ParallaxLayer/bg").texture.get_size()

var scroll = Vector2.ZERO

func _ready():
	scroll = self.scroll_offset
	pass

func _process(delta):
	scroll.x += speed_x * delta
	scroll.y += speed_y * delta
	self.scroll_offset = scroll
	if (scroll.x > sprite_size.x * 3):
		scroll.x -= sprite_size.x * 3
	if (scroll.y > sprite_size.y * 3):
		scroll.y -= sprite_size.y * 3
	pass
