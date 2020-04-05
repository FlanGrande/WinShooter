extends Node2D

# Based on https://www.youtube.com/watch?v=fc3nnG2CG8U
# We will detect all edges in the map and each one will have an ID assign to it.
# Each cell will contain the id of the edges passing through its borders.

const NORTH = 0
const SOUTH = 1
const EAST = 2
const WEST = 3

# Each Cell, as defined by its edges.
#var Cell = {
#	edge_id = [-1, -1, -1, -1], # Array that has 4 elements that will represent the edge id. -1 if no edge_id has been assigned.
#	edge_exist = [false, false, false, false], # Array with 4 elements to tell us if there is an edge in that side.
#	exist = false
#}

var edge_id = [-1, -1, -1, -1] # Array that has 4 elements that will represent the edge id. -1 if no edge_id has been assigned.
var edge_exists = [false, false, false, false] # Array with 4 elements to tell us if there is an edge in that side.
var exists = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
