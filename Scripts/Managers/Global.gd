#class_name Global
extends Node

signal lang_updated

var MAX_RANK_CAP = 5
var XP_PER_RANK = 5

enum SelectorType {
	WEAPONS,
	HELMS,
	ARMOUR,
	POTIONS,
	THROWABLES,
	CODEWORDS,
	ITEMS,
	SPELLS,
	COMBAT_ITEMS
}

enum ModalInputType {	
	ENDURANCE,
	RANK,
	FIGHT,
	AWANRESS,
	PSYCH,
	MONEY,
	XP,
	ENEMY,
	KNIVES,
	DAGGERS,
	EMPTY
}

enum AlertType {
	ERROR,
	SUCCESS,
	WARNING
}

var codewords: Array[Codeword] 


func _ready() -> void:
	if LocalStorage.get_lang() != LocalStorage.LANGUAGE_NONE:
		update_lang(LocalStorage.get_lang())


func setup_codewords() -> void:
	codewords = [
		Codeword.new("boat", tr("CODEWORD_BOAT")), 
		Codeword.new("prepared", tr("CODEWORD_PREPARED")), 
		Codeword.new("generous", tr("CODEWORD_GENEROSITY")), 
		Codeword.new("healer", tr("CODEWORD_HEALER")), 
		Codeword.new("wall", tr("CODEWORD_WALL")), 
		Codeword.new("gate", tr("CODEWORD_GATE")), 
		Codeword.new("chicken", tr("CODEWORD_HEN")),
		Codeword.new("mercy", tr("CODEWORD_MERCY")),
		Codeword.new("danger", tr("CODEWORD_DANGER")),
		Codeword.new("mask", tr("CODEWORD_MASK")),
	]


func get_codewords() -> Array[Codeword]:
	codewords.sort_custom(Callable(TransformHelper.sort_ascending))
	return codewords


func find_codeword_by_id(id: String) -> Codeword:
	for codeword in codewords:
		if codeword.id == id:
			return codeword
	
	return null


func update_lang(locale_id: String) -> void:
	LocalStorage.set_lang(locale_id)
	TranslationServer.set_locale(locale_id)
	lang_updated.emit()
