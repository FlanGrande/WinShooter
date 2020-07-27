extends KinematicBody2D

export var max_speed : = 200
export var speed : = 0
export var direction_angle_in_radians : = 0.0

var direction : = Vector2(0, 0)

var x_axis : = Vector2(1, 0)
var is_moving : = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.movement_system_nodes.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if(is_moving): move_and_slide(Vector2(speed, 0).rotated(direction_angle_in_radians))
