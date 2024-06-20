class_name CharacterSheetView
extends View

@export var main_controller: MainController

@export var endurance_label: Label
@export var fighting_prowess_label: Label
@export var awareness_label: Label
@export var psychic_ability_label: Label

@export var main_hand_weapon_slot: ItemSlotView
@export var main_hand_weapon_label: Label

@export var off_hand_weapon_slot: ItemSlotView
@export var off_hand_weapon_label: Label

@export var armour_slot: ItemSlotView
@export var armour_label: Label

@export var helm_slot: ItemSlotView
@export var helm_label: Label

@export var potion_slot: ItemSlotView
@export var potion_label: Label

@export var throwable_slot: ItemSlotView
@export var throwable_label: Label

@export var codewords_label: Label
@export var items_label: Label
@export var items_capacity_label: Label

@export var rank_label: Label
@export var money_label: Label

var _character: Hero


func _ready() -> void:
	helm_slot.item_slot_clicked.connect(Callable(_on_item_slot_clicked))
	main_hand_weapon_slot.item_slot_clicked.connect(Callable(_on_item_slot_clicked))
	off_hand_weapon_slot.item_slot_clicked.connect(Callable(_on_item_slot_clicked))
	armour_slot.item_slot_clicked.connect(Callable(_on_item_slot_clicked))
	potion_slot.item_slot_clicked.connect(Callable(_on_item_slot_clicked))
	throwable_slot.item_slot_clicked.connect(Callable(_on_item_slot_clicked))
	(throwable_slot as ItemQtySlotView).qty_pressed.connect(Callable(_on_update_throwable_qty_pressed))


func init_char_sheet(character: Hero) -> void:
	_character = character
	_character.character_stats_updated.connect(Callable(refresh_view))
	refresh_view()


func refresh_view() -> void:
	endurance_label.text = str(_character.endurance) + "/" + str(_character.max_endurance.value)
	fighting_prowess_label.text = str(_character.fighting_prowess.value)
	awareness_label.text = str(_character.awareness.value)
	psychic_ability_label.text = str(_character.psychic_ability.value)
	
	main_hand_weapon_slot.set_item(_character.main_hand_weapon)
	off_hand_weapon_slot.set_item(_character.off_hand_weapon)
	armour_slot.set_item(_character.armour)
	helm_slot.set_item(_character.helm)
	potion_slot.set_item(_character.potion)
	throwable_slot.set_item(_character.throwable)
	
	var qty: int = 0
	var throwable: Item = _character.get_usable_throwable()
	
	if throwable:
		if throwable.id == "dagger" and _character.knives > 0:
			qty = _character.knives
		elif throwable.id == "throwing_dagger" and _character.daggers > 0:
			qty = _character.daggers
		
	(throwable_slot as ItemQtySlotView).set_qty(qty)
	
	rank_label.text = str(_character.rank)
	money_label.text = str(_character.money) + " " + tr("GOLD")
	
	codewords_label.text = ""
	for codeword in _character.codewords:
		codewords_label.text += codeword.name + ", "
	
	items_label.text = ""
	for item in _character.items:
		items_label.text += item.name + ", "
	
	items_capacity_label.text = str(_character.get_carried_items()) + "/" + str(_character.get_inventory_limit()) + " " + tr("ITEMS")


func _on_update_weapons_btn_press() -> void:
	main_controller.on_update_weapons_list_press()


func _on_update_armours_btn_pressed() -> void:
	main_controller.on_update_armours_list_press()


func _on_update_helmets_btn_pressed() -> void:
	main_controller.on_update_helm_list_press()


func _on_update_potions_btn_pressed() -> void:
	main_controller.on_update_potion_list_press()


func _on_update_throwables_btn_pressed() -> void:
	main_controller.on_update_throwable_list_press()


func _on_codewords_btn_pressed():
	main_controller.on_update_codewords_list_press()


func _on_items_btn_pressed() -> void:
	main_controller.on_update_item_list_press()


func _on_update_char_stats_press(value_type: int) -> void:
	main_controller.on_update_char_stats_press(value_type)


func _on_update_usables_list_press() -> void:
	main_controller.on_update_usables_list_press()


func _on_update_throwable_qty_pressed(type: Global.ModalInputType) -> void:
	main_controller.on_update_char_stats_press(type)


func _on_item_slot_clicked(item_slot: ItemSlotView) -> void:
	match item_slot.equipment_slot_type:
		"chest":
			_on_update_armours_btn_pressed()
		"hand":
			_on_update_weapons_btn_press()
		"head":
			_on_update_helmets_btn_pressed()
		"potion":
			_on_update_potions_btn_pressed()
		"throwable":
			_on_update_throwables_btn_pressed()
