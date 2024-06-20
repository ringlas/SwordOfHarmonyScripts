class_name AlertView
extends Control

@export var background: Panel
@export var label: Label

@export var _dark_color_error: Color = Color.LIGHT_CORAL
@export var _light_color_error: Color = Color.LIGHT_PINK

@export var _dark_color_succes: Color = Color.FOREST_GREEN
@export var _light_color_success: Color = Color.LIGHT_GREEN

@export var _dark_color_warning: Color = Color.ORANGE
@export var _light_color_warning: Color = Color.MOCCASIN

var _tween: Tween


func _ready() -> void:
	if not visible:
		visible = true
	self.modulate.a = 0


func alert(msg: String, type: Global.AlertType) -> void:
	var box: StyleBoxFlat = StyleBoxFlat.new()
	
	match type:
		Global.AlertType.ERROR:
			box.bg_color = _light_color_error
			box.border_color = _dark_color_error
			label.add_theme_color_override("font_color", _dark_color_error)
		Global.AlertType.SUCCESS:
			box.bg_color = _light_color_success
			box.border_color = _light_color_success
			label.add_theme_color_override("font_color", _dark_color_succes)
		Global.AlertType.WARNING:
			box.bg_color = _light_color_warning
			box.border_color = _light_color_warning
			label.add_theme_color_override("font_color", _dark_color_warning)
	
	background.add_theme_stylebox_override("panel", box)
	label.text = msg
	
	_show_alert()


func _show_alert() -> void:
	_fade_in()

func _fade_in() -> void:
	if _tween:
		_tween.kill()
		modulate.a = 0
		
	var _modulate_target = modulate
	_modulate_target.a = 1
	
	_tween = create_tween()
	_tween.tween_property(self, "modulate", _modulate_target, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	_tween.finished.connect(Callable(_fade_out))


func _fade_out() -> void:
	await get_tree().create_timer(4).timeout
		
	var _modulate_target = modulate
	_modulate_target.a = 0

	_tween = create_tween()
	_tween.tween_property(self, "modulate", _modulate_target, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
