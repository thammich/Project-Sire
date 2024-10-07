extends Item

class_name Food

enum FoodType {OMNIVORE = 0, VEGETARIAN = 1, CARNIVORE = 2}
enum FoodQuality {RUBBISH = 0, SIMPLE = 1, GOOD = 2, FANCY = 3}

@export var nutrition = 1.0
@export var foodType : FoodType
@export var foodQuality : FoodQuality

func _init():
	super._init();
	add_to_group("Food")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
