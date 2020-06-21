extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()

func getClosestNodeInArray(current_position, array):
	var closest_node = array[0]
	var closest_distance = current_position.distance_to(closest_node.global_position)
	
	for node in array:
		var d = current_position.distance_to(node.global_position)
		if(d < closest_distance):
			closest_distance = d
			closest_node = node
	
	return closest_node
