extends CharacterBody3D

enum PlayerMotionEstates {NONE,FLOOR,AIR}
var estate : PlayerMotionEstates = PlayerMotionEstates.AIR

@onready var camera : Camera3D = $Camera3D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var e : InputEventMouseMotion = event
		
		if MainScene.get_settings_data("mouse sensitivity"):
			rotation.y -= MainScene.get_settings_data("mouse sensitivity") * (e.screen_relative.x / 100.0)
			camera.rotation.x -= MainScene.get_settings_data("mouse sensitivity") * (e.screen_relative.y / 100.0)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

@export var speed : float = 6.0
@export var jump_power : float = 6.0
@export var friction_floor : float = 100.0
@export var friction_air : float = 10.0


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("menu"):
		MainScene.pause()
	
	if estate == PlayerMotionEstates.FLOOR:
		var input_dir : Vector3 = ((Input.get_axis("walk_front","walk_back") * basis.z) + (Input.get_axis("walk_left","walk_right") * basis.x)).normalized() * speed
		velocity.x = move_toward(velocity.x,input_dir.x,friction_floor * delta)
		velocity.z = move_toward(velocity.z,input_dir.z,friction_floor * delta)
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_power
		
		if not is_on_floor():
			estate = PlayerMotionEstates.AIR
		
	elif estate == PlayerMotionEstates.AIR:
		velocity.y -= 9.0 * delta
		
		var input_dir : Vector3 = ((Input.get_axis("walk_front","walk_back") * basis.z) + (Input.get_axis("walk_left","walk_right") * basis.x)).normalized() * speed
		velocity.x = move_toward(velocity.x,input_dir.x,friction_air * delta)
		velocity.z = move_toward(velocity.z,input_dir.z,friction_air * delta)
		
		if is_on_floor():
			estate = PlayerMotionEstates.FLOOR
		
	
	camera.fov = MainScene.get_settings_data("fov")
	
	move_and_slide()
