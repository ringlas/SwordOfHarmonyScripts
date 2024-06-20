extends Node2D
#class_name DiceRoller

var rng = RandomNumberGenerator.new()

func roll_dice(number_of_dice: int) -> Dictionary:
	var total: int = 0
	var rolls: Array = []
	
	for i in number_of_dice:
		var my_random_number = rng.randi_range(1, 6)
		rolls.append(my_random_number)
		total += my_random_number
	
	return {"total": total, "rolls": rolls}


func is_roll_lower_than_avg(dice_results: Dictionary) -> bool:
	var avg_dice: Array[int] = [3, 7, 10, 14, 17, 21, 24, 28]
	var index:int = (dice_results["rolls"] as Array).size() - 1
	
	if dice_results["total"] < avg_dice[index] - 1: 
		return true
	
	return false
