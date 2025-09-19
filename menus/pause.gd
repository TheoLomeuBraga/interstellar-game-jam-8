extends CanvasLayer


func _ready() -> void:
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/resume.pressed.connect(MainScene.unpause)
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/settings.pressed.connect(MainScene.open_settings)
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/quit_game.pressed.connect(get_tree().quit)
