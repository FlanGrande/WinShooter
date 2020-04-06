extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#export var polygon : PoolVector2Array

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Polygon2D.polygon = polygon
	var lo2D = LightOccluder2D.new()
	lo2D.occluder = OccluderPolygon2D.new()
	lo2D.occluder.closed = true
	lo2D.occluder.cull_mode = 1 # 1 means ClockWise.
	lo2D.occluder.polygon = $Polygon2D.polygon
	
	var cp2D = CollisionPolygon2D.new()
	cp2D.polygon = $Polygon2D.polygon
	
	add_child(lo2D)
	add_child(cp2D)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
