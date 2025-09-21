extends ShapeCast3D

func _physics_process(delta: float) -> void:
	
	if not $MeshInstance3D.visible:
		return
	
	for i in get_collision_count():
		if get_collider(i) is Player:
			var p : Player = get_collider(i)
			p.has_gun_upgrade = true
			$MeshInstance3D.visible = false
			$OmniLight3D.light_energy = 0.0
			
