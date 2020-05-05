extends Control

# States
enum State {
	IDLE,
	WALKING,
	RUNNING,
	FALLING,
	AIMING,
	SHOOTING,
	VERTICAL_JUMP,
	HORIZONTAL_JUMP,
	GRABBING,
	CLIMBING
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_state = get_parent().current_state
	var current_speed = get_parent().current_speed
	var closest_key_position = ""
	if(get_parent().grabbed_item != null): closest_key_position = get_parent().grabbed_item.position
	#var current_mouse_position_x = get_parent().get_local_mouse_position().x
	#var current_mouse_position_y = get_parent().get_local_mouse_position().y
	#var current_global_mouse_position_x = get_parent().get_global_mouse_position().x
	#var current_global_mouse_position_y = get_parent().get_global_mouse_position().y
	#var current_cast_position_x = get_parent().get_node("RayCast2DShoot").cast_to.x
	#var current_cast_position_y = get_parent().get_node("RayCast2DShoot").cast_to.y
	var current_animation = get_parent().get_node("AnimationPlayer").get_current_animation()
	var aiming_angle = get_parent().speed_angle_to_X_axis
	
	match current_state:
		State.IDLE:
			current_state = "IDLE"
		
		State.WALKING:
			current_state = "WALKING"
		
		State.GRABBING:
			current_state = "GRABBING"
	
	$dbgState.set_debug_value(str(current_state))
	$dbgSpeed.set_debug_value(str(current_speed))
	$dbgOnFloor.set_debug_value(str(closest_key_position))
	$dbgLocalMousePos.set_debug_value("")
	$dbgGlobalMousePos.set_debug_value("")
	$dbgCastPos.set_debug_value("")
	$dbgAnimation.set_debug_value("")
	$dbgAimingAngle.set_debug_value("")
