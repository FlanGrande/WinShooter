extends Camera2D

export var shaking_duration_in_seconds = 0.12
export var max_shake_x = 16
export var max_shake_y = 8

var shaking = false
var shake_timer = Timer.new()

func _ready():
	shaking = false
	shake_timer.connect("timeout", self, "_on_shake_timer_timeout")
	shake_timer.set_wait_time(shaking_duration_in_seconds)
	shake_timer.one_shot = true
	add_child(shake_timer)

func _process(delta):
	if shaking:
		var shake_x = rand_range(-max_shake_x, max_shake_x)
		var shake_y = rand_range(-max_shake_y, max_shake_y)
		
		offset = Vector2(shake_x, shake_y)
	else:
		offset = Vector2(0, 0)

func shake():
	shaking = true
	shake_timer.start()

func _on_shake_timer_timeout():
	shaking = false
	shake_timer.stop()
