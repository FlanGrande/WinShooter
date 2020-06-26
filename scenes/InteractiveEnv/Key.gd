extends Node2D

var is_grabbed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_grabbed = false

#func _process(delta):
#	$Sprite.texture.set_pause(is_grabbed)
#
#	if(is_grabbed):
#		$Sprite.texture.set_current_frame(0)

func use():
	get_parent().use()
