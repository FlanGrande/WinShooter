extends Node2D

var world
var ID : = ""

# Movement variables
var max_speed : = rand_range(100.0, 100.0)
var min_speed : = 0.0
var speed : = 0.0
var acceleration : = rand_range(12.0, 20.0)
var deceleration : = acceleration * 2
var must_stop : = false

# Path variables
var path_to_follow # Whole path the entity will follow.
var next_path_segment : = PoolVector2Array() setget set_path # Path to current target position.
var previous_path_segment : Vector2 # Path to current target position.
var time_taken_to_get_to_path : = 10.0 # 10 seconds?
var next_curve_index : = 0
export var is_path_closed : = false # If path hasn't been closed, the vehicle will be reset to the beginning of the path.

#var entity : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#entity = get_children()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	world = Singleton.root_scene
	
	if(must_stop):
		speed -= deceleration * delta
		speed = max(min_speed, speed)
	else:
		speed += acceleration * delta
		speed = min(max_speed, speed)
	
	var move_distance : = speed * delta
	
	# Change name of next_path_segment to path_to_next_segment
	# Get the previous path vertex
	
	next_path_segment = world.get_a_path(position, get_next_path_point())
	
	move_along_path(move_distance)
	
	#if(must_stop):
	#	print("Hey I may be stuck")

func move_along_path(distance : float) -> void:
	var start_point : = position
	
	for i in range(next_path_segment.size()):
		var distance_to_next : = start_point.distance_to(next_path_segment[0])
		var distance_to_goal : = start_point.distance_to(next_path_segment[next_path_segment.size() - 1])
		if distance <= distance_to_next and distance >= 0.0:
			if(distance_to_next > 40.0):
				position = start_point.linear_interpolate(next_path_segment[0], distance / distance_to_next)
			
			break
		elif distance < 0.0:
			#position = next_path_segment[0]
			#set_process(false)
			pass
		
		if(distance_to_goal < 50.0):
			previous_path_segment = path_to_follow[next_curve_index]
			next_curve_index += 1
			
			if(next_curve_index >= path_to_follow.size()):
				next_curve_index = 0
				
				if(not is_path_closed):
					position = path_to_follow[0]
					break
		
		#print(position)
		
		#comment/uncomment to compare
		#distance -= distance_to_next
		start_point = next_path_segment[0]
		next_path_segment.remove(0)

func set_path(value : PoolVector2Array) -> void:
	next_path_segment = value
	if value.size() == 0:
		return
	set_process(true)

func get_next_path_point():
	var next_point = path_to_follow[next_curve_index]
	return next_point
