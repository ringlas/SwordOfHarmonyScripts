class_name SkillNodeView
extends Control

@export var skill_points: Label
@export var skill_icon: Button
@export var skill_id: String

@export var skill_tree_view: SkillsView


func init_skill_node() -> void:
	set_locked(true)
	update_skill_points()


func update_skill_points() -> void:
	skill_points.text = str(skill_tree_view.get_skill_by_id(skill_id).points) + "/" + str(skill_tree_view.get_skill_by_id(skill_id).max_points)


func reset_skill_points() -> void:
	skill_points.text = "0/" + str(skill_tree_view.get_skill_by_id(skill_id).max_points)


func _on_overlay_pressed() -> void:
	skill_tree_view.on_skill_node_click(skill_id)
	

func set_locked(is_locked: bool) -> void:
	var material = skill_icon.material as ShaderMaterial
	
	# Ensure the material is unique to this instance
	if not material.is_local_to_scene():
		material = material.duplicate()
		skill_icon.material = material
		
	(skill_icon.material as ShaderMaterial).set_shader_parameter("is_grayscale_on", is_locked)
