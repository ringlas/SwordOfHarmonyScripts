class_name SelectorView
extends Panel

@export var main_controller: MainController
@export var checkbox_prefab: PackedScene
@export var container: Control
@export var apply_btn: Button
@export var close_btn: Button
@export var title: Label
@export var subtitle: Label
@export var list_title: Label

var checkboxes: Array[ItemView]
var _character: Hero
var _test = false
var _view_type: Global.SelectorType


func _ready() -> void:
	visible = false
	apply_btn.pressed.connect(Callable(_on_apply_btn_press))
	close_btn.pressed.connect(Callable(_on_close_btn_press))


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
			if event.is_pressed():
				if event.keycode == KEY_ESCAPE:
					_on_close_btn_press()


func setup(character: Hero, type: Global.SelectorType) -> void:
	_character = character
	_view_type = type
	
	subtitle.visible = true
	
	checkboxes = []
	TransformHelper.remove_children(container)
	
	match _view_type:
		Global.SelectorType.WEAPONS:
			setup_weapons()
		Global.SelectorType.ARMOUR:
			setup_armours()
		Global.SelectorType.HELMS:
			setup_helmets()
		Global.SelectorType.CODEWORDS:
			setup_codewords()
		Global.SelectorType.ITEMS:
			setup_items()
		Global.SelectorType.SPELLS:
			setup_spells()
		Global.SelectorType.POTIONS:
			setup_potions()
		Global.SelectorType.THROWABLES:
			setup_throwables()


func create_checkbox(id: String, text: String) -> void:
	var item_checkbox: ItemView = checkbox_prefab.instantiate() as ItemView
	(item_checkbox as ItemView).id = id
	(item_checkbox as ItemView).text = text
	(item_checkbox as ItemView).selector_view = self
	container.add_child(item_checkbox)
	checkboxes.append(item_checkbox)


func disable_items_not_in_inventory() -> void:
	for checkbox in checkboxes:
		if not _character.has_item(checkbox.id):
			checkbox.disabled = true


func setup_weapons() -> void:
	title.text = tr("SELECT_WEAPONS_FROM_LIST")
	subtitle.text = tr("HINT_HEORIUSM_CAPACITY")
	list_title.text = tr("WEAPONS")
	
	var weapons: Array[Weapon] = ItemManager.weapons
	for weapon in weapons:
		create_checkbox(weapon.id, weapon.name)
	
	for checkbox in checkboxes:
		if _character.main_hand_weapon:
			if checkbox.id == _character.main_hand_weapon.id:
				checkbox.set_pressed_no_signal(true)
		if _character.off_hand_weapon:
			if checkbox.id == _character.off_hand_weapon.id:
				checkbox.set_pressed_no_signal(true)
	
	disable_items_not_in_inventory()


func setup_armours() -> void:
	title.text = tr("SELECT_ARMOUR_FROM_LIST")
	subtitle.text = tr("HINT_SELECT_ONLY_ITEMS_CARRIED")
	list_title.text = tr("ARMOUR")
	
	var armours: Array[Item] = ItemManager.find_all_items_by_type("chest")
	for armour in armours:
		create_checkbox(armour.id, armour.name)
	
	if _character.armour:
		for checkbox in checkboxes:
			if _character.armour.id == checkbox.id:
				checkbox.set_pressed_no_signal(true)
	
	disable_items_not_in_inventory()


func setup_helmets() -> void:
	title.text = tr("SELECT_HELM_FROM_LIST")
	subtitle.text = tr("HINT_SELECT_ONLY_ITEMS_CARRIED")
	list_title.text = tr("HELMS")
	
	var armours: Array[Item] = ItemManager.find_all_items_by_type("head")
	for armour in armours:
		create_checkbox(armour.id, armour.name)
	
	if _character.helm:
		for checkbox in checkboxes:
			if _character.helm.id == checkbox.id:
				checkbox.set_pressed_no_signal(true)
				
	disable_items_not_in_inventory()


func setup_potions() -> void:
	title.text = tr("SELECT_POTION_FROM_LIST")
	subtitle.text = tr("HINT_SELECT_ONLY_ITEMS_CARRIED")
	list_title.text = tr("POTIONS")
	
	var potions: Array[Item] = ItemManager.find_all_items_by_type("potion")
	for potion in potions:
		create_checkbox(potion.id, potion.name)
	
	if _character.potion:
		for checkbox in checkboxes:
			if _character.potion.id == checkbox.id:
				checkbox.set_pressed_no_signal(true)
	
	disable_items_not_in_inventory()


func setup_throwables() -> void:
	title.text = tr("SELECT_KNIVES_FROM_LIST")
	subtitle.text = tr("HINT_SELECT_ONLY_ITEMS_CARRIED")
	list_title.text = tr("KNIVES_AND_DAGGERS")
	
	var knives: Array[Item] = ItemManager.find_all_items_by_type("throwable")
	for knife in knives:
		create_checkbox(knife.id, knife.name)
	
	if _character.throwable:
		for checkbox in checkboxes:
			if _character.throwable.id == checkbox.id:
				checkbox.set_pressed_no_signal(true)
	
	disable_items_not_in_inventory()


func setup_codewords() -> void:
	title.text = tr("SELECT_CODEWORDS_FROM_LIST")
	list_title.text = tr("CODEWORDS")
	subtitle.visible = false
	
	for codeword in Global.get_codewords():
		create_checkbox((codeword as Codeword).id, (codeword as Codeword).name)
	
	for checkbox in checkboxes:
		if _character.has_codeword(checkbox.id):
			checkbox.set_pressed_no_signal(true)


func setup_items() -> void:
	title.text = tr("SELECT_ITEMS_FROM_LIST")
	subtitle.text = tr("HINT_ENCUMBRENCE") % [_character.get_inventory_limit()]
	list_title.text = tr("ITEMS")
	
	for item in ItemManager.items:
		create_checkbox(item.id, item.name)
	
	for checkbox in checkboxes:
		if (_character as Hero).has_item(checkbox.id):
			checkbox.set_pressed_no_signal(true) 


func setup_spells() -> void:
	title.text = tr("SELECT_SPELLS_FROM_LIST")
	subtitle.text = tr("HINT_SPELLS")
	list_title.text = tr("SPELLS")
	
	var level_limit: int = 0
	if _character.has_skill("common_enchantments"):
		level_limit = 1
	if _character.has_skill("rituals"):
		level_limit = 2
	if _character.has_skill("incantations"):
		level_limit = 3
		
	var spells: Array[Spell] = SpellManager.find_spells_by_level(level_limit)
	
	for spell in spells:
		create_checkbox(spell.id, spell.name)
	
	for checkbox in checkboxes:
		if _character.has_spell(checkbox.id):
			checkbox.set_pressed_no_signal(true) 


func get_checked_items() -> int:
	var result: int = 0
	for checkbox in checkboxes:
		if (checkbox as CheckBox).button_pressed:
			result += 1
			if checkbox.id == "winged_helmet" and _view_type == Global.SelectorType.ITEMS:
				result -= 1
	return result


func handle_checked(item: ItemView) -> void:
	match _view_type:
		Global.SelectorType.WEAPONS:
			handle_checked_weapons(item)
		Global.SelectorType.ARMOUR, Global.SelectorType.HELMS:
			handle_checked_armours(item)
		Global.SelectorType.CODEWORDS:
			pass
		Global.SelectorType.ITEMS:
			handle_checked_items(item)
		Global.SelectorType.THROWABLES, Global.SelectorType.POTIONS:
			handle_checked_unique_items(item)


func handle_checked_unique_items(item: ItemView) -> void:
	if not (item as CheckBox).button_pressed:
		return
		
	var checked_count = get_checked_items()
	var max_allowed: int = 1
	
	if checked_count > max_allowed:
		var to_uncheck_counter: int = checked_count - max_allowed
	
		for checkbox in checkboxes:
			if checkbox.id != item.id:
				if checkbox.button_pressed:
					checkbox.set_pressed_no_signal(false)
					to_uncheck_counter -= 1
					if to_uncheck_counter == 0:
						break


func handle_checked_weapons(item: ItemView) -> void:
	if not (item as CheckBox).button_pressed:
		return
		
	var checked_count = get_checked_items()
	var max_allowed: int = 1
	
	if _character.has_skill("heroism") or _test:
		max_allowed = 2
	
	if checked_count > max_allowed:
		var to_uncheck_counter: int = checked_count - max_allowed
	
		for checkbox in checkboxes:
			if checkbox.id != item.id:
				if checkbox.button_pressed:
					checkbox.set_pressed_no_signal(false)
					to_uncheck_counter -= 1
					if to_uncheck_counter == 0:
						break


func handle_checked_armours(item: ItemView) -> void:
	if not (item as CheckBox).button_pressed:
		return
		
	var checked_armours_count = get_checked_items()
	if checked_armours_count > 2:
		for checked_item in checkboxes:
			if checked_item.button_pressed and checked_item != item:
				checked_item.set_pressed_no_signal(false)
	
	if checked_armours_count == 2:
		var helm_count: int = 0
		var non_helm_count: int = 0
		var helm_item: ItemView = null
		var non_helm_item: ItemView = null
		
		for checked_item in checkboxes:
			if checked_item.button_pressed:
				if "helm" in checked_item.id or "helmet" in checked_item.id or "mask" in checked_item.id:
					helm_count += 1
					if item != checked_item:
						helm_item = checked_item
				else:
					non_helm_count += 1
					if item != checked_item:
						non_helm_item = checked_item
		
		if helm_count > 1:
			if helm_item != item:
				helm_item.set_pressed_no_signal(false)
		
		if non_helm_count > 1:
			if non_helm_item != item:
				non_helm_item.set_pressed_no_signal(false)


func handle_checked_items(item: ItemView) -> void:
	if not (item as CheckBox).button_pressed:
		return
		
	var checked_count = get_checked_items()
	var max_allowed: int = _character.get_inventory_limit()
	
	if checked_count > max_allowed:
		var to_uncheck_counter: int = checked_count - max_allowed
		
		#if is_overburdened_already:
			#main_controller.show_alert("Внимание! Надвишен товар! Трябва първо да изхвърлиш някой предмет.", Global.AlertType.WARNING)
	
		for checkbox in checkboxes:
			if checkbox.id != item.id:
				if checkbox.button_pressed:
					checkbox.set_pressed_no_signal(false)
					to_uncheck_counter -= 1
					if to_uncheck_counter == 0:
						break


func _has_selected_over_limit() -> bool:
	var checked_count = get_checked_items()
	var max_allowed: int = _character.get_inventory_limit()
	
	#TODO Fix item name reference
	for checkbox in checkboxes:
		if checkbox.id == "bag" and checkbox.button_pressed and not _character.has_item("bag"):
			max_allowed += 3
		if checkbox.id == "bag" and not checkbox.button_pressed and _character.has_item("bag"):
			max_allowed -= 4
	
	for checkbox in checkboxes:
		if checkbox.id == "flying_carpet" and checkbox.button_pressed:
			checked_count += 2
	
	if max_allowed < checked_count:
		return true

	return false


func _on_close_btn_press() -> void:
	visible = false


func _on_apply_btn_press() -> void:
	var params: Array[String] = []
	for checkbox in checkboxes:
		if checkbox.button_pressed:
			params.append(checkbox.id)
	
	var single_result: String = params[0] if params.size() >= 1 else ""
			
	match _view_type:
		Global.SelectorType.WEAPONS:
			main_controller.on_apply_weapons_button_press(params)
		Global.SelectorType.ARMOUR:
			main_controller.on_apply_armours_button_press(single_result)
		Global.SelectorType.HELMS:
			main_controller.on_apply_helms_button_press(single_result)
		Global.SelectorType.CODEWORDS:
			main_controller.on_apply_codewords_button_press(params)
		Global.SelectorType.ITEMS:
			if _has_selected_over_limit():
				main_controller.show_alert(tr("ALERT_OVERBURDENED"), Global.AlertType.ERROR)
				return
			main_controller.on_apply_items_button_press(params)
		Global.SelectorType.SPELLS:
			main_controller.on_apply_spells_button_press(params)
		Global.SelectorType.POTIONS:
			main_controller.on_apply_potion_button_press(single_result)
		Global.SelectorType.THROWABLES:
			main_controller.on_apply_throwable_button_press(single_result)
	
	visible = false
