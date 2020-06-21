extends Node2D

onready var world = get_parent().get_parent()
var max_speed = rand_range(280.0, 360.0)
var min_speed = 0.0
var initial_position : Vector2
var goal_position : Vector2
var deviation_from_goal : float
var speed : = 0.0
var acceleration : = rand_range(12.0, 20.0)
var time_taken_to_get_to_path : = 10.0 # 10 seconds?
var path : = PoolVector2Array() setget set_path
var must_stop : = false
var distance_from_crosswalk = 400.0
var distance_from_traffic_light = 200.0
var front_side_detection_distance = 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = global_position
	$RayCast2DFront.cast_to = Vector2(0, -front_side_detection_distance)
	deviation_from_goal = rand_range(-28.0, 28.0)
	goal_position.x += deviation_from_goal
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
	
	#if(goal_position != null):
	path = world.get_a_path(global_position, goal_position)
	
	handle_brakes()
	move_along_path(move_distance)
	#if not must_stop:
	#print(global_position)

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
			pass#break
		
		if(distance_to_goal < 100.0):
			position = initial_position
			max_speed = rand_range(280.0, 360.0)
			#queue_free() # This is a provisional way. We can probably rearrange vehicles, instead of deleting and creating, which seems expensive.
		
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

