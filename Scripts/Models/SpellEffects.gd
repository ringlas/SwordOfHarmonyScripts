class_name SpellEffects

const DREAM_CATCHER_PSYCHIC_REDUCTION = 3
const IGNITION_WEAPON_DICE = 2

static func sandstorm(spell: Spell, caster: Character, target: Character) -> void:
	target.status_effects.append(spell.id)
	Logger.log(spell.tr("USES_SPELL") % [caster.name, spell.name])	


static func ignition_effect(spell: Spell, caster: Character, target: Character) -> void:
	var weapon: Weapon = (caster as Hero).main_hand_weapon
	weapon.dice += IGNITION_WEAPON_DICE
	(caster as Hero).main_hand_weapon = weapon
	Logger.log(spell.tr("IGNITION_CAST") % [
		caster.name,
		spell.name
	])


static func dream_catcher_effect(spell: Spell, caster: Character, target: Character) -> void:
	target.psychic_ability.add_modifier(StatModifier.new(-DREAM_CATCHER_PSYCHIC_REDUCTION, spell))
	caster.psychic_ability.add_modifier(StatModifier.new(DREAM_CATCHER_PSYCHIC_REDUCTION, spell))
	Logger.log(spell.tr("DREAM_CATCHER_CAST") % [
		caster.name,
		spell.name,
		target.name,
		DREAM_CATCHER_PSYCHIC_REDUCTION,
		DREAM_CATCHER_PSYCHIC_REDUCTION,
		caster.psychic_ability.value
	])


static func fortuna_bolt(spell: Spell, caster: Character, target: Character) -> void:
	var dice_results: Dictionary = DiceRoller.roll_dice(3)
	var damage: int = dice_results["total"] + 3 - target.armour_class
	var is_double_damage: bool = false
	
	var dice_rolls: Array = dice_results["rolls"]
	if(TextHelper.contains_duplicates(dice_rolls)):
		is_double_damage = true
		damage *= 2
	
	target.alter_endurance(-damage) 
	
	var message: String = spell.tr("FORTUNA_BOLT_CAST")
	if is_double_damage:
		message += spell.tr("DOUBLE_DAMAGE")
		
	Logger.log(message % [
		caster.name,
		spell.name,
		damage,
		target.name,
		target.endurance,
		TextHelper.array_to_string(dice_rolls)
	])


static func metamorphosis(spell: Spell, caster: Character, target: Character) -> void:
	caster.status_effects.append(spell.id)
	caster.awareness.add_modifier(StatModifier.new(2, spell))
	caster.fighting_prowess.add_modifier(StatModifier.new(2, spell))
	print(caster.fighting_prowess.base_value)
	print(caster.fighting_prowess.value)
	print(caster.fighting_prowess.stat_modifiers.size())
	var message: String = spell.tr("METAMORPHOSIS_TIGER_CAST")
	Logger.log(message)


static func metamorphosis_black_dragon(spell: Spell, caster: Character, target: Character) -> void:
	caster.status_effects.append(spell.id)
	caster.awareness.remove_all_modifiers()
	caster.awareness.base_value = 10
	caster.fighting_prowess.remove_all_modifiers()
	caster.fighting_prowess.base_value = 12
	caster.psychic_ability.remove_all_modifiers()
	caster.psychic_ability.base_value = 11
	caster.main_hand_weapon = Weapon.new("breth_of_fire", spell.tr("DRAGONS_BREATH_WEAPON"), 7, 0)
	caster.off_hand_weapon = null
	caster.armour_class = 4
	caster.armour = null
	caster.helm = null
	caster.update_max_endurance(50, spell)
	var message: String = spell.tr("METAMORPHOSIS_BLACK_DRAGON_CAST")
	Logger.log(message)


static func piercing_icicles_effect(spell: Spell, caster: Character, target: Character) -> void:
	var dice_results: Dictionary = DiceRoller.roll_dice(2)
	var damage: int = dice_results["total"] + 3 - target.armour_class
	
	target.alter_endurance(-damage) 
	target.awareness.add_modifier(StatModifier.new(-1, spell))
	
	Logger.log(spell.tr("ICICLES_CAST") % [
		caster.name,
		spell.name,
		damage,
		target.name,
		target.endurance
	])


static func scale_of_atropos_effect(spell: Spell, caster: Character, target: Character) -> void:
	var difference: int = maxi(0, caster.psychic_ability.value - target.psychic_ability.value)
	var dice_results: Dictionary = DiceRoller.roll_dice(difference)
	var damage: int = dice_results["total"]
	var heal:int = ceili(damage / 2.0)
	
	target.alter_endurance(-damage) 
	caster.alter_endurance(heal)
	
	Logger.log(spell.tr("SCALE_OF_ATROPOS_CAST") % [
		caster.name,
		spell.name,
		damage,
		target.name,
		target.endurance,
		heal,
		caster.endurance
	])


static func summon_leprechaun(spell: Spell, caster: Character, target: Character) -> void:
	caster.status_effects.append(spell.id)
	Logger.log(spell.tr("USES_SPELL") % [caster.name, spell.name])


static func true_magi_chant(spell: Spell, caster: Character, target: Character) -> void:
	target.status_effects.append(spell.id)
	Logger.log(spell.tr("USES_SPELL") % [caster.name, spell.name])


static func prayer_effect(spell: Spell, caster: Character, target: Character) -> void:
	caster.status_effects.append(spell.id)
	Logger.log(spell.tr("USES_SPELL") % [caster.name, spell.name])


static func enthrallment_effect(spell: Spell, caster: Character, target: Character) -> void:
	target.status_effects.append(spell.id)
	Logger.log(spell.tr("ENTHRALLMENT_CAST_COMPLETE") % [caster.name, spell.name])
