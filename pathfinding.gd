@tool
extends Node2D

@onready var terrain = $"../Terrain" # gives access to terrain

var astar_grid = AStarGrid2D.new() # grid based game? check	

# testing values
@export var start : Vector2i
@export var end : Vector2i
@export var calculate : bool

var path = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitPathFinding()
	pass
	
func _draw(): # test - draw a line to showcase pathfinding
	if len(path) > 0:
		for i in range(len(path) - 1):
			draw_line(path[i], path[i + 1], Color.SKY_BLUE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if calculate:
		calculate = false
		InitPathFinding()
		RequestPath(start, end)
		
func RequestPath(start: Vector2i, end: Vector2i):
	path = astar_grid.get_point_path(start, end)
	
	for i in range(len(path)):
		path[i] += Vector2(terrain.rendering_quadrant_size / 2, terrain.rendering_quadrant_size / 2)
	queue_redraw() # will run draw again
	return path


func InitPathFinding():
	astar_grid.region = Rect2i(0, 0, terrain.mapWidth, terrain.mapHeight) # sets size
	astar_grid.cell_size = Vector2(16, 16) # pixel size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	
	# loop through every single position on the grid using custom data
	# done uusing walk_difficulty as a float
	for x in range(terrain.mapWidth):
		for y in range(terrain.mapHeight):
			if GetTerrainDifficulty(Vector2i(x, y)) == -1:
				astar_grid.set_point_solid(Vector2i(x, y))
			else:
				astar_grid.set_point_weight_scale(Vector2i(x, y), GetTerrainDifficulty(Vector2i(x,y)))

func GetTerrainDifficulty(coords : Vector2i): # code to get access to custom data
	var layer = 0
	var source_id = terrain.get_cell_source_id(coords)
	var source: TileSetAtlasSource = terrain.tile_set.get_source(source_id)
	var atlas_coords = terrain.get_cell_atlas_coords(coords)
	var tile_data = source.get_tile_data(atlas_coords, 0)
	
	return tile_data.get_custom_data("walk_difficulty")
