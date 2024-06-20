#class_name LocalStorage
extends Node

const LANGUAGE: String = "lang"
const LANGUAGE_NONE: String = "none"

# Language

func set_lang(value: String) -> void:
	PlayerPrefs.set_pref(LANGUAGE, value)


func get_lang() -> String:
	return PlayerPrefs.get_pref(LANGUAGE, LANGUAGE_NONE)


func delete_lang() -> void:
	return PlayerPrefs.delete_pref(LANGUAGE)

