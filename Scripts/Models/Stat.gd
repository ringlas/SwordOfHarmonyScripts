class_name Stat

var base_value: int 

var value: int :
	get:
		return _calculate_final_value()

var stat_modifiers: Array[StatModifier] 


func _init(base_value: int) -> void:
	self.base_value = base_value
	self.stat_modifiers = []


func add_modifier(mod: StatModifier) -> void:
	stat_modifiers.append(mod)
	

func remove_all_modifiers() -> void:
	stat_modifiers.clear()


func remove_all_modifiers_from_source(source: Variant) -> void:
	var found_at_index = -1
	for i in stat_modifiers.size():
		if stat_modifiers[i].source == source:
			found_at_index = i
			break
	if found_at_index != -1:
		stat_modifiers.remove_at(found_at_index)


func duplicate() -> Stat:
	var new_stat = Stat.new(base_value)
	for mod in stat_modifiers:
		new_stat.add_modifier(mod.duplicate())
	return new_stat


func  _calculate_final_value() -> int:
	var final_value = base_value
	
	for i in stat_modifiers.size():
		final_value += stat_modifiers[i].value
	
	final_value = maxi(0, final_value)
	return final_value
