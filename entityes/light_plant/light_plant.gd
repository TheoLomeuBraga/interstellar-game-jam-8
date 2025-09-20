extends Node3D

var tween_sk : Tween
var tween_l : Tween

func body_enter(n:Node) -> void:
	
	if not n is Player:
		return
	
	tween_sk = create_tween()
	tween_sk.tween_property($MeshInstance3D, "blend_shapes/retract", 1, 1.0)
	
	tween_l = create_tween()
	tween_l.tween_property($OmniLight3D, "light_color", Color.BLACK, 1.0)
	

func body_exit(n:Node) -> void:
	
	if not n is Player:
		return
	
	tween_sk = create_tween()
	tween_sk.tween_property($MeshInstance3D, "blend_shapes/retract", 0, 1.0)
	
	tween_l = create_tween()
	tween_l.tween_property($OmniLight3D, "light_color", Color(1.0, 1.0, 0.573, 1.0), 1.0)

func _ready() -> void:
	$Area3D.body_entered.connect(body_enter)
	$Area3D.body_exited.connect(body_exit)
