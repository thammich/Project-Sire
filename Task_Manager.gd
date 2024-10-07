extends Node

class_name TaskManager

func RequestTask():
	# generate find and eat food task
	var task = Task.new()
	task.InitFindAndEatFoodTask()
	return task
	
	
