extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect/LazySettingsBuilder/Base/VBoxContainer/HBoxContainer/exit.pressed.connect(MainScene.close_settings)
	$ColorRect/LazySettingsBuilder/Base/VBoxContainer/HBoxContainer/save.pressed.connect(MainScene.apply_settings)
