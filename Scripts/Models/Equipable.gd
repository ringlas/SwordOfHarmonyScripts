class_name Equipable

var id: String

var fighting_prowess_bonus: int = 0
var psychic_bonus: int = 0
var awareness_bonus: int = 0

var equipment_type: String


func equip(character: Character) -> void:
	character.fighting_prowess.add_modifier(StatModifier.new(fighting_prowess_bonus, self))
	character.psychic_ability.add_modifier(StatModifier.new(psychic_bonus, self))
	character.awareness.add_modifier(StatModifier.new(awareness_bonus, self))
	character.character_stats_updated.emit()


func unequip(character: Character) -> void:
	character.fighting_prowess.remove_all_modifiers_from_source(self)
	character.psychic_ability.remove_all_modifiers_from_source(self)
	character.awareness.remove_all_modifiers_from_source(self)
	character.character_stats_updated.emit()


func get_simple_name() -> String:
	if not self.name:
		return ""
	var name = self.name
	var index = name.find("(")
	if index == -1:
		# If no '(' is found, return the original string
		return name
	return name.substr(0, index).strip_edges()  # Use strip_edges() to remove any trailing whitespace


func set_equipment_type(type_id: String) -> void:
	equipment_type = type_id
