class_name Armour 
extends Equipable

var name: String
var defence: int

func _init(id: String, name: String, defence: int) -> void:
	self.id = id
	self.name = name
	self.defence = defence
