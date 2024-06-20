extends TextureRect

@export var endurance_value: Label
@export var fill: TextureProgressBar

func set_fill() -> void:
	var endurance: int = 4
	var endurance_max_value: int = 10
	
	var parts: PackedStringArray = endurance_value.text.split("/")
	
	if parts.size() == 2:
		endurance = int(parts[0])
		endurance_max_value = int(parts[1])
	
	var percentage: float = float(endurance) / float(endurance_max_value)
	percentage = percentage * 100
	
	fill.value = percentage


func _process(delta: float) -> void:
	set_fill()
