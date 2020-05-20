extends Node2D

onready var mechanism = get_parent().get_parent()
onready var mechanism_id = mechanism.ID

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func use():
	get_parent().use()
