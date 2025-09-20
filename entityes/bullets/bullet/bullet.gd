extends ShapeCast3D

@export var speed = 10.0

func _physics_process(delta: float) -> void:
	global_position -= basis.z * speed * delta
	
	for i in get_collision_count():
		if get_collider(i) is Stone:
			var s : Stone = get_collider(i)
			s.explode()
