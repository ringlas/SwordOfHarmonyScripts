class_name Skill

var id: String
var name: String
var unlocked: bool = false
var required_skills: Array[Skill]
var children: Array[Skill]
var points: int
var max_points: int


func _init(_id: String, _name: String, _max_points: int, _required_skills: Array[Skill] = []) -> void:
	id = _id
	name = _name
	required_skills = _required_skills
	points = 0
	max_points = _max_points
