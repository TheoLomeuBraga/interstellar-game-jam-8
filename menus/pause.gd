extends CanvasLayer


func _ready() -> void:
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/resume.pressed.connect(MainScene.unpause)
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/settings.pressed.connect(MainScene.open_settings)
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/quit_game.pressed.connect(get_tree().quit)


var frames_passed : float = 0

func _process(delta: float) -> void:
	
	
	if frames_passed > 2 and Input.is_action_just_pressed("menu"):
		MainScene.unpause()
	
	frames_passed += 1
