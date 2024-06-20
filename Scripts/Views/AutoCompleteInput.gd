#class_name ModalView
#extends Panel
#
#@export var main_controller: MainController	
#@export var label: Label
#@export var input: LineEdit
#@export var suggestion_button: Button
#@export var suggestion_panel: Panel
#
#var database_arr: Array[String] = ["Бойна секира", "Къс меч", "Кинжал", "Бойна Брадва", "Блестящ меч", "Копие", "Мечът на Хармонията", "Острие от бяло злато", "Острие от черно злато"]
#var current_suggestion: String = ""
#
#
#func _ready() -> void:
	#input.text_changed.connect(Callable(_on_input_text_changed))
	#suggestion_button.pressed.connect(Callable(_on_suggestion_button_pressed))
	#suggestion_button.visible = false
	#suggestion_panel.visible = false
#
#
#func setup_for_items() -> void:
	#database_arr = ItemManager.items
	#
#
#func _on_input_text_changed(new_text: String) -> void:
	#current_suggestion = ""
	#suggestion_button.text = ""
	#suggestion_button.visible = false
	#suggestion_panel.visible = false
	#
	#for word in database_arr:
		##if word.to_lower().begins_with(new_text):
		#if word.to_lower().find(new_text) != -1:
			#current_suggestion = word
			#suggestion_button.text = current_suggestion
			#suggestion_button.visible = true
			#suggestion_panel.visible = true
			#break
#
#
#func _on_suggestion_button_pressed() -> void:
	#if current_suggestion == "":
		#return
	#
	#input.text = current_suggestion
	#suggestion_button.visible = false
	#suggestion_panel.visible = false
#
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and input.has_focus():
		#if suggestion_button.visible:
			#if event.is_pressed():
				#if event.keycode == KEY_ENTER or event.keycode == KEY_DOWN:
					#_on_suggestion_button_pressed()
#
#
#func _on_close_pressed() -> void:
	#visible = false
