class_name SkillsView
extends View

@export var main_controller: MainController

@export var xp_label: Label

@export var warrior_tab : Button
@export var mystic_tab: Button
@export var rogue_tab: Button
@export var mage_tab: Button

@export var warrior_tree: Control
@export var mystic_tree: Control
@export var rogue_tree: Control
@export var mage_tree: Control

@export var tabs: Array[Button]
@export var trees: Array[Control]

@export var _tree_nodes: Array[SkillNodeView]

@export var reset_btn: Button

var _skill_tree: SkillTree
var _character: Hero

signal on_character_skills_updated(current_skill_tree: SkillTree)


func _ready() -> void:
	_on_warrior_tree_btn_pressed()


func _process(delta: float) -> void:
	xp_label.text = str(_character.xp) + "/" + str(_character.max_xp)
	reset_btn.visible = _character.xp < _character.max_xp


func init_skills_view(character: Character, skill_tree: SkillTree) -> void:
	self._character = character
	self._skill_tree = skill_tree
	
	#self._skill_tree = SkillTree.new()
	#self._skill_tree.setup_skills()
	#
	#self._character.rank_changed.connect(Callable(_skill_tree.relearn_skill_tree))
	
	_init_skill_nodes()


func get_skill_by_id(id: String) -> Skill:
	return _skill_tree.get_skill_by_id(id)


func on_skill_node_click(id: String) -> void:
	var skill_node: SkillNodeView = _get_tree_node_by_id(id)
	
	if skill_node:
		if _skill_tree.assign_skill_points(id, _character):
			_character.alter_xp(-_skill_tree.get_skill_by_id(id).max_points)
			skill_node.update_skill_points()
			if _skill_tree.unlock_skill(id):
				skill_node.set_locked(false)
				_skill_tree.relearn_skill_tree(_character)


func _reset_all_content() -> void:
	for i in trees.size():
		trees[i].visible = false
		tabs[i].disabled = false
		

func _init_skill_nodes() -> void:
	for tree_node in _tree_nodes:
		tree_node.init_skill_node()


func _get_tree_node_by_id(id: String) -> SkillNodeView:
	for tree_node in _tree_nodes:
		if tree_node.skill_id == id:
			return tree_node
	return null


func _on_warrior_tree_btn_pressed() -> void:
	_reset_all_content()
	warrior_tree.visible = true
	warrior_tab.disabled = true


func _on_mystic_tree_btn_pressed() -> void:
	_reset_all_content()
	mystic_tree.visible = true
	mystic_tab.disabled = true


func _on_pirate_tree_btn_pressed() -> void:
	_reset_all_content()
	rogue_tree.visible = true
	rogue_tab.disabled = true


func _on_wizard_tree_btn_pressed() -> void:
	_reset_all_content()
	mage_tree.visible = true
	mage_tab.disabled = true


func _on_update_xp_press() -> void:
	main_controller.on_update_char_stats_press(Global.ModalInputType.XP)


func _on_reset_btn_pressed() -> void:
	_skill_tree.reset_skills(_character)
	for tree_node in _tree_nodes:
		tree_node.update_skill_points()
		tree_node.set_locked(true)
	_skill_tree.relearn_skill_tree(_character)
