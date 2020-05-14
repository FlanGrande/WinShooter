extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var array = [1, 0, 1, 
1, 1, 1,
0, 0, 1]

var width = 16
var height = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	var img = Image.new()
	
	img.create(width, height, false, Image.FORMAT_RGBA8)
	img.lock()
	
	for x in width:
		for y in height:
			img.set_pixel(x, y, Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)));
	
	var img_txt = ImageTexture.new()
	img_txt.create_from_image(img)
	
	var sprite = Sprite.new()
	sprite.texture = img_txt
	sprite.position = Vector2(100, 100)
	add_child(sprite)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
