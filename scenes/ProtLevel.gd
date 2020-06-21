extends Node2D

onready var nav_2d : Navigation2D = $Navigation/Navigation2D
#onready var end_position_2d : Position2D = $Navigation/EndPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.root_scene = self
	$WorldEnvironment/Light2D.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(OS.get_static_memory_peak_usage())
	pass

func get_a_path(start_position : Vector2, end_position : Vector2):
	var new_path : = nav_2d.get_simple_path(start_position, end_position)
	return new_path
