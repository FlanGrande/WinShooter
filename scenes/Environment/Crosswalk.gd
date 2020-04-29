extends StaticBody2D

export var can_be_crossed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = can_be_crossed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
