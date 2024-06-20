class_name SkillTree
extends Node

var skills_db: Dictionary = {}

var _main_controller: MainController

func setup(main_controller: MainController) -> void:
	_main_controller = main_controller


func setup_skills() -> void:
	# Warrior Skills
	skills_db["fury"] = Skill.new("fury", tr("FURY"), 2)
	skills_db["sturdiness"] = Skill.new("sturdiness", tr("STURDINESS"), 1)
	skills_db["weapon_proficiency"] = Skill.new("weapon_proficiency", tr("WEAPON_PROF"), 1)
	skills_db["fortitude"] = Skill.new("fortitude", tr("FORTITUDE"), 2)
	skills_db["athleticism"] = Skill.new("athleticism", tr("ATHLETICISM"), 1)
	
	skills_db["heroism"] = Skill.new("heroism", tr("HEROISM"), 3, 
		[skills_db["fury"], skills_db["sturdiness"], skills_db["weapon_proficiency"], skills_db["athleticism"], skills_db["fortitude"]])
	
	# Mystic Skills
	
	skills_db["medium"] = Skill.new("medium", tr("MEDIUM"), 1)
	skills_db["paranormal_sight"] = Skill.new("paranormal_sight", tr("PARANORMAL"), 1, [skills_db["medium"]])
	skills_db["healing"] = Skill.new("healing", tr("HEALING"), 1, [skills_db["paranormal_sight"]])
	skills_db["levitation"] = Skill.new("levitation", tr("LEVITATION"), 1, [skills_db["healing"]])
	skills_db["asceticism"] = Skill.new("asceticism", tr("ASCETICISM"), 1)
	skills_db["inner_peace"] = Skill.new("inner_peace", tr("INNER_PEACE"), 2, [skills_db["asceticism"]])
	
	skills_db["prayer"] = Skill.new("prayer", tr("PRAYER"), 3, 
		[skills_db["levitation"], skills_db["inner_peace"]])
		
	# Rogue Skills
	skills_db["eloquence"] = Skill.new("eloquence", tr("ELOQUENCE"), 1)
	skills_db["sleight_of_hand"] = Skill.new("sleight_of_hand", tr("SLEIGHT_OF_HAND"), 1)
	skills_db["guile"] = Skill.new("guile", tr("GUILE"), 1)
	skills_db["cruelty"] = Skill.new("cruelty", tr("CRUELTY"), 2, [skills_db["guile"]])
	skills_db["dexterity"] = Skill.new("dexterity", tr("DEXTERITY"), 2, [skills_db["eloquence"], skills_db["sleight_of_hand"]])
	
	skills_db["quick_wits"] = Skill.new("quick_wits", tr("QUICK_WITS"), 3, [skills_db["cruelty"], skills_db["dexterity"]])
	
	# Mage Skills
	skills_db["summon_fossegrim"] = Skill.new("summon_fossegrim", tr("SUMMON_FOSSEGRIM"), 1)
	skills_db["divination"] = Skill.new("divination", tr("DIVINATION"), 2, [skills_db["summon_fossegrim"]])
	skills_db["concentration"] = Skill.new("concentration", tr("CONCENTRATION"), 1)
	skills_db["common_enchantments"] = Skill.new("common_enchantments", tr("COMMON_ENCHANTMENTS"), 1)
	skills_db["rituals"] = Skill.new("rituals", tr("RITUALS"), 2, [skills_db["common_enchantments"]])
	
	skills_db["incantations"] = Skill.new("incantations", tr("INCANTATIONS"), 3, [skills_db["divination"], skills_db["concentration"], skills_db["rituals"]])


func get_skill_by_id(skill_id: String) -> Skill:
	return skills_db[skill_id]


func assign_skill_points(skill_id: String, character: Character) -> bool:
	var skill: Skill = skills_db[skill_id]
	
	if skill.unlocked:
		return false
		
	if character.xp < skill.max_points:
		_main_controller.show_alert(tr("ALERT_NOT_ENOUGH_XP") % skills_db[skill_id].name, Global.AlertType.ERROR)
		return false
	
	if not has_learned_required_skills(skill_id):
		return false
	
	if skill.points < skill.max_points:
		skill.points = skill.max_points
		return true
	
	return false


func has_learned_required_skills(skill_id: String) -> bool:
	var skill: Skill = skills_db[skill_id]
	
	for required_skill in skill.required_skills:
		if not skills_db[required_skill.id].unlocked:
			_main_controller.show_alert(tr("ALERT_UNLOCK_ORDER") % [skill.name, skills_db[required_skill.id].name], Global.AlertType.WARNING)
			return false
	return true


func unlock_skill(skill_id: String) -> bool:
	var skill: Skill = skills_db[skill_id]
	
	if not has_learned_required_skills(skill_id):
		return false
		
	if skill.points < skill.max_points:
		print("Не може да отключиш %s, защото все още не си достигнал %s опитност" % [skill.name, skill.max_points], Global.AlertType.WARNING)
		return false
		
	skill.unlocked = true
	_main_controller.show_alert(tr("ALERT_UNLOCKED") % skill.name, Global.AlertType.SUCCESS)
	return true


func relearn_skill_tree(character: Hero) -> void:
	
	character.fighting_prowess.remove_all_modifiers_from_source(skills_db["weapon_proficiency"])
	if skills_db["weapon_proficiency"].unlocked:
		character.fighting_prowess.add_modifier(StatModifier.new(character.rank, skills_db["weapon_proficiency"]))
		
	character.psychic_ability.remove_all_modifiers_from_source(skills_db["inner_peace"])
	if skills_db["inner_peace"].unlocked:
		character.psychic_ability.add_modifier(StatModifier.new(2, skills_db["inner_peace"]))
		
	character.psychic_ability.remove_all_modifiers_from_source(skills_db["concentration"])
	if skills_db["concentration"].unlocked:
		character.psychic_ability.add_modifier(StatModifier.new(character.rank, skills_db["concentration"]))
		
	character.awareness.remove_all_modifiers_from_source(skills_db["guile"])
	if skills_db["guile"].unlocked:
		character.awareness.add_modifier(StatModifier.new(character.rank, skills_db["guile"]))
	
	character.max_endurance.remove_all_modifiers()
	if skills_db["fortitude"].unlocked:
		character.update_max_endurance(character.rank * Global.XP_PER_RANK, skills_db["fortitude"])
	if skills_db["asceticism"].unlocked:
		character.update_max_endurance(8, skills_db["asceticism"])
	
	# We are changing the max endurance based on rank here which is not the best place for it
	# but we already removed all the modifiers...
	var endurance_modifier: int = 0
	for i in range(character.rank):
		var rank: int = i + 1
		match rank:
			1:
				endurance_modifier = 0
			2:
				endurance_modifier = 7
			3: 
				endurance_modifier = 10
			_: 
				endurance_modifier = 5
		character.update_max_endurance(endurance_modifier, self)
		
	character.armour_class = 0
	if skills_db["sturdiness"].unlocked:
		character.armour_class = 2
		
	character.character_stats_updated.emit()


func has_skill(id: String) -> bool:
	return skills_db[id].unlocked


func reset_skills(character: Hero) -> void:
	for skill in skills_db.values():
		character.xp += skill.points
		skill.points = 0
		skill.unlocked = false
	
	relearn_skill_tree(character)
	_main_controller.show_alert(tr("ALERT_SKILL_TREE_RESET"), Global.AlertType.WARNING)


func get_spent_skill_points_sum() -> int:
	var sum: int = 0
	for skill in skills_db.values():
		sum += (skill as Skill).points
	return sum
