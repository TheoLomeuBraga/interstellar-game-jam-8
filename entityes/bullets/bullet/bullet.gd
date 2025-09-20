extends ShapeCast3D

@export var speed = 10.0

func _physics_process(delta: float) -> void:
	global_position -= basis.z * speed * delta
