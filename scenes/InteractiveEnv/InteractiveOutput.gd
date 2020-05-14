extends Node2D

export var active = false # Is it active? Can it be used? E.g.: it's broken?
export(Array, NodePath) var connected_inputs_nodepaths # NodePath to mechanism affected by this input.
export(String, "Door", "TrafficLight") var type # Is it a door, a traffic light...?

var door_node = preload("res://scenes/InteractiveEnv/Door.tscn")
var trafficlight_node = preload("res://scenes/InteractiveEnv/TrafficLight.tscn")

var connected_inputs : Array # Input connected to this object. E.g. A key is connected to this door. Needs to be initialize()'d.
var output_instance # Instance that contains an interactive output instance. E.g. a Door instance.

# Right now Outputs need to be Ready after Inputs. I want to find a solution for that, ideally, without doing stuff like waiting 0.1s or something.

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.queue_free()
	
	for path in connected_inputs_nodepaths:
		connected_inputs.append(get_node(path))
	
	match type:
		"Door":
			output_instance = door_node.instance()
			
			for input in connected_inputs:
				if(input):
					input.initialize()
					output_instance.mechanisms_that_open.append(input.input_instance)
			
			add_child(output_instance)
		
		"TrafficLight":
			output_instance = trafficlight_node.instance()
			
			for input in connected_inputs:
				input.initialize()
				output_instance.mechanisms_that_open.append(input.input_instance)
			
			add_child(output_instance)

func _process(delta):match type:
		"Door":
			pass
		
		"TrafficLight":
			if(connected_inputs.size() == 0):
				if(output_instance.current_light == "red"):
					pass

func activate():
	# Open door, etc.
	
	match type:
		"Door":
			output_instance.open()
		
		"TrafficLight":
			output_instance.open()

func deactivate():
	# Close door, etc.
	
	match type:
		"Door":
			output_instance.close()
		
		"TrafficLight":
			output_instance.close()
