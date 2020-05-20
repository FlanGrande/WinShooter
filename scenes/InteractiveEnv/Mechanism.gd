extends Node2D

export var ID = ""
export var enabled = true
var input_instances = []
var output_instances = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if(child.is_in_group("inputs")):
			input_instances.push_back(child)
			
		if(child.is_in_group("outputs")):
			output_instances.push_back(child)
	
	connectInputsToOutputs()

func connectInputsToOutputs():
	for input in input_instances:
		for output in output_instances:
			if(not input.is_connected("use", output, "_on_Use" )):
				input.connect("use", output, "_on_Use" )
