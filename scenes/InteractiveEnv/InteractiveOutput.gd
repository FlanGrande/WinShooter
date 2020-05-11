extends Node2D

export var active = false # Is it active? Can it be used? E.g.: it's broken?
export var connected_input_nodepath : NodePath # NodePath to mechanism affected by this input.
export(String, "KeyDoor", "Traffic light") var type # Is it a door, a traffic light...?

var door_node = preload("res://scenes/InteractiveEnv/Door.tscn")

var connected_input : Node2D # Input connected to this object. E.g. A key is connected to this door. Needs to be initialize()'d.
var output_instance # Instance that contains aninteractive output instance. E.g. a Door instance.

# Right now Outputs need to be Ready after Inputs. I want to find a solution for that, ideally, without doing stuff like waiting 0.1s or something.

# Called when the node enters the scene tree for the first time.
func _ready():
	connected_input = get_node(connected_input_nodepath)
	$Sprite.queue_free()
	
	match type:
		"KeyDoor":
			output_instance = door_node.instance()
			connected_input.initialize()
			output_instance.mechanism_that_opens = connected_input.input_instance
			add_child(output_instance)
		
		"DogButtonDoor":
			pass

func _process(delta):
	pass

func activate():
	# Open door, etc.
	
	match type:
		"KeyDoor":
			output_instance.open()
		
		"DogButtonDoor":
			pass
	
	pass

func deactivate():
	# Close door, etc.
	
	match type:
		"KeyDoor":
			output_instance.close()
		
		"DogButtonDoor ":
			pass
	
	pass
