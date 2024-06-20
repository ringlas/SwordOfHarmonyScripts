class_name  StatModifier

var value: int
var source: Variant

func _init(_value: int, _source: Variant) -> void:
	self.value = _value
	self.source = _source


func duplicate() -> StatModifier:
	var stat_mod: StatModifier = StatModifier.new(value, source)
	return stat_mod
