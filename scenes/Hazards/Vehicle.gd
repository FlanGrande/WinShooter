extends "res://scenes/MovingEntity/MovingEntity.gd"

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
	acceleration = rand_range(26.0, 30.0) * delta_correction
	deceleration = acceleration * 2
	$AnimationPlayer.playback_speed = 8 # make it depend on current speed
	
	$RayCast2DFront.cast_to = Vector2(0, -front_side_detection_distance)
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.material.set_shader_param("hueAdjust", hue_adjustment)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	handle_brakes()
	choose_animation()

func handle_brakes():
	var crosswalks = get_tree().get_nodes_in_group("crosswalks")
	var traffic_lights = get_tree().get_nodes_in_group("traffic_lights")
	var is_close_to_crosswalk = false
	var raycast_collider = $RayCast2DFront.get_collider()
	
	if($RayCast2DFront.is_colliding()):
		if(raycast_collider.is_in_group("vehicles")):
			must_stop = raycast_collider.get_parent().get("must_stop")
			max_speed = raycast_collider.get_parent().get("max_speed")
		
		if(raycast_collider.is_in_group("crosswalks")):
			is_close_to_crosswalk = true
	else:
		must_stop = false
	
	if(is_close_to_crosswalk):
		if(Singleton.getClosestNodeInArray(global_position, traffic_lights).current_light == "green"):
			must_stop = false
		else:
			must_stop = true

func change_animation(new_animation):
	if($AnimationPlayer.current_animation != new_animation):
		$AnimationPlayer.play(new_animation)

func choose_animation():
	var Y_axis = Vector2(0, -1)
	var direction = path_to_follow[next_curve_index] - previous_path_segment
	var angle = -1 * direction.angle_to(Y_axis) * 180 / PI
	var animation_list = $AnimationPlayer.get_animation_list()
	var animation_index = int(int((angle + 180 + 11) / 22.5) % 16)
	#var rotation_correction = int(int(angle) % 22)
	#rotation_degrees = angle + 180 + 11
	
	#if(ID == "VehicleSpawner9_1"):
	#	print(direction)
	#	print(str(angle) + " => " + str("animation_" + "%02d" % animation_index))
	
	#print(str(angle) + " => " + str("animation_" + "%02d" % animation_index))
	#$Sprite.global_rotation_degrees = 0 - int(angle) % 22
	
	change_animation("animation_" + "%02d" % animation_index)
	
	if(must_stop):
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play()
