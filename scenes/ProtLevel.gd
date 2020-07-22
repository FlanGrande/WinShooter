extends Node2D

onready var nav_2d : Navigation2D = $Navigation/Navigation2D
#onready var end_position_2d : Position2D = $Navigation/EndPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.root_scene = self
	$CanvasModulate.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(OS.get_static_memory_peak_usage())
	pass

func get_a_path(start_position : Vector2, end_position : Vector2):
	var new_path : = nav_2d.get_simple_path(start_position, end_position)
	return new_path

func _on_Area2D_body_entered(body):
	if body.is_in_group("hewie"):
		$TileMaps/Roof.visible = false
		$TileMaps/RoofFront.visible = false
		body.get_node("LightForEntities").shadow_item_cull_mask = 3 # 3 means shadows are generated for walls.
		body.get_node("LightForShadows").shadow_item_cull_mask = 3
		print("Enter")

func _on_Area2D_body_exited(body):
	if body.is_in_group("hewie"):
		$TileMaps/Roof.visible = true
		$TileMaps/RoofFront.visible = true
		body.get_node("LightForEntities").shadow_item_cull_mask = 3 # 2 means shadows are NOT generated for walls.
		body.get_node("LightForShadows").shadow_item_cull_mask = 3
		print("Exit")
