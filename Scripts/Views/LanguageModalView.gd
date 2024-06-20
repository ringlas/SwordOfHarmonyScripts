class_name LanguageModalView
extends Panel


func _ready() -> void:
	visible = true if LocalStorage.get_lang() == LocalStorage.LANGUAGE_NONE else false
