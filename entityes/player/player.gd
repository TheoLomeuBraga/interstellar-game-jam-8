extends CharacterBody3D
class_name Player



enum PlayerMotionEstates {NONE,FLOOR,AIR}
var estate : PlayerMotionEstates = PlayerMotionEstates.AIR

@onready var camera : Camera3D = $Camera3D
@onready var animation_tree : AnimationTree = $SubViewportContainer/SubViewport/cannon_camera/AnimationTree

func _input(event: InputEvent) -> void:
	
	if MainScene.current_mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		var e : InputEventMouseMotion = event
		
		if MainScene.get_settings_data("mouse sensitivity"):
			rotation.y -= MainScene.get_settings_data("mouse sensitivity") * (e.screen_relative.x / 100.0)
			camera.rotation.x -= MainScene.get_settings_data("mouse sensitivity") * (e.screen_relative.y / 100.0)
		
		if camera.rotation_degrees.x > 90:
			camera.rotation_degrees.x = 90
		if camera.rotation_degrees.x < -90:
			camera.rotation_degrees.x = -90

func _ready() -> void:
	MainScene.secure_current_main_scene_existence(self)
	MainScene.pause_unpause_on = true

@export var speed : float = 6.0
@export var jump_power : float = 6.0
@export var friction_floor : float = 100.0
@export var friction_air : float = 10.0

@export var has_double_jump_upgrade : bool = false
var double_jump_avaliable : bool = false

@export var has_gun_upgrade : bool = false
@export var normal_bullet : PackedScene
@export var power_bullet : PackedScene
var gun_cooldown : float = 0

@export var artifacts : int = 0

func gun_process(delta: float) -> void:
	gun_cooldown -= delta
	
	if gun_cooldown <= 0 and Input.is_action_just_pressed("shot"):
		
		$SFX/shot.play()
		
		if not has_gun_upgrade:
			
			var b : ShapeCast3D = normal_bullet.instantiate()
			$Camera3D/Muzle.add_child(b)
			b.top_level = true
			b.add_exception(self)
			b.global_position = $Camera3D/Muzle.global_position
			b.global_rotation = $Camera3D/Muzle.global_rotation
			
			animation_tree.set("parameters/shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			
			gun_cooldown = 0.25
		
		else:
			
			var b : RayCast3D = power_bullet.instantiate()
			$Camera3D/Muzle.add_child(b)
			b.top_level = true
			b.add_exception(self)
			b.global_position = $Camera3D/Muzle.global_position
			b.global_rotation = $Camera3D/Muzle.global_rotation
			
			animation_tree.set("parameters/shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			
			gun_cooldown = 0.1

func _physics_process(delta: float) -> void:
	
	gun_process(delta)
	
	if estate == PlayerMotionEstates.FLOOR:
		var input_dir : Vector3 = ((Input.get_axis("walk_front","walk_back") * basis.z) + (Input.get_axis("walk_left","walk_right") * basis.x)).normalized() * speed
		velocity.x = move_toward(velocity.x,input_dir.x,friction_floor * delta)
		velocity.z = move_toward(velocity.z,input_dir.z,friction_floor * delta)
		
		if has_double_jump_upgrade:
			double_jump_avaliable = true
		
		if Input.is_action_just_pressed("jump"):
			$SFX/jump.play()
			velocity.y = jump_power
		
		if not is_on_floor():
			estate = PlayerMotionEstates.AIR
		
	elif estate == PlayerMotionEstates.AIR:
		velocity.y -= 9.0 * delta
		
		var input_dir : Vector3 = ((Input.get_axis("walk_front","walk_back") * basis.z) + (Input.get_axis("walk_left","walk_right") * basis.x)).normalized() * speed
		velocity.x = move_toward(velocity.x,input_dir.x,friction_air * delta)
		velocity.z = move_toward(velocity.z,input_dir.z,friction_air * delta)
		
		if double_jump_avaliable and Input.is_action_just_pressed("jump"):
			$SFX/djump.play()
			velocity.y = jump_power * 2
		
		if is_on_floor():
			$SFX/fall.play()
			estate = PlayerMotionEstates.FLOOR
		
	
	camera.fov = MainScene.get_settings_data("fov")
	
	move_and_slide()

func _process(delta: float) -> void:
	
	if not get_tree().paused:
		MainScene.current_mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	
	animation_tree.set("parameters/walk_speed/scale",velocity.length() / 5.0)
	
	if estate == PlayerMotionEstates.FLOOR and Input.is_action_just_pressed("jump"):
		animation_tree.set("parameters/jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

var tween : Tween

func end_game() -> void:
	
	AudioServer.set_bus_volume_db(0,linear_to_db(0.0))
	
	$Control/CenterContainer/Label.text = "secrets: " + str(artifacts) + "/3"
	
	tween = create_tween()
	tween.tween_property($Control/ColorRect, "color", Color.WHITE, 1.0)
	
	await tween.finished
	
	tween = create_tween()
	tween.tween_property($Control/ColorRect, "color", Color.BLACK, 1.0)
	
	await tween.finished
	
	tween = create_tween()
	tween.tween_property($Control/CenterContainer/Label, "visible_ratio", 1.0, 1.0)
	await tween.finished
