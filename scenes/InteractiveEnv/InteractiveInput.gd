extends Node2D

signal use

export var active = true # Is it active? Can it be used? E.g.: it's broken?
export(String, "Key", "DogButton") var type # Is it a door, a traffic light...?

onready var mechanism_id = get_parent().ID

var key_node = preload("res://scenes/InteractiveEnv/Key.tscn")
var dogbutton_node = preload("res://scenes/InteractiveEnv/DogButton.tscn")

var input_instance # Instance that interacts with the output (e.g. a Key instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.queue_free()
	initialize()

func _process(delta):
	pass

# This function is used to reset the input_instance or initialize it exactly when we need it, to avoid Null.
func initialize():
	match type:
		"Key":
			input_instance = key_node.instance()
			mechanism_id = get_parent().ID
			add_child(input_instance)
		
		"DogButton":
			input_instance = dogbutton_node.instance()
			add_child(input_instance)

func use():
	if(active): emit_signal("use")
