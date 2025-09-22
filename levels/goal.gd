extends Area3D


func on_body_entered(b : Node3D) -> void:
	if b is Player:
		var p :Player = b
		p.end_game()


func _ready() -> void:
	body_entered.connect(on_body_entered)
