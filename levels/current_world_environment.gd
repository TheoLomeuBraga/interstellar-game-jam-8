extends WorldEnvironment
class_name CurrentWorldEnvironment

static var current : WorldEnvironment 

@export var force_black_light_on_start : bool = true

func _ready() -> void:
	current = self
	if force_black_light_on_start:
		CurrentWorldEnvironment.current.environment.ambient_light_color = Color.BLACK
