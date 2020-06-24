extends Node2D

onready var vehicle_scene = preload("res://scenes/Hazards/Vehicle.tscn")

export var enabled = true
export var spawn_base = 1 # 1 means a car is spawned every second. 4 means a car is spawned every 4 seconds.
export var randomness_range = 0.0 # We add and substract this for rand_rang values.
export var max_cars = 3
export var randomness_range_max = 0.0 # We add and substract this for rand_rang values.
export var is_path_closed = false

var vehicles = []
var curve2D : PoolVector2Array

# Called when the node enters the scene tree for the first time.
func _ready():
	if(enabled):
		curve2D = $Path2D.get_curve().get_baked_points()
		max_cars = round(rand_range(max_cars - randomness_range_max, max_cars + randomness_range_max))
		$TimerSpawnRate.start(rand_range(spawn_base - randomness_range, spawn_base + randomness_range))
	#print(max_cars)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TimerSpawnRate_timeout():
	if(vehicles.size() < max_cars):
		var vehicle_instance = vehicle_scene.instance()
		vehicle_instance.path_to_follow = curve2D
		vehicle_instance.position = vehicle_instance.path_to_follow[0]
		vehicle_instance.is_path_closed = is_path_closed
		vehicle_instance.ID = name + "_" + str(vehicles.size())
		vehicles.push_back(vehicle_instance)
		add_child(vehicle_instance)
		#vehicle_instance.global_position = curve2D[0]
		#vehicle_instance.rotate($VehiclesInitialPosition.rotation)
		#vehicle_instance.initial_position = $VehiclesInitialPosition.global_position
		#vehicle_instance.goal_position = curve2D[curve2D.size() - 1]
	
	#print("added vehicle " + str(vehicles.size()))
	$TimerSpawnRate.start(rand_range(spawn_base - randomness_range, spawn_base + randomness_range))
