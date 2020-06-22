extends Node2D

onready var world = Singleton.root_scene

# Movement variables
var max_speed = rand_range(280.0, 360.0)
var min_speed = 0.0
var speed : = 0.0
var acceleration : = rand_range(12.0, 20.0)
var must_stop : = false

# Path variables
var time_taken_to_get_to_path : = 10.0 # 10 seconds?
var path : = PoolVector2Array() setget set_path # Path to current target position.
var curve2D : PoolVector2Array # Whole path the entity will follow.
var next_curve_index = 0

var entity

# TO DO: Mostly everything. Associate this object to its entity.

# Called when the node enters the scene tree for the first time.
func _ready():
	#entity = get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if(must_stop):
		speed -= acceleration
		speed = max(min_speed, speed)
	else:
		speed += acceleration
		speed = min(max_speed, speed)
	
	
	var move_distance : = speed * delta
	
	path = world.get_a_path(global_position, get_next_path_point())
	
	handle_brakes()
	move_along_path(move_distance)

func handle_brakes():
	var crosswalks = get_tree().get_nodes_in_group("crosswalks")
	var traffic_lights = get_tree().get_nodes_in_group("traffic_lights")
	var is_close_to_crosswalk = false
	var raycast_collider = $RayCast2DFront.get_collider()
	
	if($RayCast2DFront.is_colliding()):
		if(raycast_collider.is_in_group("vehicles")):
			must_stop = raycast_collider.get_parent().get("must_stop")
			max_speed = raycast_collider.get_parent().get("max_speed") - 20.0
		
		if(raycast_collider.is_in_group("crosswalks")):
			is_close_to_crosswalk = true
	
	if(is_close_to_crosswalk):
		if(Singleton.getClosestNodeInArray(global_position, traffic_lights).current_light == "green"):
			must_stop = false
		else:
			must_stop = true

func move_along_path(distance : float) -> void:
	var start_point : = position
	for i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		var distance_to_goal : = start_point.distance_to(path[path.size() - 1])
		if distance <= distance_to_next and distance >= 0.0:
			if(distance_to_next > 40.0):
				position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			
			break
		elif distance < 0.0:
			#position = path[0]
			#set_process(false)
			pass
		
		if(distance_to_goal < 50.0):
			next_curve_index += 1
			
			if(next_curve_index >= curve2D.size()):
				next_curve_index = 0
		
		#print(position)
		
		#comment/uncomment to compare
		#distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value : PoolVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	set_process(true)

func get_next_path_point():
	var next_point = curve2D[next_curve_index]
	return next_point
