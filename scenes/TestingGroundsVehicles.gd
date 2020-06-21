extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.root_scene = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_a_path(start_position : Vector2, end_position : Vector2):
	var new_path : = nav_2d.get_simple_path(start_position, end_position)
	return new_path
