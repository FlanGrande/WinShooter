extends Node2D

const RED_DURATION = 4
const AMBER_DURATION = 3
const GREEN_DURATION = 10

onready var mechanism = get_parent().get_parent()
onready var mechanism_id = mechanism.ID

var current_light = "red"
var is_playing = false
var type = "Button"

# Called when the node enters the scene tree for the first time.
func _ready():
	current_light = "red"
	$sprRedLight.visible = true
	$sprAmberLight.visible = false
	$sprGreenLight.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(mechanism.input_instances.size() == 0):
		type = "Timer"
		start_rotation()
	else:
		type = "Button"

func start_rotation():
	if(not is_playing):
		$tmrTrafficLight.start(RED_DURATION)
		is_playing = true

func _on_tmrTrafficLight_timeout():
	
	if($sprRedLight.visible):
		$sprRedLight.visible = false
		$sprAmberLight.visible = false
		$sprGreenLight.visible = true
		current_light = "green"
		$tmrTrafficLight.start(GREEN_DURATION)
		
	elif($sprGreenLight.visible):
		$sprRedLight.visible = false
		$sprAmberLight.visible = true
		$sprGreenLight.visible = false
		current_light = "amber"
		$tmrTrafficLight.start(AMBER_DURATION)
	
	elif($sprAmberLight.visible):
		$sprRedLight.visible = true
		$sprAmberLight.visible = false
		$sprGreenLight.visible = false
		current_light = "red"
		is_playing = false
		if(type == "Timer"): start_rotation()
