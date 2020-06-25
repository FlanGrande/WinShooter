extends "res://scenes/MovingEntity/MovingEntity.gd"

const RESET_MAX_SPEED = 320.0

var distance_from_crosswalk = 400.0
var distance_from_traffic_light = 200.0
var front_side_detection_distance = 30.0
var hue_adjustment = rand_range(0, 6)

var delta_correction = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Maybe just add an offset when the vehicle is created?
	
	# Movement variables, inherited
	max_speed = rand_range(280.0, 360.0)
	min_speed = 0.0
	speed = 0.0
	acceleration = rand_range(15.0, 20.0) * delta_correction
	deceleration = acceleration * 3
	
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.material.set_shader_param("hueAdjust", hue_adjustment)
	$RayCast2DFront.cast_to = Vector2(0, -front_side_detection_distance)
	$AnimationPlayer.playback_speed = 8 # make it depend on current speed
	$LightOccluder2D.occluder = $LightOccluder2D.occluder.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	handle_brakes()
	if(path_to_follow): choose_animation()

func handle_brakes() -> void:
	var crosswalks = get_tree().get_nodes_in_group("crosswalks")
	var traffic_lights = get_tree().get_nodes_in_group("traffic_lights")
	var is_close_to_crosswalk = false
	var raycast_collider = $RayCast2DFront.get_collider()
	
	if($RayCast2DFront.is_colliding()):
		if(raycast_collider.is_in_group("vehicles")):
			must_stop = raycast_collider.get_parent().get("must_stop")
			max_speed = min(raycast_collider.get_parent().get("max_speed"), RESET_MAX_SPEED)
		
		if(raycast_collider.is_in_group("crosswalks")):
			is_close_to_crosswalk = true
	else:
		must_stop = false
	
	if(is_close_to_crosswalk):
		if(Singleton.getClosestNodeInArray(global_position, traffic_lights).current_light == "green"):
			must_stop = false
		else:
			must_stop = true

func change_animation(new_animation) -> void:
	if($AnimationPlayer.current_animation != new_animation):
		$AnimationPlayer.play(new_animation)

func choose_animation() -> void:
	var Y_axis = Vector2(0, -1)
	var direction = path_to_follow[next_curve_index] - previous_path_segment
	var angle = -1 * direction.angle_to(Y_axis) * 180 / PI
	var animation_list = $AnimationPlayer.get_animation_list()
	var animation_index = int(int((angle + 180 + 11) / 22.5) % 16)
	#var rotation_correction = int(int(angle) % 22)
	rotation_degrees = angle
	
	if(ID == "VehicleSpawner9_0"):
		#print(direction)
		#print(str(angle) + " => " + str("animation_" + "%02d" % animation_index))
		pass
		
	
	#print(str(angle) + " => " + str("animation_" + "%02d" % animation_index))
	#$Sprite.global_rotation_degrees = 0 - int(angle) % 22
	
	change_animation("animation_" + "%02d" % animation_index)
	$Sprite.rotation_degrees = -angle
	$LightOccluder2D.rotation_degrees = -angle
	
	if(must_stop):
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play()

# Inherited from parent
#func move_along_path(distance : float) -> void:
#	if(distance_to_goal < 50.0):
#		previous_path_segment = path_to_follow[next_curve_index]
#		next_curve_index += 1
#
#		if(next_curve_index >= path_to_follow.size()):
#			next_curve_index = 0
#
#			if(not is_path_closed):
#				position = path_to_follow[0]
#				break
