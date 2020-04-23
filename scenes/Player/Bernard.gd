extends KinematicBody2D

# BERNARD

var bullet_scene = preload("res://scenes/Bullets/Bullet.tscn")

enum State {
	WALKING,
	GRABBING
}

var current_state = State.WALKING

var alive = false

# Movement
const MAX_SPEED = Vector2(460, 460)
const DEADZONE_SPEED = 80
const ACCELERATION = 40
const DECELERATION = 30
var speed_factor = 0.3
var current_speed = Vector2(0, 0)
var move_input_is_pressed = [false, false] # Input on X, input on Y

# Camera
const CAMERA_MAX_RANGE = Vector2(30, 30) # Max distance from the character to the camera
var camera_position = Vector2(0, 0) # Current camera position
var aiming_vector = Vector2(0, 0) # Vector representing the direction the player is aiming to
var x_axis = Vector2(1, 0) # Vector for the axis used to calculate aiming angle (X axis, namely)

# Interactions
var grabbed_key = null
var grabbed_item_offset = Vector2(0, 0)

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
	
	pass

func handle_input():
	match current_state:
		# TO DO: Move towards controller input, as in analog movement.
		State.WALKING:
			handle_movement()
		
		State.GRABBING:
			handle_movement()
			
			grabbed_key.position = global_position + grabbed_item_offset
			
			if(Input.is_action_just_released("bernard_drop")):
				change_state(State.WALKING)

func update():
	match current_state:
		State.WALKING:
			if current_speed.y > MAX_SPEED.y:
				current_speed.y = MAX_SPEED.y
			elif current_speed.y < -MAX_SPEED.y:
				current_speed.y = -MAX_SPEED.y
			
			if current_speed.x > MAX_SPEED.x:
				current_speed.x = MAX_SPEED.x
			elif current_speed.x < -MAX_SPEED.x:
				current_speed.x = -MAX_SPEED.x
		
		State.GRABBING:
			if current_speed.y > MAX_SPEED.y:
				current_speed.y = MAX_SPEED.y
			elif current_speed.y < -MAX_SPEED.y:
				current_speed.y = -MAX_SPEED.y
			
			if current_speed.x > MAX_SPEED.x:
				current_speed.x = MAX_SPEED.x
			elif current_speed.x < -MAX_SPEED.x:
				current_speed.x = -MAX_SPEED.x

func handle_movement():
	move_input_is_pressed = [false, false]
			
	if(Input.is_action_pressed("bernard_move_left")):
		current_speed.x += -ACCELERATION
		move_input_is_pressed[0] = true
	
	if(Input.is_action_pressed("bernard_move_right")):
		current_speed.x += ACCELERATION
		move_input_is_pressed[0] = true
	
	if(Input.is_action_pressed("bernard_move_up")):
		current_speed.y += -ACCELERATION
		move_input_is_pressed[1] = true
	
	if(Input.is_action_pressed("bernard_move_down")):
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


func _on_Hewie_give_key(given_key):
	grabbed_key = given_key
	change_state(State.GRABBING)

func _on_Area2D_body_entered(body):
	if(body.is_in_group("doors")):
		if(current_state == State.GRABBING and grabbed_key != null):
			body.queue_free()
			grabbed_key.queue_free()
			change_state(State.WALKING)