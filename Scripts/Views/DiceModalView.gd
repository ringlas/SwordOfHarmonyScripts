class_name DiceModalView
extends Panel

@export var dice_result_label: Label


func _ready() -> void:
	visible = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			roll_dice()


func roll_dice() -> void:
	var dice_results: Dictionary = DiceRoller.roll_dice(1)
	dice_result_label.text = str(dice_results["total"])


func on_close_button_pressed() -> void:
	visible = false
