extends Node

class_name Task

enum TaskType {BaseTask, FindItem, WalkTo, Pickup, Eat, Manipulate, Harvest}

var taskName : String
var taskType : TaskType = TaskType.BaseTask

var subTasks = []
var currentSubTask : int = 0

var targetItem
var targetItemType

func IsFinished() -> bool:
	return currentSubTask == len(subTasks)
	
func Finish():
	currentSubTask == len(subTasks)
	
func GetCurrentSubTask():
	return subTasks[currentSubTask]
	
func OnFinishedSubTask():
	currentSubTask += 1
	
func OnFoundItem(item):
	OnFinishedSubTask()
	GetCurrentSubTask().targetItem = item
	
func OnReachedDestination():
	OnFinishedSubTask()
	GetCurrentSubTask().targetItem = subTasks[currentSubTask - 1].targetItem

func InitFindAndEatFoodTask():
	taskName = "Find and eat some food"
	
	var subTask = Task.new()
	subTask.taskType = TaskType.FindItem
	subTask.targetItemType = ItemManager.ItemCategory.FOOD
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.WalkTo
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.Pickup
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.Eat
	subTasks.append(subTask)
