extends StaticBody3D
class_name ForceFild

func explode() -> void:
	$CollisionShape3D.disabled = true
	$MeshInstance3D.visible = false
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer3D.play()
