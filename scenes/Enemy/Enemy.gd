extends KinematicBody2D

var initial_speed = 2
var speed = initial_speed
var current_speed = Vector2(0, 0)
var speed_factor = 1.0
var hit_points = 3

var nwit_node

func _ready():
	nwit_node = get_parent().get_node("Niwt")
	pass

func _process(delta):
	current_speed = Vector2(speed, 0).rotated(get_angle_to(nwit_node.position))
	
	var motion = Vector2(speed_factor * current_speed)
	move_and_collide(motion)
	
	$Sprite.look_at(nwit_node.global_position)

func hit():
	$tmr_Hit.start()
	speed = -abs(speed) * 3
	hit_points -= 1
	
	if hit_points == 0:
		queue_free()

func _on_tmr_Hit_timeout():
	initial_speed *= 1.6
	speed = initial_speed
