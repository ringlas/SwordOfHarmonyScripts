class_name Spell

var id: String
var name: String
var effect: Callable
var is_one_time: bool
var is_auto_cast: bool
var level: int
var order: int


func cast(caster:Character, target: Character) -> bool:
	var roll_results: Dictionary = DiceRoller.roll_dice(2)
	var roll_total:int = roll_results["total"]
	
	if self.id == "enthrallment":
		roll_total += 5
	
	Logger.log(tr("CASTS_SPELL") % [
		caster.name,
		self.name,
		caster.psychic_ability.value,
		roll_total
	])
	
	if roll_total > caster.psychic_ability.value:
		Logger.log(tr("CAST_FAILED") % caster.name)
		return false
	
	effect.call(self, caster, target)
	return true


func use(caster:Character, target: Character) -> void:
	effect.call(self, caster, target)
