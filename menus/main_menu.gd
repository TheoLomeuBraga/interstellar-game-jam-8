extends Control



func _ready() -> void:
	$"VBoxContainer/HBoxContainer/VBoxContainer/new_game".pressed.connect(MainScene.new_game)
	$"VBoxContainer/HBoxContainer/VBoxContainer/continue".pressed.connect(MainScene.continue_game)
	$VBoxContainer/HBoxContainer/VBoxContainer/settings.pressed.connect(MainScene.open_settings)
	$VBoxContainer/HBoxContainer/VBoxContainer/exit.pressed.connect(get_tree().quit)
