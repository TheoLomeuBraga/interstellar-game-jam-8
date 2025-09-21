extends RayCast3D

var on : bool = true
var life_time : float = 1.0

func _physics_process(delta: float) -> void:
	
	if is_colliding():
		if get_collider() is Stone or get_collider() is ForceFild:
			enabled = false
			get_collider().explode()
			
	
	life_time -= delta
	if life_time <= 0.0:
		queue_free()
