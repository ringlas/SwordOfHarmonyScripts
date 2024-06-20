class_name Weapon 
extends Equipable

var name: String
var dice: int
var modifier: int


func _init(id: String, name: String, dice: int, modifier: int) -> void:
	self.id = id
	self.name = name
	self.dice = dice
	self.modifier = modifier


func roll_damage() -> Dictionary:
	var results: Dictionary = DiceRoller.roll_dice(dice)
	var damage: int = results["total"] + modifier
	return {"damage": damage, "roll_details": results, "modifier": modifier}


func duplicate() -> Weapon:
	var clone_weapon: Weapon = Weapon.new(self.id, self.name, self.dice, self.modifier)
	clone_weapon.fighting_prowess_bonus = self.fighting_prowess_bonus
	clone_weapon.psychic_bonus = self.psychic_bonus
	clone_weapon.awareness_bonus = self.awareness_bonus
	return clone_weapon
