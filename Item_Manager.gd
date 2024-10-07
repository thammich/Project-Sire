extends Node

class_name ItemManager

enum ItemCategory {ITEM = 0, FOOD = 1, WEAPON = 2, MELEEWEAPON = 3, PROJECTILEWEAPON = 4}
var itemCategories = ["Item", "Food", "Weapon", "MeleeWeapon", "ProjectileWeapon"]

var foodPrototypes = [] # all items possible

var itemsInWorld = [] # actual items

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoadFood()
	
	SpawnItem(foodPrototypes[0], Vector2(5, 10))
	SpawnItem(foodPrototypes[1], Vector2(6, 12))
	SpawnItem(foodPrototypes[1], Vector2(8, 3))
	SpawnItem(foodPrototypes[0], Vector2(10, 10))
	print(IsItemInCategory(itemsInWorld[0], ItemCategory.FOOD))
	print(IsItemInCategory(itemsInWorld[0], ItemCategory.ITEM))
	print(IsItemInCategory(itemsInWorld[0], ItemCategory.WEAPON))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func MapToWorldPosition(mapPosX : int, mapPosY : int) -> Vector2: # grid system
	return Vector2(mapPosX * 16 + 8, mapPosY * 16 + 8)

func RemoveItemFromWorld(item):
	remove_child(item)
	itemsInWorld.erase(item)

func SpawnItem(item, mapPosition): # item spawner
	var newItem = item.instantiate()
	add_child(newItem)
	itemsInWorld.append(newItem)
	newItem.position = MapToWorldPosition(mapPosition.x, mapPosition.y)

func FindNearestItem(itemCategory : ItemCategory, worldPosition : Vector2):
	if len(itemsInWorld) == 0:
		return null
	
	var nearestItem = null
	var nearestDistance = 999999 
	
	for item in itemsInWorld:
		if IsItemInCategory(item, itemCategory):
			var distance = worldPosition.distance_to(item.position)
			
			if nearestItem == null:
				nearestItem = item
				nearestDistance = distance
				continue
				
			if distance < nearestDistance:
				nearestItem = item
				nearestDistance = distance
	
	return nearestItem
	
func IsItemInCategory(item, itemCategory) -> bool:
	return item.is_in_group(itemCategories[itemCategory])

func LoadFood():
	var path = "res://Item/Food" # directory access and below
	var dir = DirAccess.open(path)
	dir.open(path)
	dir.list_dir_begin()
	while true: # adds the files in the folder
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with(".tscn"):
			foodPrototypes.append(load(path + "/" + file_name))
	dir.list_dir_end()
