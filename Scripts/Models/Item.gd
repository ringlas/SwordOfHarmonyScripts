class_name Item 
extends Equipable

var name: String
var type: String


func _init(id: String, name: String, type: String) -> void:
	self.id = id
	self.name = name
	self.type = type


func duplicate() -> Item:
	var duplicated_item: Item = Item.new(self.id, self.name, self.type)
	duplicated_item.equipment_type = self.equipment_type
	return duplicated_item
