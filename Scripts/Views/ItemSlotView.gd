class_name ItemSlotView
extends NinePatchRect

@export var label: Label
@export var icon_cushion: TextureRect
@export var icon: TextureRect

@export var equipment_slot_type: String

var item: Equipable

signal item_slot_clicked(item_slot: ItemSlotView)


func set_item(_item: Equipable) -> void:
	if not _item:
		item = null
		match equipment_slot_type:
			"chest":
				label.text = tr("ARMOUR")
			"hand":
				label.text = tr("WEAPON")
			"head":
				label.text = tr("HELMET")
			"potion":
				label.text = tr("POTION")
			"throwable":
				label.text = tr("THROWING_WEAPON")
		return
		
	item = _item
	
	label.text = item.get_simple_name()
	
	var texture_path: String = "res://Sprites/Items/" + item.id + ".png"
	var texture = load(texture_path) as Texture
	icon.texture = texture


func _process(delta: float) -> void:
	if item:
		if not icon.visible:
			icon.visible = true
		if not icon_cushion.visible:
			icon_cushion.visible = true
	else:
		if icon.visible:
			icon.visible = false
		if icon_cushion.visible:
			icon_cushion.visible = false


func _on_item_slot_pressed():
	item_slot_clicked.emit(self)
