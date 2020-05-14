extends Node2D

var current_light = "red"
export(String, "Timer", "Button") var mode

# Called when the node enters the scene tree for the first time.
func _ready():
	current_light = "red"
	$sprRedLight.visible = true
	$sprAmberLight.visible = false
	$sprGreenLight.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(mode == "Timer"):
		$tmrTrafficLight.start()

func _on_tmrTrafficLight_timeout():
	if($sprRedLight.visible):
		$sprRedLight.visible = false
		$sprAmberLight.visible = true
		$sprGreenLight.visible = false
		current_light = "amber"
	
	elif($sprAmberLight.visible):
		$sprRedLight.visible = false
		$sprAmberLight.visible = false
		$sprGreenLight.visible = true
		current_light = "green"
	
	elif($sprGreenLight.visible):
		$sprRedLight.visible = true
		$sprAmberLight.visible = false
		$sprGreenLight.visible = false
		current_light = "red"
