extends Node3D

func _physics_process(delta: float) -> void:
	
	if not $MeshInstance3D.visible:
		return
	
	for i in $ShapeCast3D.get_collision_count():
		if $ShapeCast3D.get_collider(i) is Player:
			var p : Player = $ShapeCast3D.get_collider(i)
			p.has_double_jump_upgrade = true
			$MeshInstance3D.visible = false
			
