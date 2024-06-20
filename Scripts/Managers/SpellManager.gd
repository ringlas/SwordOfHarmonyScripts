#class_name SpellManager
extends Node

var spell_data: Dictionary
var spells: Array[Spell]


func _init_data() -> void:
	spell_data = {
		"prayer": {
			"name": tr("Prayer"),
			"spell_effect": SpellEffects.prayer_effect,
			"is_one_time": true,
			"is_auto_cast": true,
			"level": 0,
			"order": 11
		},
		"metamorphosis_black_dragon": {
			"name": tr("METAMORPHOSIS_BLACK_DRAGON"),
			"spell_effect": SpellEffects.metamorphosis_black_dragon,
			"is_one_time": true,
			"is_auto_cast": true,
			"level": 3,
			"order": 10
		},
		"chant_true_magi": {
			"name": tr("CHANT_TRUE_MAGI"),
			"spell_effect": SpellEffects.true_magi_chant,
			"is_one_time": true,
			"is_auto_cast": false,
			"level": 3,
			"order": 9
		},
		"dream_catcher": {
			"name": tr("DREAM_CATCHER"),
			"spell_effect": SpellEffects.dream_catcher_effect,
			"is_one_time": true,
			"is_auto_cast": false,
			"level": 2,
			"order": 8
		},
		"metamorphosis": {
			"name": tr("METAMORPHOSIS"),
			"spell_effect": SpellEffects.metamorphosis,
			"is_one_time": true,
			"is_auto_cast": false,
			"level": 2,
			"order": 7
		},
		"sandstorm": {
			"name": tr("SANDSTORM"),
			"spell_effect": SpellEffects.sandstorm,
			"is_one_time": true,
			"is_auto_cast": false,
			"level": 1,
			"order": 6
		},
		"summon_leprechaun": {
			"name": tr("SUMMON_LEPRECHAUN"),
			"spell_effect": SpellEffects.summon_leprechaun,
			"is_one_time": true,
			"is_auto_cast": false,
			"level": 1,
			"order": 5
		},
		"scale_of_atropos": {
			"name": tr("SCALE_OF_ATROPOS"),
			"spell_effect": SpellEffects.scale_of_atropos_effect,
			"is_one_time": false,
			"is_auto_cast": false,
			"level": 3,
			"order": 4
		},
		"fortuna_bolt": {
			"name": tr("FORTUNA_BOLT"),
			"spell_effect": SpellEffects.fortuna_bolt,
			"is_one_time": false,
			"is_auto_cast": false,
			"level": 2,
			"order": 3
		},
		"ignition": {
			"name": tr("IGNITION"),
			"spell_effect": SpellEffects.ignition_effect,
			"is_one_time": true,
			"is_auto_cast": false,
			"level": 1,
			"order": 2
		},
		"piercing_icicles": {
			"name": tr("PIERCING_ICICLES"),
			"spell_effect": SpellEffects.piercing_icicles_effect,
			"is_one_time": false,
			"is_auto_cast": false,
			"level": 1,
			"order": 1
		},
		"enthrallment": {
			"name": tr("ENTHRALLMENT"),
			"spell_effect": SpellEffects.enthrallment_effect,
			"is_one_time": false,
			"is_auto_cast": false,
			"level": 4,
			"order": 0
		}
	}


func setup() -> void:
	_init_data()
	
	spells = []
	
	for key in spell_data.keys():
		spells.append(create_spell(key))
	
	spells.sort_custom(Callable(TransformHelper.sort_ascending))


func find_spell_by_id(id: String) -> Spell:
	var result: Spell = null
	for spell in spells:
		if spell.id == id:
			result = spell
			break
	return result


func find_spells_by_level(level: int) -> Array[Spell]:
	var result: Array[Spell] = []
	for spell in spells:
		if 0 < spell.level and spell.level <= level:
			result.append(spell)
	result.sort_custom(Callable(sort_by_order))
	return result


func sort_by_order(a: Spell, b: Spell) -> bool:
	if a.order > b.order:
		return true
	return false


func create_spell(id: String) -> Spell:
	assert(id in spell_data, "Invalid spell id: %s" % id)
	var template = spell_data[id]
	var spell: Spell = Spell.new()

	# Set attributes from template
	spell.id = id
	spell.name = template["name"]
	spell.effect = template["spell_effect"]
	spell.is_one_time = template["is_one_time"]
	spell.is_auto_cast = template["is_auto_cast"]
	spell.level = template["level"]
	spell.order = template["order"]

	return spell
