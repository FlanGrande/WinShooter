extends Node2D

var mechanisms_that_open : Array

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_open):
		visible = false
		$sprDoor.visible = false
		$CollisionShape2D.disabled = true
		$LightOccluder2D.visible = false
	else:
		visible = true
		$sprDoor.visible = true
		$CollisionShape2D.disabled = false
		$LightOccluder2D.visible = true

func open():
	is_open = true

func close():
	is_open = false
