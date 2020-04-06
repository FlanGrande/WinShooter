extends Node2D

const NORTH = 0
const SOUTH = 1
const EAST = 2
const WEST = 3

# Each Edge within a cluster of blocks will use this class.
class Edge:
	var start_point : Vector2 = Vector2(0.0, 0.0)
	var end_point : Vector2 = Vector2(0.0, 0.0)

var cell = preload("res://scenes/Environment/WallBlock.tscn")
var typeof_cell = typeof(cell.instance())

var world = []; # Array (maybe matrix) that represents the world. Will contain -1 until it contains an instance.
var world_width = 40;
var world_height = 30;
var edges_array = [];
var cell_width = 64; # Width, in pixels (this should be the size of the WallBlock scene object).
var cell_offset = cell_width / 2;

func _ready():
	var i = 0
	
	while i < world_width * world_height:
		world.insert(i, -1)
		i += 1
	
	$WorldEnvironment/Light2D.visible = true
	$Niwt.visible = true
	
	pass

func _process(delta):
	var mouse_position = get_global_mouse_position()
	
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	
#	if Input.is_action_just_released("place_block"):
#		var i = int(mouse_position.y / cell_width) * world_width + int(mouse_position.x / cell_width)
#
#		if typeof(world[i]) == typeof(-1):
#			var cell_instance = cell.instance()
#			var new_pos = Vector2(((i % world_width) * cell_width+cell_offset), ((i / world_width) * cell_width)+cell_offset)
#			cell_instance.position = new_pos
#			world[i] = cell_instance
#
#	convertTileMapToPolyMap(Vector2(0, 0), world_width, world_height, cell_width, 40)
#
#	# Instance blocks from tilemap
#	var i = 0
#	while i < world_width * world_height:
#		if typeof(world[i]) == typeof_cell:
#			if not world[i].exists:
#				world[i].exists = true
#				$nd_Walls.add_child(world[i])
#		i += 1
#
#	for line in get_tree().get_nodes_in_group("lines"):
#		line.queue_free()
#
#	i = 0
#	while i < edges_array.size():
#		var line = Line2D.new()
#		line.add_to_group("lines")
#		line.default_color = Color(1.0, 0.0, 0.0, 1.0)
#		line.width = 3.0
#		line.add_point(edges_array[i].start_point)
#		line.add_point(edges_array[i].end_point)
#		$nd_Walls.add_child(line)
#		i += 1
#
	pass

# Parses a rectangle section of the grid into a map of the edges contained within it.
# Starting point, width in tiles, height in tiles, block width and pitch (I'm not sure what pitch is for now).
func convertTileMapToPolyMap(start_point : Vector2, w : int, h : int, block_width : float, pitch : int):
	edges_array = [] # We clear the current edges array.
	
	# Re-initialise edges from existing blocks
	var x = 0
	while x < w:
		var y = 0
		while y < h:
			var j = 0
			while j < 4:
				# if the types are the same, it means a cell exists on this position.
				if typeof(world[(y + start_point.y) * pitch + (x + start_point.x)]) == typeof_cell:
					world[(y + start_point.y) * pitch + (x + start_point.x)].edge_exists[j] = false
					world[(y + start_point.y) * pitch + (x + start_point.x)].edge_id[j] = -1
				j += 1
			y += 1
		x += 1
	
	
	x = 1
	while x < w-1:
		var y = 1
		while y < h-1:
			var this_tile = (y + start_point.y) * pitch + (x + start_point.x) # This
			var north = (y + start_point.y - 1) * pitch + (x + start_point.x) # Northern neighbour
			var south = (y + start_point.y + 1) * pitch + (x + start_point.x) # Southern neighbour
			var west = (y + start_point.y) * pitch + (x + start_point.x - 1) # Western neighbour
			var east = (y + start_point.y) * pitch + (x + start_point.x + 1) # Eastern neighbour
			
			# If a cell exists here, we'll check if it has edges to create or extend.
			if typeof(world[this_tile]) == typeof_cell:
				
				### WEST EDGE?
				# If there's no western neighbour, we will add or extend a western edge.
				if not (typeof(world[west]) == typeof_cell):
					# Now we decide if we extend the edge from a northern neighbour or add a new one.
					if typeof(world[north]) == typeof_cell and world[north].edge_exists[WEST]:
						print("EXTEND")
						# Inside here, a northern neighbour exists and it already has an edge at the west side, so we extend it.
						edges_array[world[north].edge_id[WEST]].end_point.y += block_width
						world[this_tile].edge_id[WEST] = world[north].edge_id[WEST]
						world[this_tile].edge_exists[WEST] = true
					else:
						# Otherwise, it means northern neighbour has no western edge, so we add a new edge there.
						print("NEW")
						var edge = Edge.new()
						edge.start_point.x = (start_point.x + x) * block_width
						edge.start_point.y = (start_point.y + y) * block_width
						edge.end_point.x = edge.start_point.x
						edge.end_point.y = edge.start_point.y + block_width
						
						# Finally, we add it to the edge pool...
						var edge_id = edges_array.size()
						edges_array.append(edge)
						
						# ...and update this world's cell edge information.
						world[this_tile].edge_id[WEST] = edge_id
						world[this_tile].edge_exists[WEST] = true
				### WEST EDGE?
				
				### EAST EDGE?
				# If there's no eastern neighbour, we will add or extend a eastern edge.
				if not (typeof(world[east]) == typeof_cell):
					# Now we decide if we extend the edge from a northern neighbour or add a new one.
					if typeof(world[north]) == typeof_cell and world[north].edge_exists[EAST]:
						# Inside here, a northern neighbour exists and it already has an edge at the east side, so we extend it.
						edges_array[world[north].edge_id[EAST]].end_point.y += block_width
						world[this_tile].edge_id[EAST] = world[north].edge_id[EAST]
						world[this_tile].edge_exists[EAST] = true
					else:
						# Otherwise, it means northern neighbour has no eastern edge, so we add a new edge there.
						var edge = Edge.new()
						edge.start_point.x = (start_point.x + x) * block_width + block_width
						edge.start_point.y = (start_point.y + y) * block_width
						edge.end_point.x = edge.start_point.x
						edge.end_point.y = edge.start_point.y + block_width
						
						# Finally, we add it to the edge pool...
						var edge_id = edges_array.size()
						edges_array.append(edge)
						
						# ...and update this world's cell edge information.
						world[this_tile].edge_id[EAST] = edge_id
						world[this_tile].edge_exists[EAST] = true
				### EAST EDGE?
				
				### NORTH EDGE?
				# If there's no northern neighbour, we will add or extend a northern edge.
				if not (typeof(world[north]) == typeof_cell):
					# Now we decide if we extend the edge from a western neighbour or add a new one.
					if typeof(world[west]) == typeof_cell and world[west].edge_exists[NORTH]:
						# Inside here, a western neighbour exists and it already has an edge at the north side, so we extend it.
						edges_array[world[west].edge_id[NORTH]].end_point.x += block_width
						world[this_tile].edge_id[NORTH] = world[west].edge_id[NORTH]
						world[this_tile].edge_exists[NORTH] = true
					else:
						# Otherwise, it means western neighbour has no northern edge, so we add a new edge there.
						var edge = Edge.new()
						edge.start_point.x = (start_point.x + x) * block_width
						edge.start_point.y = (start_point.y + y) * block_width
						edge.end_point.x = edge.start_point.x + block_width
						edge.end_point.y = edge.start_point.y
						
						# Finally, we add it to the edge pool...
						var edge_id = edges_array.size()
						edges_array.append(edge)
						
						# ...and update this world's cell edge information.
						world[this_tile].edge_id[NORTH] = edge_id
						world[this_tile].edge_exists[NORTH] = true
				### NORTH EDGE?
				
				### SOUTH EDGE?
				# If there's no northern neighbour, we will add or extend a northern edge.
				if not (typeof(world[south]) == typeof_cell):
					# Now we decide if we extend the edge from a western neighbour or add a new one.
					if typeof(world[west]) == typeof_cell and world[west].edge_exists[SOUTH]:
						# Inside here, a western neighbour exists and it already has an edge at the south side, so we extend it.
						edges_array[world[west].edge_id[SOUTH]].end_point.x += block_width
						world[this_tile].edge_id[SOUTH] = world[west].edge_id[SOUTH]
						world[this_tile].edge_exists[SOUTH] = true
					else:
						# Otherwise, it means western neighbour has no northern edge, so we add a new edge there.
						var edge = Edge.new()
						edge.start_point.x = (start_point.x + x) * block_width
						edge.start_point.y = (start_point.y + y) * block_width + block_width
						edge.end_point.x = edge.start_point.x + block_width
						edge.end_point.y = edge.start_point.y
						
						# Finally, we add it to the edge pool...
						var edge_id = edges_array.size()
						edges_array.append(edge)
						
						# ...and update this world's cell edge information.
						world[this_tile].edge_id[SOUTH] = edge_id
						world[this_tile].edge_exists[SOUTH] = true
				### SOUTH EDGE?
			
			y += 1
		x += 1
	print("------------")
	pass

#func doesCellExistHere(var index):
#	return typeof(world[index]) == typeof(typeof_cell)
