extends StaticBody2D

export var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = disabled
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
