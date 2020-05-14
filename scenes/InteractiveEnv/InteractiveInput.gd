extends Node2D

export var active = false # Is it active? Can it be used? E.g.: it's broken?
export var connected_output_nodepath : NodePath # NodePath to mechanism affected by this input.
export(String, "Key", "DogButton") var type # Is it a door, a traffic light...?

var key_node = preload("res://scenes/InteractiveEnv/Key.tscn")
var dogbutton_node = preload("res://scenes/InteractiveEnv/DogButton.tscn")

var connected_output : Node2D
var input_instance # Instance that interacts with the output (e.g. a Key instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.queue_free()
	connected_output = get_node(connected_output_nodepath)

func _process(delta):
	pass

# This function is used to reset the input_instance or initialize it exactly when we need it, to avoid Null.
func initialize():
	match type:
		"Key":
			input_instance = key_node.instance()
			add_child(input_instance)
		
		"DogButton":
			input_instance = dogbutton_node.instance()
			add_child(input_instance)

func turn_on():
	connected_output.activate()

func turn_off():
	connected_output.deactivate()
