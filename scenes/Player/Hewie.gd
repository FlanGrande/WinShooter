extends KinematicBody2D

# HEWIE
signal give_key

enum State {
	WALKING,
	GRABBING,
	HARNESS_MODE
}

var current_state = State.WALKING

var alive = false

# Movement
const MAX_SPEED_WALKING = Vector2(460, 460)
const MAX_SPEED_GRABBING = Vector2(260, 260)
const MAX_SPEED_HARNESS_MODE = Vector2(200, 200)
const DEADZONE_SPEED = 80
const ACCELERATION = 24
const DECELERATION = 16
const BASE_SPEED_FACTOR = 0.8
var speed_factor = BASE_SPEED_FACTOR
var current_speed = Vector2(0, 0)
var current_max_speed = MAX_SPEED_WALKING
var move_input_is_pressed = [false, false] # Input on X, input on Y

# Camera
const CAMERA_MAX_RANGE = Vector2(30, 30) # Max distance from the character to the camera
var camera_position = Vector2(0, 0) # Current camera position
var aiming_vector = Vector2(0, 0) # Vector representing the direction the player is aiming to
var x_axis = Vector2(1, 0) # Vector for the axis used to calculate aiming angle (X axis, namely)

# Interactions
onready var Bernard = get_parent().get_node("Bernard")
var keys_at_reach = []
var is_one_key_being_grabbed = false
var grabbed_item_offset = Vector2(0, -8)
var can_give_key = false

func _ready():
	alive = true
	current_state = State.WALKING
	
	# Limit camera based on surrounding walls, for now.
	#$Camera2D.limit_left = get_parent().get_node("nd_outerWalls/spr_WestWall").position.x
	#$Camera2D.limit_right = get_parent().get_node("nd_outerWalls/spr_EastWall").position.x
	#$Camera2D.limit_top = get_parent().get_node("nd_outerWalls/spr_NorthWall").position.y
	#$Camera2D.limit_bottom = get_parent().get_node("nd_outerWalls/spr_SouthWall").position.y
	
	pass

func _process(delta):
	if alive:
		handle_input()
		update()
		camera_update()
		
		var motion = Vector2(speed_factor * current_speed)
		move_and_slide(motion)
		
		print("HEWIE STATE: ", current_state)
	
	pass

func handle_input():
	match current_state:
		# TO DO: Move towards controller input, as in analog movement.
		State.WALKING:
			current_max_speed = MAX_SPEED_WALKING
			handle_movement()
			
			if(keys_at_reach.size() > 0):
				if(Input.is_action_pressed("hewie_grab")):
					change_state(State.GRABBING)
		
		State.GRABBING:
			current_max_speed = MAX_SPEED_GRABBING
			handle_movement()
			
			if(keys_at_reach.size() > 0):
				var closest_key = keys_at_reach[0]
				var distance_to_closest_key = global_position.distance_to(closest_key.global_position)
				
				for key in keys_at_reach:
					var distance_to_this_key = global_position.distance_to(key.global_position)
					if(distance_to_this_key < distance_to_closest_key and not is_one_key_being_grabbed):
						closest_key = key
				
				closest_key.position = global_position + grabbed_item_offset
				is_one_key_being_grabbed = true
			
				if(Input.is_action_just_released("hewie_grab")):
					if(can_give_key):
						emit_signal("give_key", closest_key)
					
					is_one_key_being_grabbed = false
					change_state(State.WALKING)
		
		State.HARNESS_MODE:
			current_max_speed = MAX_SPEED_HARNESS_MODE  # This isn't really used.

func update():
	match current_state:
		State.WALKING:
			pass
		
		State.GRABBING:
			pass
			
		State.HARNESS_MODE:
			global_position = Bernard.global_position + Bernard.current_speed * 0.1
			#current_speed = Bernard.current_speed  # This isn't really used.
	
	if current_speed.y > current_max_speed.y:
		current_speed.y = current_max_speed.y
	elif current_speed.y < -current_max_speed.y:
		current_speed.y = -current_max_speed.y
	
	if current_speed.x > current_max_speed.x:
		current_speed.x = current_max_speed.x
	elif current_speed.x < -current_max_speed.x:
		current_speed.x = -current_max_speed.x

func handle_movement():
	move_input_is_pressed = [false, false]
			
	if(Input.is_action_pressed("hewie_move_left")):
		current_speed.x += -ACCELERATION
		move_input_is_pressed[0] = true
	
	if(Input.is_action_pressed("hewie_move_right")):
		current_speed.x += ACCELERATION
		move_input_is_pressed[0] = true
	
	if(Input.is_action_pressed("hewie_move_up")):
		current_speed.y += -ACCELERATION
		move_input_is_pressed[1] = true
	
	if(Input.is_action_pressed("hewie_move_down")):
		current_speed.y += ACCELERATION
		move_input_is_pressed[1] = true
	
	# No input on X
	if(not move_input_is_pressed[0]):
		current_speed.x -= sign(current_speed.x) * DECELERATION
		
		# Stay on place
		if abs(current_speed.x) < DEADZONE_SPEED:
			current_speed.x = 0
	
	# No input on Y
	if(not move_input_is_pressed[1]):
		current_speed.y -= sign(current_speed.y) * DECELERATION
		
		# Stay on place
		if abs(current_speed.y) < DEADZONE_SPEED:
			current_speed.y = 0

func change_state(new_state):
	current_state = new_state
	pass

# Change to follow Hewie
func camera_update():
	$Camera2D.global_position = global_position
#	aiming_vector = get_global_mouse_position() - global_position
#
#	camera_position.x = global_position.x + aiming_vector.x * CAMERA_MAX_RANGE.x/100
#	camera_position.y = global_position.y + aiming_vector.y * CAMERA_MAX_RANGE.y/100
#
#	$Camera2D.global_position = camera_position

# Should be melee attack
func shoot():
#	var one_bullet = bullet_scene.instance()
#	one_bullet.global_position = global_position
#	one_bullet.direction_angle = aiming_vector.angle()
#	get_parent().add_child(one_bullet)
	$Camera2D.shake()


func _on_Bernard_toggle_harness():
	if(current_state == State.HARNESS_MODE):
		speed_factor = BASE_SPEED_FACTOR
		change_state(State.WALKING)
	else:
		speed_factor = Bernard.speed_factor
		change_state(State.HARNESS_MODE)
	

func _on_Area2D_area_entered(area):
	if(area.get_parent().is_in_group("keys")):
		keys_at_reach.append(area.get_parent())
	
	if(area.get_parent().is_in_group("bernard")):
		can_give_key = true


func _on_Area2D_area_exited(area):
	if(area.get_parent().is_in_group("keys") and keys_at_reach.size() > 0):
		keys_at_reach.remove(keys_at_reach.find(area.get_parent()))
	
	if(area.get_parent().is_in_group("bernard")):
		can_give_key = false
