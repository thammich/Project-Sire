extends Node

@onready var taskManager = $"../../TaskManager"
@onready var itemManager = $"../../ItemManager"

@onready var charController = $".."

@onready var hungerBar = $"../hungerBar"

enum PawnAction {Idle, DoingSubTask}

var currentAction : PawnAction = PawnAction.Idle

var currentTask : Task = null

var foodNeed : float = 0.4 # 0 = min, 1 = max
var eatSpeed : float = 0.5 
var foodNeedDepleteSpeed : float = 0.1

var inHand;

func _process(delta):
	foodNeed -= foodNeedDepleteSpeed * delta
	hungerBar.value = foodNeed * 100
	
	if currentTask != null:
		DoCurrentTask(delta)
	else:
		if foodNeed < 0.5:
			currentTask = taskManager.RequestTask()

func OnPickupItem(item):
	inHand = item
	itemManager.RemoveItemFromWorld(item)

func OnFinishedSubTask():
	currentAction = PawnAction.Idle
	
	if currentTask.IsFinished():
		currentTask = null

func DoCurrentTask(delta):
	var subTask = currentTask.GetCurrentSubTask()
	
	if currentAction == PawnAction.Idle:
		StartCurrentSubTask(subTask)
	else:
		match subTask.taskType:
			Task.TaskType.WalkTo:
				if charController.HasReachedDestination():
					currentTask.OnReachedDestination()
					OnFinishedSubTask();
			
			Task.TaskType.Eat:
				if inHand.nutrition > 0 and foodNeed < 1:
					inHand.nutrition -= eatSpeed * delta
					foodNeed += eatSpeed * delta
				else:
					print("finished eating food")
					inHand = null
					
					currentTask.OnFinishedSubTask()
					OnFinishedSubTask()

func StartCurrentSubTask(subTask):
	print("Starting subtask: " + Task.TaskType.keys()[subTask.taskType])
	
	match subTask.taskType:
		Task.TaskType.FindItem:
			var targetItem = itemManager.FindNearestItem(subTask.targetItemType, charController.position) # might cause problem in the future with location
			if targetItem == null:
				print("no item, force task to finish")
				currentTask.Finish()
			else:
				currentTask.OnFoundItem(targetItem)
				
			OnFinishedSubTask()
			
		Task.TaskType.WalkTo:
			charController.SetMoveTarget(subTask.targetItem.position)
			currentAction = PawnAction.DoingSubTask
			
		Task.TaskType.Pickup:
			OnPickupItem(subTask.targetItem)
			currentTask.OnFinishedSubTask()
			OnFinishedSubTask()
			
		Task.TaskType.Eat:
			currentAction = PawnAction.DoingSubTask
