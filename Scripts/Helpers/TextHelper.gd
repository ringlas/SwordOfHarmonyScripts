#class_name TextHelper
extends Node

func array_to_string(numbers: Array) -> String:
	var numbers_string: String = ""
	for i in range(numbers.size()):
		numbers_string += str(numbers[i])
		if i < numbers.size() - 1:
			numbers_string += ", "
	return numbers_string


func contains_duplicates(arr: Array) -> bool:
	if arr.size() < 2:
		return false

	for i in range(arr.size()):
		for j in range(i + 1, arr.size()):  
			if arr[i] == arr[j]:
				return true

	return false
