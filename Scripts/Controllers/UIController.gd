class_name UIController
extends CanvasLayer

@export var character_sheet_view : CharacterSheetView
@export var skills_view: SkillsView
@export var combat_view: CombatView

var views: Array[View]


func _ready() -> void:
	views.append(character_sheet_view)
	views.append(skills_view)
	views.append(combat_view)
	_show_view(character_sheet_view)


func _show_view(view) -> void:
	for v in views:
		if v == view:
			v.visible = true
		else:
			v.visible = false


func _on_char_sheet_btn_pressed() -> void:
	_show_view(character_sheet_view)


func _on_skills_btn_pressed() -> void:
	_show_view(skills_view)


func _on_combat_btn_pressed() -> void:
	_show_view(combat_view)
