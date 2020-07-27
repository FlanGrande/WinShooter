extends "res://scenes/Systems/MovementSystem/movement_system.gd"

# TO DO: Bernards blocks doors with his body to stop them from closing.

# BERNARD
signal toggle_harness

var bullet_scene = preload("res://scenes/Bullets/Bullet.tscn")

enum State {
	WALKING,
	GRABBING,
	HARNESS_MODE
}

var current_state = State.WALKING

var alive = false

# Movement
#const MAX_SPEED_WALKING = Vector2(460, 460)
const MAX_SPEED_WALKING = Vector2(300, 300)
const MAX_SPEED_GRABBING = Vector2(260, 260)
const MAX_SPEED_HARNESS_MODE = Vector2(200, 200)
const DEADZONE_SPEED = 80
const ACCELERATION = 40
const DECELERATION = 30
const DEAD_ZONE = 0.2
var speed_factor = 0.3
var current_speed = Vector2(0, 0)
var current_max_speed = MAX_SPEED_WALKING
var move_input_is_pressed = [false, false] # Input on X, input on Y

# Camera
const CAMERA_MAX_RANGE = Vector2(30, 30) # Max distance from the character to the camera
var camera_position = Vector2(0, 0) # Current camera position
var aiming_vector = Vector2(0, 0) # Vector representing the direction the player is aiming to

# Interactions
const IS_HEWIE_NEARBY_RANGE = 60
onready var Hewie = get_parent().get_node("Hewie")
var grabbed_key = null
var grabbed_item_offset = Vector2(0, 0)
var is_pressing_button = false
var button_being_pressed = null

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
		#camera_update()
		
		#var motion = Vector2(speed_factor * current_speed)
		#move_and_slide(motion)
		if(is_moving): move_and_slide(Vector2(speed, 0).rotated(direction_angle_in_radians))
		choose_animation()
		
		#print("BERNARD STATE: ", current_state)
	
	pass

func handle_input():
	match current_state:
		# TO DO: Move towards controller input, as in analog movement.
		State.WALKING:
			current_max_speed = MAX_SPEED_WALKING
			#handle_movement()
			movement_process()
			
			#if(is_Hewie_nearby() and Input.is_action_just_released("toggle_harness")):
			if(is_Hewie_nearby() and Input.is_action_just_released("bernard_interact")):
				emit_signal("toggle_harness")
				change_state(State.HARNESS_MODE)
		
		State.GRABBING:
			current_max_speed = MAX_SPEED_GRABBING
			#handle_movement()
			movement_process()
			
			grabbed_key.global_position = global_position + grabbed_item_offset
			
			#if(Input.is_action_just_released("bernard_drop")):
			if(Input.is_action_just_released("bernard_interact")):
				grabbed_key = null
				change_state(State.WALKING)
		
		State.HARNESS_MODE:
			current_max_speed = MAX_SPEED_HARNESS_MODE
			#handle_movement()
			movement_process()
			
			#if(Input.is_action_just_released("toggle_harness")):
			if(Input.is_action_just_released("bernard_interact")):
				emit_signal("toggle_harness")
				change_state(State.WALKING)

func update():
	match current_state:
		State.WALKING:
			pass
		
		State.GRABBING:
			pass
		
		State.HARNESS_MODE:
			pass

func movement_process():
	var joy_input = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	is_moving = false
	direction = Vector2(0, 0)
	#print(joy_input)
	
	if(Input.is_action_pressed("bernard_move_up")):
		direction.y -= 1
		speed = max_speed
		is_moving = true
	elif(Input.is_action_pressed("bernard_move_down")):
		direction.y += 1
		speed = max_speed
		is_moving = true

	if(Input.is_action_pressed("bernard_move_left")):
		direction.x -= 1
		speed = max_speed
		is_moving = true
	elif(Input.is_action_pressed("bernard_move_right")):
		direction.x += 1
		speed = max_speed
		is_moving = true
	
	if(Input.is_action_pressed("bernard_move_up") or Input.is_action_pressed("bernard_move_down")):
		direction.y *= abs(joy_input.y)
	
	if(Input.is_action_pressed("bernard_move_left") or Input.is_action_pressed("bernard_move_right")):
		direction.x *= abs(joy_input.x)
	
	direction_angle_in_radians = x_axis.angle_to(direction)
	
	if(Input.is_action_pressed("bernard_move_up") or Input.is_action_pressed("bernard_move_down") or Input.is_action_pressed("bernard_move_left") or Input.is_action_pressed("bernard_move_right")):
		speed *= max(abs(joy_input.x), abs(joy_input.y))

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

func is_Hewie_nearby():
	return Hewie.global_position.distance_to(global_position) < IS_HEWIE_NEARBY_RANGE

func choose_animation() -> void:
	var X_axis = Vector2(-1, 0)
	var direction_angle_in_degrees = direction_angle_in_radians * 180 / PI
	var animation_index = int(int((direction_angle_in_degrees + 360 + 8) / 22) % 16)
	#print(animation_index)
	#print(str(angle) + " => " + str("animation_" + "%02d" % animation_index))
	
	Singleton.change_animation($AnimationPlayer, "animation_" + "%02d" % animation_index)

func _on_Hewie_give_key(given_key):
	grabbed_key = given_key
	change_state(State.GRABBING)

func _on_Area2D_body_entered(body):
	if(body.is_in_group("doors")):
		if(current_state == State.GRABBING and grabbed_key != null and body.is_opened_by(grabbed_key)):
			#body.get_parent().activate() # Open door from the door
			grabbed_key.use() # Open door using the key
			grabbed_key.queue_free()
			change_state(State.WALKING)

func _on_Area2D_area_entered(area):
	if(area.get_parent().is_in_group("dog_buttons")):
		is_pressing_button = true
		button_being_pressed = area.get_parent()
		
		if(not Hewie.is_pressing_button or Hewie.button_being_pressed.mechanism_id != button_being_pressed.mechanism_id):
			area.get_parent().use()

func _on_Area2D_area_exited(area):
	if(area.get_parent().is_in_group("dog_buttons")):
		if(not Hewie.is_pressing_button or Hewie.button_being_pressed.mechanism_id != button_being_pressed.mechanism_id):
			area.get_parent().use()
		
		is_pressing_button = false
		button_being_pressed = null
