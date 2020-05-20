extends Node2D

export var active = false # Is it active? Can it be used? E.g.: it's broken?
export(String, "Door", "TrafficLight") var type # Is it a door, a traffic light...?

onready var mechanism_id# = get_parent().ID

var door_node = preload("res://scenes/InteractiveEnv/Door.tscn")
var trafficlight_node = preload("res://scenes/InteractiveEnv/TrafficLight.tscn")

var output_instance # Instance that contains an interactive output instance. E.g. a Door instance.
var is_activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.queue_free()
	
	match type:
		"Door":
			output_instance = door_node.instance()
			add_child(output_instance)
		
		"TrafficLight":
			output_instance = trafficlight_node.instance()
			add_child(output_instance)

func _process(delta):
	match type:
		"Door":
			pass
		
		"TrafficLight":
			if(output_instance.current_light == "red"):
				pass

func activate():
	# Open door, etc.
	is_activated = true
	
	match type:
		"Door":
			output_instance.open()
		
		"TrafficLight":
			output_instance.start_rotation()

func deactivate():
	# Close door, etc.
	is_activated = false
	
	match type:
		"Door":
			output_instance.close()

func _on_Use():
	if(is_activated):
		deactivate()
	else:
		activate()

