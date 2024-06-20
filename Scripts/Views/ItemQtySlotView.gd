class_name ItemQtySlotView
extends ItemSlotView

@export var qty_label: Label


signal qty_pressed(type: Global.ModalInputType)


func set_qty(qty: int) -> void:
	qty_label.text = str(qty)


func _on_qty_button_pressed() -> void:
	if not item:
		qty_pressed.emit(Global.ModalInputType.EMPTY)
		return
	
	if item.id == "throwing_dagger":
		qty_pressed.emit(Global.ModalInputType.DAGGERS)
	elif item.id == "dagger":
		qty_pressed.emit(Global.ModalInputType.KNIVES)
