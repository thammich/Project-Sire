@tool # run code in editor
extends TileMapLayer 

@export var generateTerrain : bool # click to generate terrain
@export var clearTerrain : bool # click to clear terrain

@export var mapWidth : int
@export var mapHeight : int 

@export var terrainSeed : int

@export var grassThreshold : float # thresholds for the terrain
@export var grass2Threshold : float
@export var dirtThreshold : float
@export var rockThreshold : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if generateTerrain: # button to click for terrain
		generateTerrain = false
		GenerateTerrain()
	
	if clearTerrain: # button + clears terrain
		clearTerrain = false
		clear()

# temp function to prevent bogging down the editor
func GenerateTerrain():
	print("Generating terrain...") # testing 
	
	var noise = FastNoiseLite.new() # random generation using 2d noise
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	
	var rng = RandomNumberGenerator.new() # check this
	
	if terrainSeed == 0: # terrainSeeds needs to be set at 0
		noise.seed = rng.randi() # allows for true random seeds for generation
	else: 
		noise.seed = terrainSeed # default
	
	for x in range(mapWidth): # (x, y) dimensions for terrain 
		for y in range(mapHeight): # allows for random terrain generation
			if noise.get_noise_2d(x, y) > grassThreshold: 
				set_cell(Vector2i(x, y), 0, Vector2i(0, 0)) 
			elif noise.get_noise_2d(x, y) > grass2Threshold:
				set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
			elif noise.get_noise_2d(x, y) > dirtThreshold:
				set_cell(Vector2i(x, y), 0, Vector2i(2, 0)) 
			elif noise.get_noise_2d(x, y) > rockThreshold:
				set_cell(Vector2i(x, y), 0, Vector2i(3, 0))  
			else:
				set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
				
				
# To Do List:
# Pawn AI
# Pawn interactions with each other
# UI? just use goodt for now
# need ot import timers later
#going to use 16x16 pixels to draw mainly
#change thresholds??
# getting a bunch of panws put in
# a) seeing how far we can push in numbers as terms of performance
# b) getting designs done
# c) simulate pawns and simulate the beliefs
#
# current bug list:
# when clicking on a snow tile, the pawn will not move there at all, either keep
# the way it is or add it so it will automatically find the closest tile that is not 
# snow to it
