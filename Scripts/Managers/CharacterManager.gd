#CharacterManager
extends Node

var characters_data: Dictionary 


func init_data() -> void:
	characters_data = {
		"0": {
			"name": tr("THE_HERO"),
			"fighting_prowess": 8,
			"psychic_ability": 7,
			"awareness": 7,
			"endurance": 30,
			"max_endurance": 30,
			"main_hand_weapon": "sword",
			"armour_class": 0,
		},
		"193": {
			"name": tr("WARLOCK"),
			"fighting_prowess": 10,
			"psychic_ability": 11,
			"awareness": 6,
			"endurance": 65,
			"max_endurance": 65,
			"damage_dice": 7,
			"damage_modifier": 0,
			"armour_class": 3,
		},
		"194": {
			"name": tr("WARLOCK"),
			"fighting_prowess": 10,
			"psychic_ability": 11,
			"awareness": 6,
			"endurance": 25,
			"max_endurance": 25,
			"damage_dice": 3,
			"damage_modifier": 0,
			"armour_class": 3,
		},
		"180": {
			"name": tr("TROLL"),
			"fighting_prowess": 9,
			"psychic_ability": 3,
			"awareness": 4,
			"endurance": 65,
			"max_endurance": 65,
			"armour_class": 0,
			"damage_dice": 5,
			"damage_modifier": 0
		},
		"107": {
			"name": tr("MUNGODAN"),
			"fighting_prowess": 8,
			"psychic_ability": 7,
			"awareness": 7,
			"endurance": 25,
			"max_endurance": 25,
			"armour_class": 2,
			"damage_dice": 2,
			"damage_modifier": 2
		},
		"14": {
			"name": tr("NINJA"),
			"fighting_prowess": 8,
			"psychic_ability": 7,
			"awareness": 9,
			"endurance": 11,
			"max_endurance": 11,
			"armour_class": 0,
			"damage_dice": 1,
			"damage_modifier": 2
		},
		"17": {
			"name": tr("NINJA"),
			"fighting_prowess": 7,
			"psychic_ability": 5,
			"awareness": 9,
			"endurance": 16,
			"max_endurance": 16,
			"armour_class": 0,
			"damage_dice": 1,
			"damage_modifier": 2
		},
		"25": {
			"name": tr("UNDEAD_NINJA"),
			"fighting_prowess": 7,
			"psychic_ability": 1,
			"awareness": 1,
			"endurance": 12,
			"max_endurance": 12,
			"armour_class": 0,
			"damage_dice": 1,
			"damage_modifier": 2
		},
		"38": {
			"name": tr("UNDEAD_NINJA"),
			"fighting_prowess": 7,
			"psychic_ability": 1,
			"awareness": 1,
			"endurance": 12,
			"max_endurance": 12,
			"armour_class": 0,
			"damage_dice": 1,
			"damage_modifier": 2
		},
		"95": {
			# късо копие
			"name": tr("MERCANIAN"),
			"fighting_prowess": 8,
			"psychic_ability": 4,
			"awareness": 5,
			"endurance": 20,
			"max_endurance": 20,
			"armour_class": 1,
			"damage_dice": 2,
			"damage_modifier": 0
		},
		"96": {
			# късо копие
			"name": tr("DARIUS"),
			"fighting_prowess": 3,
			"psychic_ability": 9,
			"awareness": 6,
			"endurance": 25,
			"max_endurance": 25,
			"armour_class": 0,
			"damage_dice": 1,
			"damage_modifier": 0
		},
		"140": {
			# късо копие
			"name": tr("PIRATE"),
			"fighting_prowess": 9,
			"psychic_ability": 6,
			"awareness": 10,
			"endurance": 20,
			"max_endurance": 20,
			"armour_class": 1,
			"damage_dice": 2,
			"damage_modifier": 0
		},
		"141": {
			# късо копие
			"name": tr("PIRATE"),
			"fighting_prowess": 9,
			"psychic_ability": 6,
			"awareness": 8,
			"endurance": 22,
			"max_endurance": 22,
			"armour_class": 1,
			"damage_dice": 2,
			"damage_modifier": -1
		},
		"143": {
			# късо копие
			"name": tr("PIRATE"),
			"fighting_prowess": 9,
			"psychic_ability": 6,
			"awareness": 8,
			"endurance": 18,
			"max_endurance": 18,
			"armour_class": 0,
			"damage_dice": 2,
			"damage_modifier": -2
		},
		"144": {
			# късо копие
			"name": tr("PIRATE"),
			"fighting_prowess": 8,
			"psychic_ability": 4,
			"awareness": 10,
			"endurance": 23,
			"max_endurance": 23,
			"armour_class": 0,
			"damage_dice": 2,
			"damage_modifier": 0
		}
	}


func create_character(episode_id: String) -> Character:
	if not (episode_id in characters_data):
		return null
		
	var template = characters_data[episode_id]
	var character
	
	if episode_id == "0":
		character = Hero.new()
	else:
		character = Character.new()
		
	# Set attributes from template
	character.name = template["name"]
	character.fighting_prowess = Stat.new(template["fighting_prowess"])
	character.psychic_ability = Stat.new(template["psychic_ability"])
	character.awareness = Stat.new(template["awareness"])
	character.endurance = template["endurance"]
	character.max_endurance = Stat.new(template["max_endurance"])
	character.armour_class = template["armour_class"]
	character.damage_dice = template.get("damage_dice", 0)
	character.damage_modifier = template.get("damage_modifier", 0)
	
	var weapon_id: String = template.get("main_hand_weapon", "")
	if weapon_id != "":
		character.main_hand_weapon = ItemManager.find_weapon_by_id(weapon_id)
	
	weapon_id = template.get("off_hand_weapon", "")
	if weapon_id != "":
		character.off_hand_weapon = ItemManager.find_weapon_by_id(weapon_id)
	
	if episode_id == "193":
		character.main_hand_weapon = Weapon.new("sword_harmony", tr("SWORD_HARMONY"), 7, 0)
	
	if episode_id == "194":
		character.main_hand_weapon = Weapon.new("white_sword", tr("BLADE_FORGIVENESS"), 4, 3)
		character.off_hand_weapon = Weapon.new("black_sword", tr("BLADE_VENGEANCE"), 4, 3)
		
	## Handling arrays like spells
	#if "armour" in template:
		#for armour in template["armour"]:
			#character.armour.append(armour)
#
	## Handling arrays like spells
	#if "spells" in template:
		#for spell in template["spells"]:
			#character.spells.append(spell)
			
	return character
