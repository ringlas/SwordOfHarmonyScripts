class_name MainController
extends Node2D

@export var skill_view: SkillsView
@export var character_sheet_view: CharacterSheetView
@export var combat_view: CombatView
@export var modal_view: ModalView
@export var selector_view: SelectorView
@export var alert_view: AlertView
@export var dice_view: DiceModalView
@export var lang_view: LanguageModalView

var main_character: Hero 
var combat_victor: Character
var skill_tree: SkillTree


func _ready() -> void:
	_before_filter_events()
	_init_game()
	_post_filter_events()


func _before_filter_events() -> void:
	# Setup events
	combat_view.auto_battle_pressed.connect(Callable(on_auto_battle_button_pressed))
	combat_view.auto_battle_saved.connect(Callable(on_auto_battle_saved))


func _post_filter_events() -> void:
	main_character.rank_changed.connect(Callable(skill_tree.relearn_skill_tree))


func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			main_character.alter_rank(1)


func _test() -> void:
	
	# Characters
	#var hero: Character = create_character("hero")
	#var enemy: Character = create_character("mungodan")
	
	# Combat
	#_combat_simulation(hero, enemy)
	#_mass_combat_simulation(hero, enemy, 100)
	pass


func _init_game() -> void:
	# Setup database
	Global.setup_codewords()
	ItemManager.setup()
	SpellManager.setup()
	CharacterManager.init_data()
	
	# Setup main hero
	main_character = Hero.new()
	main_character = CharacterManager.create_character("0") as Hero
	main_character.set_starting_values()
	
	# Skills
	skill_tree = SkillTree.new()
	skill_tree.setup(self)
	skill_tree.setup_skills()
	skill_view.init_skills_view(main_character, skill_tree)
	
	main_character.set_skill_tree(skill_tree)
	
	# Character Sheet
	character_sheet_view.init_char_sheet(main_character)
	
	# Selectors
	selector_view.setup(main_character, Global.SelectorType.WEAPONS)
	
	# Combat
	combat_view.setup(main_character)
	_test()


func show_alert(msg: String, type: Global.AlertType) -> void:
	alert_view.alert(msg, type)


func on_apply_weapons_button_press(params: Array[String]) -> void:
	if params.size() == 0:
		if main_character.main_hand_weapon:
			main_character.main_hand_weapon.unequip(main_character)
			main_character.main_hand_weapon = null
		if main_character.off_hand_weapon:
			main_character.off_hand_weapon.unequip(main_character)
			main_character.off_hand_weapon = null
	if params.size() > 0:
		if main_character.main_hand_weapon:
			main_character.main_hand_weapon.unequip(main_character)
		main_character.main_hand_weapon = ItemManager.find_weapon_by_id(params[0])
		main_character.main_hand_weapon.equip(main_character)
	if params.size() > 1:
		if main_character.off_hand_weapon:
			main_character.off_hand_weapon.unequip(main_character)
		main_character.off_hand_weapon = ItemManager.find_weapon_by_id(params[1])
		main_character.off_hand_weapon.equip(main_character)
	character_sheet_view.refresh_view()


func on_apply_armours_button_press(id: String) -> void:
	if main_character.armour:
		main_character.armour.unequip(main_character)
		main_character.armour = null
	
	var armour_to_equip: Armour = ItemManager.find_armour_by_id(id) as Armour
	if armour_to_equip:
		armour_to_equip.equip(main_character)
		main_character.armour = armour_to_equip
		
	character_sheet_view.refresh_view()


func on_apply_helms_button_press(id: String) -> void:
	if main_character.helm:
		main_character.helm.unequip(main_character)
		main_character.helm = null
	
	var armour_to_equip: Armour = ItemManager.find_armour_by_id(id) as Armour
	
	if armour_to_equip:
		armour_to_equip.equip(main_character)
		main_character.helm = armour_to_equip
		
	character_sheet_view.refresh_view()


func on_apply_codewords_button_press(params: Array[String]) -> void:
	main_character.codewords = []
	for param in params:
		main_character.codewords.append(Global.find_codeword_by_id(param))
	character_sheet_view.refresh_view()


func on_apply_items_button_press(params: Array[String]) -> void:
	main_character.update_items(params)
	character_sheet_view.refresh_view()


func on_apply_spells_button_press(params: Array[String]) -> void:
	main_character.learn_spells(params)
	show_alert(tr("ALERT_ENCHANTMENTS_UPDATE"), Global.AlertType.SUCCESS)


func on_apply_potion_button_press(id: String) -> void:
	main_character.set_potion(ItemManager.find_item_by_id(id))
	character_sheet_view.refresh_view()


func on_apply_throwable_button_press(id: String) -> void:
	main_character.set_throwable(ItemManager.find_item_by_id(id))
	character_sheet_view.refresh_view()


func on_apply_episode_button_press(new_episode_id: int) -> void:
	combat_view.current_episode_id = new_episode_id
	combat_view.refresh_view()


func on_update_weapons_list_press() -> void:
	selector_view.setup(main_character, Global.SelectorType.WEAPONS)
	selector_view.visible = true


func on_update_armours_list_press() -> void:
	selector_view.setup(main_character, Global.SelectorType.ARMOUR)
	selector_view.visible = true


func on_update_helm_list_press() -> void:
	selector_view.setup(main_character, Global.SelectorType.HELMS)
	selector_view.visible = true


func on_update_potion_list_press() -> void:
	selector_view.setup(main_character, Global.SelectorType.POTIONS)
	selector_view.visible = true


func on_update_throwable_list_press() -> void:
	selector_view.setup(main_character, Global.SelectorType.THROWABLES)
	selector_view.visible = true


func on_update_codewords_list_press() -> void:
	selector_view.setup(main_character, Global.SelectorType.CODEWORDS)
	selector_view.visible = true


func on_update_item_list_press() -> void:
	selector_view.setup(main_character, Global.SelectorType.ITEMS)
	selector_view.visible = true


func on_update_spell_list_press() -> void:
	selector_view.setup(main_character, Global.SelectorType.SPELLS)
	selector_view.visible = true


func on_update_char_stats_press(value_type: int) -> void:
	if value_type == Global.ModalInputType.EMPTY:
		show_alert(tr("ERROR_CANNOT_BE_EMPTY"), Global.AlertType.WARNING)
		return
	modal_view.setup(main_character, value_type)
	modal_view.visible = true


func on_update_enemy_press(value_type: int) -> void:
	modal_view.setup_combat(combat_view.current_episode_id, value_type)
	modal_view.visible = true


func on_roll_dice_btn_pressed() -> void:
	dice_view.visible = true


func on_auto_battle_button_pressed(episode_id: int) -> void:
	# Characters
	var hero: Hero = main_character.clone()
	hero.name = "[color=darkgreen]" + hero.name + "[/color]"
	var enemy: Character = CharacterManager.create_character(str(episode_id))
	enemy.name = "[color=darkred]" + enemy.name + "[/color]"
	
	# Boss Battle Adjustments
	if (main_character as Hero).has_codeword("mercy"):
		if episode_id == 193:
			(enemy as Character).main_hand_weapon.dice -= 1
		if episode_id == 194:
			(enemy as Character).main_hand_weapon.dice -= 1
			(enemy as Character).main_hand_weapon.modifier = 0
			
	if (main_character as Hero).has_codeword("generous"):
		(hero as Hero).armour_class += 1
	
	#Darii Battle Adjustments
	if episode_id == 96:
		enemy.spells.append(SpellManager.create_spell("enthrallment"))
		hero.status_effects.append("darii")
	
	# Combat	
	_combat_simulation(hero, enemy)
	
	# Refresh UI
	combat_view.on_auto_battle_completed()


func on_auto_battle_saved() -> void:
	if not (combat_victor is Hero):
		main_character.set_endurance(0)
		return
		
	if combat_victor.daggers:
		main_character.set_daggers(combat_victor.daggers)
	if combat_victor.knives:
		main_character.set_knives(combat_victor.knives)
	if combat_victor.throwable:
		main_character.set_throwable(combat_victor.throwable)
	if combat_victor.potion:
		main_character.set_potion(combat_victor.potion)
	main_character.set_endurance(combat_victor.endurance)
	

func _combat_simulation(hero: Character, enemy: Character) -> void:
	Logger.clear_log()
	Logger.log(tr("COMBAT_BETWEEN") % [hero.name, enemy.name])
		
	# Determine battle order
	var first: Character = hero if hero.awareness.value >= enemy.awareness.value else enemy
	var second = enemy if first == hero else hero
	
	Logger.log(tr("FIRST_IN_TURN") % [first.name, first.awareness.value])
	
	var round: int = 0
	
	while hero.is_alive() and enemy.is_alive():
		round += 1
		Logger.log(tr("ROUND_COUNTER") % round)
		
		first.choose_action(second)
		if not second.is_alive():
			break
		second.choose_action(first)
	
	var victor = hero if hero.is_alive() else enemy
	var loser = enemy if hero.is_alive() else hero
	
	combat_victor = victor
	
	Logger.log(tr("VICTORY") % [victor.name, victor.endurance])
	Logger.log(tr("COMBAT_OVER"))
	
	if victor._has_status_effect("opiath"):
		victor._apply_opiath_status_effect()
		if not victor.is_alive():
			Logger.log(tr("HERO_DIED"))
	
	if victor._has_usable("healing_salve"):
		victor.remove_usable("healing_salve")
		victor._apply_healing_effect()
		
	if victor._has_usable("herbal_potion"):
		victor.remove_usable("herbal_potion")
		victor._apply_healing_effect()


func _mass_combat_simulation(hero: Character, enemy: Character, num_battles: int) -> void:
	var hero_wins: int = 0
	var enemy_wins: int = 0
	
	Logger.is_logging = false
	
	for i in num_battles:
		var tmp_hero: Character = hero.clone()
		var tmp_enemy: Character = enemy.clone()
	
		_combat_simulation(tmp_hero, tmp_enemy)
		
		if tmp_hero.is_alive():
			hero_wins += 1
		else:
			enemy_wins += 1
			
	Logger.is_logging = true
	Logger.log(tr("VICTORY_COUNTER") % [num_battles, hero_wins, enemy_wins])


func _on_select_lang_pressed(lang: String) -> void:
	Global.update_lang(lang)
	_init_game()
	lang_view.visible = false
