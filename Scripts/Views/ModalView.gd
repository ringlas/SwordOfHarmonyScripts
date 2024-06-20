class_name ModalView
extends Panel

@export var main_controller: MainController	
@export var label: Label
@export var description: Label
@export var input: LineEdit
@export var alert: Panel

var _character: Hero
var _value_type: Global.ModalInputType


func _ready() -> void:
	visible = false


func setup(character: Hero, value_type: Global.ModalInputType) -> void:
	_character = character
	_value_type = value_type
	description.visible = false
	
	match _value_type:
		Global.ModalInputType.ENDURANCE:
			label.text = tr("ENDURANCE")
			input.text = str(character.endurance)
		Global.ModalInputType.RANK:
			label.text = tr("RANK")
			input.text = str(character.rank)
		Global.ModalInputType.FIGHT:
			label.text = tr("FIGHTING_PROWESS")
			input.text = str(character.fighting_prowess.base_value)
			description.visible = true
			description.text = tr("ALERT_BONUS_ARE_AUTOMATIC")
		Global.ModalInputType.AWANRESS:
			label.text = tr("AWARENESS")
			input.text = str(character.awareness.base_value)
			description.visible = true
			description.text = tr("ALERT_BONUS_ARE_AUTOMATIC")
		Global.ModalInputType.PSYCH:
			label.text = tr("PSYCHIC_ABILITIES")
			input.text = str(character.psychic_ability.base_value)
			description.visible = true
			description.text = tr("ALERT_BONUS_ARE_AUTOMATIC")
		Global.ModalInputType.MONEY:
			label.text = tr("GOLD")
			input.text = str(character.money)
		Global.ModalInputType.XP:
			label.text = tr("XP")
			input.text = str(character.max_xp)
		Global.ModalInputType.KNIVES:
			label.text = tr("KNIVES_QTY")
			input.text = str(character.knives)
		Global.ModalInputType.DAGGERS:
			label.text = tr("DAGGERS_QTY")
			input.text = str(character.daggers)
	
	input.select_all()
	input.grab_focus()


func setup_combat(episode_id: int, value_type: Global.ModalInputType) -> void:
	_value_type = value_type
	description.visible = false
	label.text = tr("LOAD_PARAGRAPH_NUMBER")
	input.text = str(episode_id)
	
	input.select_all()
	input.grab_focus()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
			if event.is_pressed():
				if (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER) and input.has_focus():
					_on_apply_pressed()
				if event.keycode == KEY_ESCAPE:
					_on_close_pressed()


func _validate() -> bool:
	return input.text.is_valid_int() and int(input.text) > 0


func _on_close_pressed() -> void:
	visible = false


func _on_apply_pressed() -> void:
	if not _validate():
		main_controller.show_alert(tr("ALERT_INVALID"), Global.AlertType.ERROR)
		return
	
	if _value_type == Global.ModalInputType.ENEMY:
		_on_apply_combat_pressed()
		return
	
	if _value_type == Global.ModalInputType.XP:
		var altered_value: int = int(input.text)
		if (_character as Hero).get_spent_skill_points_sum() > altered_value:
			main_controller.show_alert(tr("ALERT_ERROR_RESET_TREE"), Global.AlertType.ERROR)
			visible = false
			return
	
	if _value_type == Global.ModalInputType.RANK:
		var altered_value: int = int(input.text)
		if (_character as Hero).rank > altered_value and (_character as Hero).get_spent_skill_points_sum() > Global.XP_PER_RANK * altered_value:
			main_controller.show_alert(tr("ALERT_ERROR_RESET_TREE"), Global.AlertType.ERROR)
			visible = false
			return
		
	match _value_type:
		Global.ModalInputType.ENDURANCE:
			_character.alter_endurance(int(input.text) - _character.endurance)
		Global.ModalInputType.RANK:
			var rank_new_value: int = mini(Global.MAX_RANK_CAP, int(input.text))
			_character.alter_rank(rank_new_value - _character.rank)
			main_controller.show_alert(tr("ALERT_UPDATED_ENDURANCE_XP"), Global.AlertType.WARNING)
		Global.ModalInputType.FIGHT:
			_character.fighting_prowess.base_value = int(input.text)
		Global.ModalInputType.AWANRESS:
			_character.awareness.base_value = int(input.text)
		Global.ModalInputType.PSYCH:
			_character.psychic_ability.base_value = int(input.text)
		Global.ModalInputType.MONEY:
			_character.set_money(int(input.text))
		Global.ModalInputType.XP:
			_character.alter_max_xp(int(input.text) - _character.max_xp)
		Global.ModalInputType.KNIVES:
			_character.set_knives(int(input.text))
		Global.ModalInputType.DAGGERS:
			_character.set_daggers(int(input.text))
			
			
	_character.character_stats_updated.emit()
	visible = false


func _on_apply_combat_pressed() -> void:
	if not CharacterManager.characters_data.has(input.text):
		main_controller.show_alert(tr("ALERT_COMBAT_NOT_FOUND"), Global.AlertType.ERROR)
		input.select_all()
		return
	
	main_controller.on_apply_episode_button_press(int(input.text))
	visible = false
