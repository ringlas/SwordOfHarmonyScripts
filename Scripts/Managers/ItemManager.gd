#ItemManager
extends Node

var items_data: Dictionary 

var items: Array[Item]
var weapons: Array[Weapon]
var armours: Array[Armour]


func _init_data() -> void:
	items_data = {
		# Basic items
		"scroll": {
			"name": tr("SCROLL"),
			"type": "Item",
			"equipment_type": "backpack"
		},
		"golden_book": {
			"name": tr("GOLDEN_BOOK"),
			"type": "Item",
			"equipment_type": "backpack"
		},
		"healing_salve": {
			"name": tr("HEALING_SALVE"),
			"type": "Item",
			"equipment_type": "potion"
		},
		"violet_cloth": {
			"name": tr("VIOLET_CLOTH"),
			"type": "Item",
			"equipment_type": "backpack"
		},
		"opiath": {
			"name": tr("OPIATE"),
			"type": "Item",
			"equipment_type": "potion"
		},
		"bag": {
			"name": tr("BAG"),
			"type": "Item",
			"equipment_type": "backpack"
		},
		"flying_carpet": {
			"name": tr("FLYING_CARPET"),
			"type": "Item",
			"equipment_type": "backpack"
		},
		"amulet": {
			"name": tr("AMULET"),
			"type": "Item",
			"psychic": 1,
			"equipment_type": "backpack"
		},
		"herbal_potion": {
			"name": tr("HERBAL_POTION"),
			"type": "Item",
			"equipment_type": "potion"
		},
		"mundugan_herbs": {
			"name": tr("MUGODAN_HERBS"),
			"type": "Item",
			"equipment_type": "backpack"
		},
		"extract_of_silote": {
			"name": tr("SILOTE"),
			"type": "Item",
			"equipment_type": "backpack"
		},
		# Weapons
		"battle_axe": {
			"name": tr("BATTLE_AXE"),
			"type": "Weapon",
			"dmg_dice": 3,
			"modifier": 0,
			"equipment_type": "hand"
		},
		"sword": {
			"name": tr("SWORD"),
			"type": "Weapon",
			"dmg_dice": 2,
			"modifier": 1,
			"equipment_type": "hand"
		},
		"onyx_dagger": {
			"name": tr("ONYX_DAGGER"),
			"type": "Weapon",
			"dmg_dice": 1,
			"modifier": 3,
			"equipment_type": "hand"
		},
		"dagger": {
			"name": tr("DAGGER"),
			"type": "Weapon",
			"dmg_dice": 1,
			"modifier": 0,
			"equipment_type": "throwable"
		},
		"throwing_dagger": {
			"name": tr("THROWING_DAGGER"),
			"type": "Weapon",
			"dmg_dice": 1,
			"modifier": 1,
			"equipment_type": "throwable"
		},
		"spear": {
			"name": tr("SPEAR"),
			"type": "Weapon",
			"dmg_dice": 4,
			"modifier": 3,
			"equipment_type": "hand"
		},
		"ash_tree_staff": {
			"name": tr("STAFF_ASH"),
			"type": "Weapon",
			"dmg_dice": 1,
			"modifier": -1,
			"psychic": 1,
			"equipment_type": "hand"
		},
		"ruby_sceptre": {
			"name": tr("RUBY_SCEPTRE"),
			"type": "Weapon",
			"dmg_dice": 1,
			"modifier": 0,
			"psychic": 2,
			"equipment_type": "hand"
		},
		"scimitar": {
			"name": tr("SCIMITAR"),
			"type": "Weapon",
			"dmg_dice": 1,
			"modifier": 4,
			"equipment_type": "hand"
		},
		"legionnaire_sword": {
			"name": tr("LEGIONNAIRE_SWORD"),
			"type": "Weapon",
			"dmg_dice": 2,
			"modifier": 4,
			"equipment_type": "hand"
		},
		"horg_sword": {
			"name": tr("HORG_SWORD"),
			"type": "Weapon",
			"dmg_dice": 3,
			"modifier": 4,
			"equipment_type": "hand"
		},
		"pirate_scimitar": {
			"name": tr("PIRATE_SCIMITAR"),
			"type": "Weapon",
			"dmg_dice": 2,
			"modifier": 0,
			"equipment_type": "hand"
		},
		"golden_axe": {
			"name": tr("GOLDEN_AXE"),
			"type": "Weapon",
			"dmg_dice": 5,
			"modifier": 2,
			"equipment_type": "hand"
		},
		# Armour
		"iron_armour": {
			"name": tr("IRON_ARMOUR"),
			"type": "Armour",
			"defence": 2,
			"equipment_type": "chest"
		},
		"steel_armour": {
			"name": tr("STEEL_ARMOUR"),
			"type": "Armour",
			"defence": 3,
			"equipment_type": "chest"
		},
		"horned_helm": {
			"name": tr("HORNED_HELM"),
			"type": "Armour",
			"defence": 1,
			"equipment_type": "head"
		},
		"leather_helmet": {
			"name": tr("LEATHER_HELMET"),
			"type": "Armour",
			"defence": 1,
			"equipment_type": "head"
		},
		"winged_helmet": {
			"name": tr("WINGED_HELMET"),
			"type": "Armour",
			"defence": 2,
			"equipment_type": "head"
		},
		"tunic": {
			"name": tr("TUNIC"),
			"type": "Armour",
			"defence": 0,
			"awareness": 3,
			"equipment_type": "chest"
		},
		"tiger_mask": {
			"name": tr("TIGER_MASK"),
			"type": "Armour",
			"defence": 2,
			"fighting_prowess": 1,
			"equipment_type": "head"
		},
	}


func setup() -> void:
	_init_data()
	
	items = []
	weapons = []
	armours = []
	
	# Create instances of items
	for key in items_data.keys():
		var item_data = items_data[key]
		var item = _create_item(key, item_data)
		match item_data["type"]:
			"Weapon":
				weapons.append(_create_weapon(key, item_data))
			"Armour":
				armours.append(_create_armour(key, item_data))
		items.append(item)
		
		items.sort_custom(Callable(TransformHelper.sort_ascending))
		weapons.sort_custom(Callable(TransformHelper.sort_ascending))
		armours.sort_custom(Callable(TransformHelper.sort_ascending))


func find_all_items_by_type(equipment_type: String) -> Array[Item]:
	var results: Array[Item] = []
	for i in range(items.size()):
		if items[i].equipment_type == equipment_type:
			results.append(items[i])
	return results


func find_weapon_by_id(id: String) -> Weapon:
	var result: Weapon = null
	
	for weapon in weapons:
		if weapon.id == id:
			result = weapon
			break
	
	return result


func find_armour_by_id(id: String) -> Armour:
	var result: Armour = null
	
	for armour in armours:
		if armour.id == id:
			result = armour
			break
	
	return result


func find_item_by_id(id: String) -> Item:
	var result: Item = null
	
	for item in items:
		if item.id == id:
			result = item
			break
	
	return result


func _create_item(id: String, data: Dictionary) -> Item:
	var tmp_item = Item.new(id, data["name"], data["type"])
	if data.has("fighting_prowess"):
		tmp_item.fighting_prowess_bonus = data["fighting_prowess"]
	if data.has("awareness"):
		tmp_item.awareness_bonus = data["awareness"]
	if data.has("psychic"):
		tmp_item.psychic_bonus = data["psychic"]
	if data.has("equipment_type"):
		tmp_item.equipment_type = data["equipment_type"]
	return tmp_item
	

func _create_weapon(id: String, data: Dictionary) -> Weapon:
	var tmp_weapon = Weapon.new(id, data["name"], data["dmg_dice"], data["modifier"])
	if data.has("fighting_prowess"):
		tmp_weapon.fighting_prowess_bonus = data["fighting_prowess"]
	if data.has("awareness"):
		tmp_weapon.awareness_bonus = data["awareness"]
	if data.has("psychic"):
		tmp_weapon.psychic_bonus = data["psychic"]
	if data.has("equipment_type"):
		tmp_weapon.equipment_type = data["equipment_type"]
	return tmp_weapon


func _create_armour(id: String,data: Dictionary) -> Armour:
	var tmp_armour = Armour.new(id, data["name"], data["defence"])
	if data.has("fighting_prowess"):
		tmp_armour.fighting_prowess_bonus = data["fighting_prowess"]
	if data.has("awareness"):
		tmp_armour.awareness_bonus = data["awareness"]
	if data.has("psychic"):
		tmp_armour.psychic_bonus = data["psychic"]
	if data.has("equipment_type"):
		tmp_armour.equipment_type = data["equipment_type"]
	return tmp_armour



