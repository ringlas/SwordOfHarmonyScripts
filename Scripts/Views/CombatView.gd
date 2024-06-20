class_name CombatView
extends View

@export var main_controller: MainController

@export var log: RichTextLabel
@export var scroll_container: ScrollContainer
@export var button_prepare_spells: Button
@export var title: Label
@export var button_save: Button

var _character: Hero
var current_episode_id: int = 14

signal auto_battle_pressed(episode_id: int)
signal auto_battle_saved

func _ready() -> void:
	_reset_log()


func setup(character: Hero) -> void:
	_character = character


func refresh_view() -> void:
	var message: String = "Провеждане на битка (Зареден епизод %s)" % current_episode_id
	title.text = message 
	_on_auto_battler_btn_pressed()


func _process(delta: float) -> void:
	button_save.disabled = log.text == ""
	button_prepare_spells.disabled = not _character.has_skill("common_enchantments")


func _generate_combat_log() -> void:
	var messagesArr: Array[String] = Logger.messages
	for i in messagesArr.size():
		log.text += messagesArr[i] + "\n"


func _reset_log() -> void:
	log.text = ""
	await get_tree().create_timer(0.01).timeout
	scroll_container.scroll_vertical = 0


func _on_auto_battler_btn_pressed() -> void:
	auto_battle_pressed.emit(current_episode_id)


func _on_save_btn_pressed() -> void:
	main_controller.show_alert(tr("ALERT_CHARACTER_TRAITS_UPDATED"), Global.AlertType.SUCCESS)
	auto_battle_saved.emit()


func on_auto_battle_completed() -> void:
	_reset_log()
	_generate_combat_log()


func _on_enemy_btn_pressed() -> void:
	main_controller.on_update_enemy_press(Global.ModalInputType.ENEMY)


func _on_prepared_spells_pressed() -> void:
	main_controller.on_update_spell_list_press()


func _on_update_usables_list_press() -> void:
	main_controller.on_update_usables_list_press()


func _on_roll_dice_btn_pressed() -> void:
	main_controller.on_roll_dice_btn_pressed()
