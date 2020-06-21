extends Node2D

onready var vehicle_scene = preload("res://scenes/Hazards/Vehicle.tscn")

export var spawn_base = 1 # 1 means a car is spawned every second. 4 means a car is spawned every 4 seconds.
export var randomness_range = 0.0 # We add and substract this for rand_rang values.

var max_cars = 3

var vehicles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerSpawnRate.start()
	max_cars = round(rand_range(2, 4))
	#print(max_cars)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TimerSpawnRate_timeout():
	if(vehicles.size() < max_cars):
		var vehicle_instance = vehicle_scene.instance()
		vehicle_instance.global_position = $VehiclesInitialPosition.global_position
		vehicle_instance.rotate($VehiclesInitialPosition.rotation)
		#vehicle_instance.initial_position = $VehiclesInitialPosition.global_position
		vehicle_instance.goal_position = $VehiclesGoalPosition.global_position
		vehicles.push_back(vehicle_instance)
		get_parent().add_child(vehicle_instance)
	
	#print("added vehicle " + str(vehicles.size()))
	$TimerSpawnRate.start(rand_range(spawn_base - randomness_range, spawn_base + randomness_range))
