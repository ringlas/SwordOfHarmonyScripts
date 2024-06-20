class_name Hero 
extends Character


const XP_PER_RANK: int = 4


var skills: Array[Skill]
var xp: int
var max_xp: int
var rank: int = 1

var codewords: Array[Codeword]
var items: Array[Item]

var money: int = 0
var inventory_limit: int = 4

var knives: int = 0
var daggers: int = 0

var _skill_tree: SkillTree

signal rank_changed(character: Hero)


func clone() -> Character:
	var cloned_char: Hero = Hero.new()
	
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
	if self.potion:
		cloned_char.potion = self.potion.duplicate()
	if self.throwable:
		cloned_char.throwable = self.throwable.duplicate()
	cloned_char.knives = self.knives
	cloned_char.daggers = self.daggers
	cloned_char.casted_spells.clear()
	cloned_char.status_effects.clear()
	cloned_char.set_skill_tree(self._skill_tree)
	cloned_char.rank = self.rank
	
	return cloned_char


func set_skill_tree(value: SkillTree) -> void:
	_skill_tree = value
	

func has_skill(id: String) -> bool:
	if not _skill_tree: return false
	return _skill_tree.has_skill(id)


func get_spent_skill_points_sum() -> int:
	return _skill_tree.get_spent_skill_points_sum()


func has_spell(id: String) -> bool:
	for i in range(spells.size()):
		if spells[i].id == id:
			return true
	return false


func has_item(id: String) -> bool:
	for i in range(items.size()):
		if items[i].id == id:
			return true
	return false


func has_codeword(id: String) -> bool:
	for i in range(codewords.size()):
		if codewords[i].id == id:
			return true
	return false


func learn_spells(spell_ids: Array[String]) -> void:
	spells = []
	for i in range(spell_ids.size()):
		var spell: Spell = SpellManager.find_spell_by_id(spell_ids[i])
		spells.append(spell)


func set_potion(_potion: Item) -> void:
	self.potion = _potion


func set_throwable(_throwable: Item) -> void:
	self.throwable = _throwable


func alter_rank(value: int) -> void:
	rank += value
	alter_max_xp(value * XP_PER_RANK)
	rank_changed.emit(self)


func alter_xp(value: int) -> void:
	xp += value
	xp = min(xp, max_xp)
	xp = maxi(0, xp)
	print("Точките опитност на героя са %s" % xp)


func alter_max_xp(value: int) -> void:
	max_xp += value
	alter_xp(value)


func set_xp(value: int) -> void:
	xp = value
	max_xp = value


func set_money(value: int) -> void:
	money = value


func set_knives(value: int) -> void:
	knives = value


func set_daggers(value: int) -> void:
	daggers = value
	

func add_item(id: String) -> bool:
	var tmp_item = ItemManager.find_item_by_id(id) as Item
	if tmp_item.type == "Item":
		tmp_item.equip(self)
	items.append(tmp_item)
	return true


func update_items(items_arr: Array[String]) -> void:
	# Remove equipped items that are no longer in our backpack
	if main_hand_weapon and not items_arr.has(main_hand_weapon.id):
		main_hand_weapon.unequip(self)
		main_hand_weapon = null
	
	if off_hand_weapon and not items_arr.has(off_hand_weapon.id):
		off_hand_weapon.unequip(self)
		off_hand_weapon = null
		
	if armour and not items_arr.has(armour.id):
		armour.unequip(self)
		armour = null
	
	if helm and not items_arr.has(helm.id):
		helm.unequip(self)
		helm = null
	
	if potion and not items_arr.has(potion.id):
		potion.unequip(self)
		potion = null
	
	if throwable and not items_arr.has(throwable.id):
		throwable.unequip(self)
		throwable = null
	
	# Unequip items in the inventory that gives passive bonuses
	for i in range(items.size()):
		if items[i].type == "Item":
			items[i].unequip(self)
	
	# Set new items
	items = []
	for i in range(items_arr.size()):
		add_item(items_arr[i])


func get_inventory_limit() -> int:
	var current_limit: int = inventory_limit
	if has_skill("athleticism"):
		current_limit += 5
	if has_item("bag"):
		current_limit += 4
	#if has_item("flying_carpet"):
		#current_limit -= 3
	return current_limit


func get_carried_items() -> int:
	var total_items: int = 0
	total_items += items.size()
	if has_item("flying_carpet"):
		total_items += 2
	return total_items


func is_overburdened() -> bool:
	return get_carried_items() >= get_inventory_limit()


func can_wield_second_weapon() -> bool:
	return has_skill("heroism")


func set_starting_values() -> void:
	set_money(50)
	set_xp(5)
	
	add_item("sword")
	add_item("iron_armour")
	
	armour = ItemManager.find_armour_by_id("iron_armour")
