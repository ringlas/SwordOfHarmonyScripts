class_name Character

var name: String

var fighting_prowess: Stat
var psychic_ability: Stat
var awareness: Stat

var endurance: int
var max_endurance: Stat

var armour_class: int
var damage_dice: int = 0
var damage_modifier: int = 0

var main_hand_weapon: Weapon
var off_hand_weapon: Weapon
var armour: Armour
var helm: Armour
var potion: Item
var throwable: Item

var spells: Array[Spell]
var casted_spells: Array[Spell]
var status_effects: Array[String]


signal character_stats_updated


func clone() -> Character:
	var cloned_char: Character = Character.new()
	
	cloned_char.name = self.name
	cloned_char.fighting_prowess = self.fighting_prowess.duplicate()
	cloned_char.psychic_ability = self.psychic_ability.duplicate()
	cloned_char.awareness = self.awareness.duplicate()
	cloned_char.endurance = self.endurance
	cloned_char.max_endurance = self.max_endurance.duplicate()
	if self.main_hand_weapon:
		cloned_char.main_hand_weapon = self.main_hand_weapon.duplicate()
	if self.off_hand_weapon:
		cloned_char.off_hand_weapon = self.off_hand_weapon.duplicate()
	cloned_char.armour_class = self.armour_class
	cloned_char.damage_dice = self.damage_dice
	cloned_char.damage_modifier = self.damage_modifier
	cloned_char.armour = self.armour
	cloned_char.spells = self.spells
	cloned_char.potion = self.potion.duplicate()
	cloned_char.throwable = self.throwable.duplicate()
	cloned_char.casted_spells.clear()
	cloned_char.status_effects.clear()
	
	return cloned_char


func alter_endurance(value: int) -> void:
	endurance += value
	endurance = min(endurance, max_endurance.value)
	endurance = max(endurance, 0)


func update_max_endurance(value: int, source: Variant) -> void:
	max_endurance.add_modifier(StatModifier.new(value, source))
	alter_endurance(value)


func get_usable_potion() -> Item:	
	return potion


func get_usable_throwable() -> Item:
	return throwable as Item


func _calculate_defence() -> int:
	var result: int = armour_class
	if armour:
		result += armour.defence
	if helm:
		result += helm.defence
	return result


func _perform_attack(weapon: Weapon, target: Character) -> void:
	
	# If the character is not attacking with a weapon, use its base stats
	if not weapon:
		weapon = Weapon.new("unarmed", tr("THEIR_WEAPON"), self.damage_dice, self.damage_modifier)
	
	var leprechaun_used: bool = false
	var number_of_attack_dice = 2
	if _has_status_effect("sandstorm"):
		number_of_attack_dice += 1
		Logger.log(tr("SANDSTORM_EFFECT") % self.name)
		
	var dice_results: Dictionary = DiceRoller.roll_dice(number_of_attack_dice)
	# Re-roll for Leprechaun
	if self is Hero and (_has_status_effect("summon_leprechaun") and not leprechaun_used):
		if dice_results["total"] > self.fighting_prowess.value:
			Logger.log(tr("LEPRECHAUN_EFFECT") % [TextHelper.array_to_string(dice_results["rolls"])])
			dice_results = DiceRoller.roll_dice(number_of_attack_dice)
			leprechaun_used = true
	
	var attack_roll: int = dice_results["total"]
	var message: String = ""
	
	if target is Hero:
		if (target as Hero).has_skill("dexterity"):
			var attack_reducement: int = ceili(target.awareness.value / 2)
			attack_roll += attack_reducement
			message = tr("DEXTERITY_EFFECT")
			Logger.log(message % attack_reducement)
	
	# Check if attack misses
	if attack_roll > self.fighting_prowess.value:
		message = tr("MISS_ATTACK")
		Logger.log(message % [self.name, attack_roll, self.fighting_prowess.value])
		return
	
	message = tr("ATTACK")
	Logger.log(message % [self.name, target.name, weapon.name, attack_roll, TextHelper.array_to_string(dice_results["rolls"]), self.fighting_prowess.value])
		
	var damage_results: Dictionary = weapon.roll_damage()
	
	# Re-roll for Leprechaun
	if self is Hero and (_has_status_effect("summon_leprechaun") and not leprechaun_used):
		if DiceRoller.is_roll_lower_than_avg(damage_results["roll_details"]):
			Logger.log(tr("LEPRECHAUN_EFFECT_II") % [TextHelper.array_to_string(damage_results["roll_details"]["rolls"])])
			damage_results = weapon.roll_damage()
			leprechaun_used = true
	
	var damage: int = damage_results["damage"]
	
	if self is Hero:
		var damage_boost: int = 0
		var skill_boosters: Array[String] = []
		if (self as Hero)._has_status_effect("opiath"):
			damage_boost = DiceRoller.roll_dice(1)["total"]
			skill_boosters.append(tr("OPIATE"))
		if (self as Hero).has_skill("fury"):
			damage_boost = DiceRoller.roll_dice(1)["total"]
			skill_boosters.append(tr("FURY"))
		if (self as Hero).has_skill("cruelty"):
			damage_boost = (self as Hero).rank
			skill_boosters.append(tr("CRUELTY"))
		if self._has_status_effect("metamorphosis"):
			damage_boost = self.awareness.value
			skill_boosters.append(tr("METAMORPHOSIS"))
		if damage_boost > 0:
			damage += damage_boost
			message = tr("DAMAGE_BOOST")
			Logger.log(message % [damage_boost, TextHelper.array_to_string(skill_boosters)])
	
	if target._calculate_defence() > 0: # If target has armour, reduce its armour class from the damage
		damage -= target._calculate_defence()
		message = tr("DAMAGE_WEAPON")
		
		Logger.log(message % [
			damage_results["damage"], 
			TextHelper.array_to_string(damage_results["roll_details"]["rolls"]), 
			damage_results["modifier"], 
			target._calculate_defence()])
	
	if target._has_status_effect("prayer"):
		damage -= damage/2
		Logger.log(tr("PRAYER_EFFECT"))
	
	damage = maxi(damage , 0) # Prevent negative damage
	target.alter_endurance(-damage) # Reduce hit points
	
	message = tr("DAMAGE_SUCCESS")
	Logger.log(message % [
		self.name,
		target.name,
		damage,
		target.endurance
	])


func _throw_weapon(weapon: Weapon, target: Character) -> void:

	var dice_results: Dictionary = DiceRoller.roll_dice(2)
	var attack_roll: int = dice_results["total"]
	var message: String = ""
	
	# Check if attack misses
	if attack_roll > self.awareness.value:
		message = tr("THROWABLE_MISS")
		Logger.log(message % [self.name, weapon.name, attack_roll, self.awareness.value])
		return
	
	message = tr("THROWABLE_ATTACK")
	Logger.log(message % [self.name, weapon.name, attack_roll, TextHelper.array_to_string(dice_results["rolls"]), self.awareness.value])
	
	var damage_results: Dictionary = weapon.roll_damage()
	var damage: int = damage_results["damage"]
	
	if target._calculate_defence() > 0: # If target has armour, reduce its armour class from the damage
		damage -= target._calculate_defence()
		message = tr("DAMAGE_WEAPON")
		
		Logger.log(message % [
			damage_results["damage"], 
			TextHelper.array_to_string(damage_results["roll_details"]["rolls"]), 
			damage_results["modifier"], 
			target._calculate_defence()])
	
	damage = maxi(damage , 0) # Prevent negative damage
	target.alter_endurance(-damage) # Reduce hit points
	
	message = tr("DAMAGE_SUCCESS")
	Logger.log(message % [
		self.name,
		target.name,
		damage,
		target.endurance
	])


func _get_spell(name: String) -> Spell:
	for i in spells.size():
		if spells[i]["name"] == name:
			return spells[i]
	return null


func _has_casted_spell(name: String) -> bool:
	for i in casted_spells.size():
		if casted_spells[i]["name"] == name:
			return true
	return false


func _has_status_effect(name: String) -> bool:
	for i in status_effects.size():
		if status_effects[i] == name:
			return true
	return false


func _has_usable(id: String) -> bool:
	if potion:
		if potion.id == id:
			return true 
	if throwable:
		if throwable.id == id:
			return true
	return false


func remove_usable(id: String) -> void:
	if potion.id == id:
		potion = null
	elif throwable.id == id:
		throwable = null


func _apply_chant_status_effect() -> void:
	var dice_results: Dictionary = DiceRoller.roll_dice(3)
	var dice_roll: int = dice_results["total"]
	
	if dice_roll <= self.psychic_ability.value:
		Logger.log(tr("RESIST_CHANT") % [self.name, dice_roll])
		return
  
	self.psychic_ability.add_modifier(StatModifier.new(-1, "chant"))
  
	Logger.log(tr("CHANT_EFFECT") % self.name)


func _apply_enthrallment_status_effect() -> void:
	var dice_results: Dictionary = DiceRoller.roll_dice(2)
	var dice_roll: int = dice_results["total"]
	
	if dice_roll <= self.psychic_ability.value:
		Logger.log(tr("RESIST_ENTHRALLMENT") % [self.name, dice_roll])
		if status_effects.has("enthrallment"):
			status_effects.erase("enthrallment")
		return
  
	status_effects.append("mindless")
	Logger.log(tr("ENTHRALLMENT_EFFECT") % [self.name, dice_roll])


func _apply_opiath_status_effect() -> void:
	var dice_results: Dictionary = DiceRoller.roll_dice(2)
	var dice_roll: int = dice_results["total"]
	
	var damage = maxi(dice_roll , 0) # Prevent negative damage
	self.alter_endurance(-damage) # Reduce hit points
	
	var message = tr("OPIATE_EFFECT")
	Logger.log(message % [
		self.name,
		damage,
		self.endurance
	])


func _apply_healing_effect() -> void:
	var dice_results: Dictionary = DiceRoller.roll_dice(2)
	var dice_roll: int = dice_results["total"]
	
	var heal = dice_roll 
	self.alter_endurance(heal) 
	
	var message = tr("POTION_EFFECT")
	Logger.log(message % [
		self.name,
		heal,
		self.endurance
	])


func choose_action(target: Character) -> void:
	if _has_status_effect("chant"):
		_apply_chant_status_effect()
	
	if _has_status_effect("enthrallment"):
		_apply_enthrallment_status_effect()
	
	if _has_status_effect("mindless"):
		return
		
	for i in spells.size():
		if target._has_status_effect("enthrallment"):
			break
		if _has_status_effect("metamorphosis") or _has_status_effect("metamorphosis_black_dragon"):
			break
		if spells[i].is_one_time and _has_casted_spell(spells[i].name):
			continue
		if spells[i].is_auto_cast:
			spells[i].use(self, target)
			casted_spells.append(spells[i])
			continue
		var attemp_cast: bool = spells[i].cast(self, target)
		if attemp_cast:
			casted_spells.append(spells[i])
		return
	
	if _has_status_effect("darii"):
		Logger.log(tr("DARIUS_MISS_TURN") % [self.name])
		return
	
	if self.name.contains(tr("DARIUS")):
		return
	
	self.attack(target)
	
	self.use_throwable_weapon(target)


func use_throwable_weapon(target: Character) -> void:
	if self._has_usable("throwing_dagger") and (self as Hero).daggers > 0 and target.is_alive():
		self._throw_weapon(ItemManager.find_weapon_by_id("throwing_dagger"), target)
		(self as Hero).daggers -= 1
		return
	
	if self._has_usable("dagger") and (self as Hero).knives > 0  and target.is_alive():
		self._throw_weapon(ItemManager.find_weapon_by_id("dagger"), target)
		(self as Hero).knives -= 1
		return


func attack(target: Character) -> void:
	if self.potion:
		if self._has_usable("opiath") and not _has_status_effect("opiath"):
			self.remove_usable("opiath")
			status_effects.append("opiath")
			self.fighting_prowess.add_modifier(StatModifier.new(1, "opiath"))
			Logger.log(tr("OPIATE_APPLIED_EFFECT") % [self.name])
	
	_perform_attack(main_hand_weapon, target)
	
	if not target.is_alive():
		return
	
	if self is Hero:
		if (self as Hero).has_skill("quick_wits"):
			var dice_roll: Dictionary = DiceRoller.roll_dice(1)
			var dice_result: int = dice_roll["total"]
			if dice_result == 5 or dice_result == 6:
				Logger.log(tr("QUICK_WITS_EFFECT") % [self.name, dice_result])
				_perform_attack(main_hand_weapon, target)	
				
	if not off_hand_weapon:
		return
		
	Logger.log(tr("OFFHAND_WEAPON_ATTACK") % self.name)
	_perform_attack(off_hand_weapon, target)


func is_alive() -> bool:
	if status_effects.has("mindless"):
		return false
	return endurance > 0 and psychic_ability.value > 0


func set_endurance(value: int) -> void:
	endurance = min(value, max_endurance.value)
	character_stats_updated.emit()
