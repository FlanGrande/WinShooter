extends "res://scenes/Systems/MovementSystem/movement_system.gd"

# HEWIE
signal give_key

enum State {
	IDLE,
	WALKING,
	GRABBING,
	HARNESS_MODE
}

var current_state = State.WALKING

var alive = false

# Movement
#const MAX_SPEED_WALKING = Vector2(300, 300)
const MAX_SPEED_WALKING = Vector2(200, 200)
const MAX_SPEED_GRABBING = Vector2(160, 160)
const MAX_SPEED_HARNESS_MODE = Vector2(200, 200)
const DEADZONE_SPEED = 30
const ACCELERATION = 12
const DECELERATION = 10
const BASE_SPEED_FACTOR = 0.8
const DEAD_ZONE = 0.2
var speed_factor = BASE_SPEED_FACTOR
var current_speed = Vector2(0, 0)
var current_max_speed = MAX_SPEED_WALKING
var move_input_is_pressed = [false, false] # Input on X, input on Y

# Alternative Movement
var velocity = Vector2()
var alt_speed = 300

# Camera
const CAMERA_MAX_RANGE = Vector2(30, 30) # Max distance from the character to the camera
var camera_position = Vector2(0, 0) # Current camera position
var aiming_vector = Vector2(0, 0) # Vector representing the direction the player is aiming to

# Animation
var current_animation = "idle"
var animation_index = 0
var speed_angle_to_X_axis = 0

# Interactions
onready var Bernard = get_parent().get_node("Bernard")
var keys_at_reach = []
var is_one_key_being_grabbed = false
var grabbed_item_offset = Vector2(0, -8)
var can_give_key = false
var grabbed_item = null
var is_pressing_button = false
var button_being_pressed = null

func _ready():
	alive = true
	current_state = State.IDLE
	
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
		#camera_update()
		
		#print(speed)
		#print(direction_angle_in_radians)
		if(is_moving): 
			choose_animation()
			move_and_slide(Vector2(speed, 0).rotated(direction_angle_in_radians))
		else: 
			change_animation("00_idle")
		
#		var movement_speed = sqrt(current_speed.x*current_speed.x + current_speed.y*current_speed.y)
#		var move : = Vector2(current_speed.x, current_speed.y)
#		move = move.normalized() * movement_speed
#		var dir = move.angle_to(x_axis)
#		print("MOVE: " + str(move))
#		velocity = sqrt(velocity.x*velocity.x + velocity.y*velocity.y)
#		var clamped_velocity = min(velocity, current_max_speed.x)
#		var final_move = dir*clamped_velocity
#
#		var motion = Vector2(speed_factor * final_move)
#		move_and_slide(velocity)
		
		#var animation_speed = movement_speed / current_max_speed.x
		#$AnimationPlayer.play(current_animation, -1, animation_speed * speed_factor)
		
		#print("HEWIE STATE: ", current_state)
	
	pass

func handle_input():
	match current_state:
		State.IDLE:
			#current_max_speed = Vector2(0, 0)
			#handle_movement()
			movement_process()
			
			if(is_moving):
				change_state(State.WALKING)
			
		State.WALKING:
			current_max_speed = MAX_SPEED_WALKING
			#handle_movement()
			movement_process()
			
			if(keys_at_reach.size() > 0):
				if(Input.is_action_pressed("hewie_grab")):
					change_state(State.GRABBING)
			
			if(not is_moving):
				change_state(State.IDLE)
		
		State.GRABBING:
			current_max_speed = MAX_SPEED_GRABBING
			#handle_movement()
			movement_process()
			
			if(keys_at_reach.size() > 0):
				var closest_key = keys_at_reach[0]
				var distance_to_closest_key = global_position.distance_to(closest_key.global_position)
				
				for key in keys_at_reach:
					var distance_to_this_key = global_position.distance_to(key.global_position)
					if(distance_to_this_key < distance_to_closest_key and not is_one_key_being_grabbed):
						closest_key = key
				
				if(Bernard.grabbed_key != closest_key):
					closest_key.global_position = global_position + grabbed_item_offset
					is_one_key_being_grabbed = true
					grabbed_item = closest_key
			
				if(Input.is_action_just_released("hewie_grab")):
					if(can_give_key):
						emit_signal("give_key", closest_key)
					
					is_one_key_being_grabbed = false
					grabbed_item = null
					change_state(State.WALKING)
		
		State.HARNESS_MODE:
			current_max_speed = Bernard.MAX_SPEED_HARNESS_MODE  # This isn't really used.
			movement_process()
			
			#if(not Bernard.move_input_is_pressed[0] and not Bernard.move_input_is_pressed[1]):
			#	change_state(State.IDLE)

func update():
	match current_state:
		State.IDLE:
			pass
		
		State.WALKING:
			pass
		
		State.GRABBING:
			pass
		
		State.HARNESS_MODE:
			speed = Bernard.speed # This is used to determine animation
			direction_angle_in_radians = Bernard.direction_angle_in_radians # This is used to determine animation
			global_position = Bernard.global_position + Vector2(Bernard.speed, 0).rotated(Bernard.direction_angle_in_radians) * 0.1
			is_moving = Bernard.is_moving
			choose_animation()
			#global_position.x += 10 # This is good for now
			#global_position.y -= 10 # This is good for now
			

func movement_process():
	var joy_input = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
	is_moving = false
	direction = Vector2(0, 0)
	#print(joy_input)
	
	if(Input.is_action_pressed("hewie_key_up")):
		direction.y -= 1
		speed = max_speed
		is_moving = true
	elif(Input.is_action_pressed("hewie_key_down")):
		direction.y += 1
		speed = max_speed
		is_moving = true

	if(Input.is_action_pressed("hewie_key_left")):
		direction.x -= 1
		speed = max_speed
		is_moving = true
	elif(Input.is_action_pressed("hewie_key_right")):
		direction.x += 1
		speed = max_speed
		is_moving = true
	
	if(Input.is_action_pressed("hewie_move_up") or Input.is_action_pressed("hewie_move_down")):
		direction.y *= abs(joy_input.y)
	
	if(Input.is_action_pressed("hewie_move_left") or Input.is_action_pressed("hewie_move_right")):
		direction.x *= abs(joy_input.x)
	
	direction_angle_in_radians = x_axis.angle_to(direction)
	
	if(Input.is_action_pressed("hewie_move_up") or Input.is_action_pressed("hewie_move_down") or Input.is_action_pressed("hewie_move_left") or Input.is_action_pressed("hewie_move_right")):
		speed *= max(abs(joy_input.x), abs(joy_input.y)) # This allows the player to gradually move characters depending on joystick position.

func change_state(new_state):
	current_state = new_state
	pass

func change_animation(new_animation):
	if($AnimationPlayer.current_animation != new_animation):
		$AnimationPlayer.play(new_animation)
		current_animation = new_animation

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

func choose_animation() -> void:
	var X_axis = Vector2(-1, 0)
	var direction_angle_in_degrees = direction_angle_in_radians * 180 / PI
	var animation_index = int(int((direction_angle_in_degrees + 360 + 8) / 22) % 16)
	#print(animation_index)
	#print(str(angle) + " => " + str("animation_" + "%02d" % animation_index))
	
	var current_animation_position = $AnimationPlayer.get_current_animation_position()
	Singleton.change_animation($AnimationPlayer, "animation_" + "%02d" % animation_index)
	$AnimationPlayer.seek(current_animation_position)

#func choose_animation() -> void:
#	var Y_axis = Vector2(0, -1)
#	var direction_angle_in_degrees = direction_angle_in_radians * 180 / PI
#	#var animation_list = $AnimationPlayer.get_animation_list()
#	var animation_index = int(int((angle + 270 + 11) / 22.5) % 16)
#	#var rotation_correction = int(int(angle) % 22)
#	rotation_degrees = angle
#
#	#print(str(angle) + " => " + str("animation_" + "%02d" % animation_index))
#	#$Sprite.global_rotation_degrees = 0 - int(angle) % 22
#
#	var current_animation_position = $AnimationPlayer.get_current_animation_position()
#
#	if(current_speed == Vector2(0, 0)):
#		change_animation("00_idle")
#	else:
#		change_animation("animation_" + "%02d" % animation_index)
#
#	$AnimationPlayer.seek(current_animation_position)
#	#$AnimationPlayer.current_animation_position = current_animation_position
#	$Sprite.rotation_degrees = -angle
#	$SprShadow.rotation_degrees = -angle

func _on_Bernard_toggle_harness():
	if(current_state == State.HARNESS_MODE):
		change_state(State.WALKING)
	else:
		change_state(State.HARNESS_MODE)

func _on_Area2D_area_entered(area):
	if(area.get_parent().is_in_group("keys")):
		keys_at_reach.append(area.get_parent())
	
	if(area.get_parent().is_in_group("bernard")):
		can_give_key = true
	
	if(area.get_parent().is_in_group("dog_buttons")):
		is_pressing_button = true
		button_being_pressed = area.get_parent()
		
		if(not Bernard.is_pressing_button or Bernard.button_being_pressed.mechanism_id != button_being_pressed.mechanism_id):
			area.get_parent().use()

func _on_Area2D_area_exited(area):
	if(area.get_parent().is_in_group("keys") and keys_at_reach.size() > 0):
		keys_at_reach.remove(keys_at_reach.find(area.get_parent()))
	
	if(area.get_parent().is_in_group("bernard")):
		can_give_key = false
	
	if(area.get_parent().is_in_group("dog_buttons")):
		if(not Bernard.is_pressing_button or Bernard.button_being_pressed.mechanism_id != button_being_pressed.mechanism_id):
			area.get_parent().use()
		
		is_pressing_button = false
		button_being_pressed = null
