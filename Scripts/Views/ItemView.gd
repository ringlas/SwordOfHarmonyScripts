class_name ItemView
extends CheckBox

@export var id: String

var selector_view: SelectorView


func _on_check_box_press(toggled_on: bool) -> void:
	if selector_view:
		selector_view.handle_checked(self)
