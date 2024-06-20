#class_name UsableItemsView
#extends Panel
#
#@export var main_controller: MainController
#
#@export var knives_label: Label
#@export var daggers_label: Label
#
#@export var checkboxes: Array[ItemView]
#
#var _character: Hero
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
			#if event.is_pressed():
				#if event.keycode == KEY_ESCAPE:
					#_on_close_btn_press()
#
#
#func setup(character: Hero) -> void:
	#_character = character
	#_character.character_stats_updated.connect(Callable(refresh_view))
#
#
#func refresh_view() -> void:
	#knives_label.text = str(_character.knives)
	#daggers_label.text = str(_character.daggers)
	#
	#for checkbox in checkboxes:
		#checkbox.set_pressed_no_signal(false)
	#
	#for checkbox in checkboxes:
		#for usable_item in _character.usables:
			#if checkbox.id == usable_item.id:
				#checkbox.set_pressed_no_signal(true)
#
#
#func _on_knives_btn_pressed() -> void:
	#main_controller.on_update_char_stats_press(Global.ModalInputType.KNIVES)
#
#
#func _on_daggers_btn_pressed() -> void:
	#main_controller.on_update_char_stats_press(Global.ModalInputType.DAGGERS)
#
#
#func _on_close_btn_press() -> void:
	#visible = false
#
#
#func _on_apply_btn_pressed() -> void:
	#var params: Array[String] = []
	#for checkbox in checkboxes:
		#if checkbox.button_pressed:
			#params.append(checkbox.id)
			#
	#main_controller.on_apply_usables_button_press(params)
	#visible = false
