extends Area3D
class_name EnviormentChanger

@export var light_color : Color = Color.WHITE
@export var light_color_change_speed : float = 1.0


static var tween : Tween
func change_area(body : Node) -> void:
	if body is Player:
		tween = get_tree().create_tween()
		tween.tween_property(CurrentWorldEnvironment.current.environment, "ambient_light_color", light_color, light_color_change_speed)
		#CurrentWorldEnvironment.current.environment.ambient_light_color

func _ready() -> void:
	body_entered.connect(change_area)
