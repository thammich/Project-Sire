extends CharacterBody2D

@onready var terrain = $"../Terrain"
@onready var pathfinding = $"../Pathfinding"
@onready var itemManager = $"../ItemManager"

const SPEED = 300.0

var path = []

func SetMoveTarget(worldPos : Vector2):
	var pos = position / terrain.rendering_quadrant_size # might have to fix
	var targetPos = worldPos / terrain.rendering_quadrant_size
	
	path = pathfinding.RequestPath(pos, targetPos)

func HasReachedDestination():
	return len(path) == 0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		# gets position of pawn
		var pos = position / terrain.rendering_quadrant_size # get pawn position
		var targetPos = get_global_mouse_position() / terrain.rendering_quadrant_size # get click position
		
		path = pathfinding.RequestPath(pos, targetPos)
		
	if Input.is_action_just_pressed("ui_accept"): # press space to find the nearest food
		var pos = position / terrain.rendering_quadrant_size 
		var targetPos = itemManager.FindNearestItem(itemManager.ItemCategory.FOOD, position).position / terrain.rendering_quadrant_size # FIX ME 35!!  terrain.tile_set.tile_size???
		print(targetPos)
		path = pathfinding.RequestPath(pos, targetPos)
		
	if len(path) > 0:
		var direction = global_position.direction_to(path[0])
		var terrainDifficulty = pathfinding.GetTerrainDifficulty(position / terrain.rendering_quadrant_size)
		
		velocity = direction * SPEED * (1 / terrainDifficulty)
		
		if position.distance_to(path[0]) < SPEED * delta:
			path.remove_at(0)
	else:
		velocity = Vector2(0, 0)

	move_and_slide()


# summary of code im getting lazy
# code that moves the pawn using a path, and code that changes speed based off terrain difficulty
# impassible terrain (snow in pathfinding script)
