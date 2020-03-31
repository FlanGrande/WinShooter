extends RigidBody2D

export var max_lifetime_in_seconds = 1
var life_timer = Timer.new()

var current_speed = Vector2(0, 0)
var speed = 800
var speed_factor = 1.0
var direction_angle = 0

func _ready():
	rotation = direction_angle
	current_speed = Vector2(speed, 0).rotated(direction_angle)
	life_timer.connect("timeout", self, "_on_life_timer_timeout")
	life_timer.set_wait_time(max_lifetime_in_seconds)
	add_child(life_timer)
	life_timer.start()

func _process(delta):
	var impulse = Vector2(speed_factor * current_speed)
	apply_impulse(Vector2(0, 0), impulse)

# Hit something
func _on_Area2D_body_entered(body):
	if body.is_in_group("enemies"):
		body.current_speed = -30 * body.current_speed
		body.hit()
		queue_free()
		
	if body.is_in_group("walls"):
		queue_free()

# Max life time elapsed
func _on_life_timer_timeout():
	queue_free()
