extends StaticBody2D

export var key_scene : PackedScene

export var disabled = false
export var door_type = "keydoor"

var key_that_opens : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = disabled
	
	if(door_type == "keydoor"):
		var instance = key_scene.instance()
		instance.position = $MechanismPosition.position
		instance.rotation -= rotation
		add_child(instance)
		key_that_opens = instance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
