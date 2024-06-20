extends Node
#class_name Logger

var is_logging: bool = true
var messages: Array[String]

func log(message: String) -> void:
	if is_logging:
		messages.append(message)
		print_rich(message)


func clear_log() -> void:
	messages = []
