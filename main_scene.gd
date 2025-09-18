extends Node
class_name MainScene

static var main_scene_pack : PackedScene = load("res://main_scene.tscn")
static var current_main_scene : MainScene

@export var open_main_menu_on_ready : bool = true

static func secure_current_main_scene_existence() -> void:
	if current_main_scene == null:
		current_main_scene = main_scene_pack.instantiate()
		current_main_scene.open_main_menu_on_ready = false
		var tree : SceneTree = Engine.get_main_loop()
		tree.get_root().add_child(current_main_scene)
		
		await tree.create_timer(0.05).timeout


static var settings_data : Dictionary = {
	"mouse sensitivity": 1.0,
	"full screen": false,
	"volume": 80.0,
	"fov": 90.0
}

static func get_settings_data(name : String) -> Variant:
	if settings_data.has(name):
		return settings_data[name]
	return null

static func load_settings() -> void:
	var settings_dictionary : Dictionary = LazySettingsBuilder.load_data_dictionary("curiosity_settings")
	if settings_dictionary != null:
		for k in settings_dictionary:
			settings_data[k] = settings_dictionary[k]

@export var main_menu_scene : PackedScene
var main_menu_instance : Node

static func open_main_menu() -> void:
	
	secure_current_main_scene_existence()
	
	if current_main_scene.main_menu_instance == null:
		current_main_scene.main_menu_instance = current_main_scene.main_menu_scene.instantiate()
		current_main_scene.get_node("menus/main").add_child(current_main_scene.main_menu_instance)

static func close_main_menu() -> void:
	
	secure_current_main_scene_existence()
	
	if current_main_scene.main_menu_instance != null:
		current_main_scene.main_menu_instance.queue_free()
		current_main_scene.main_menu_instance = null



func _ready() -> void:
	
	current_main_scene = self
	
	load_settings()
	
	if open_main_menu_on_ready:
		open_main_menu()
	
	secure_current_main_scene_existence()

@export var settings_scene : PackedScene
var settings_instance : Node

static func open_settings() -> void:
	
	secure_current_main_scene_existence()
	
	if current_main_scene.settings_instance == null:
		current_main_scene.settings_instance = current_main_scene.settings_scene.instantiate()
		current_main_scene.get_node("menus/settings").add_child(current_main_scene.settings_instance)

static func apply_settings() -> void:
	
	secure_current_main_scene_existence()
	
	
	load_settings()
	
	if get_settings_data("full screen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	AudioServer.set_bus_volume_db(0,linear_to_db(get_settings_data("volume") / 100.0))

static func close_settings() -> void:
	
	secure_current_main_scene_existence()
	
	if current_main_scene.settings_instance != null:
		current_main_scene.settings_instance.queue_free()
		current_main_scene.settings_instance = null
	

@export var new_game_scene : PackedScene
var new_game_instance : Node

static func new_game() -> void:
	secure_current_main_scene_existence()
	
	if current_main_scene.new_game_instance == null:
		current_main_scene.new_game_instance = current_main_scene.new_game_scene.instantiate()
		current_main_scene.get_node("cenary").add_child(current_main_scene.new_game_instance)
	
	close_main_menu()

static func continue_game() -> void:
	pass


@export var pause_scene : PackedScene
var pause_instance : Node


static var current_mouse_mode : Input.MouseMode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if current_mouse_mode != Input.mouse_mode:
		Input.mouse_mode = current_mouse_mode

static func pause() -> void:
	
	secure_current_main_scene_existence()
	#pre_pause_mouse_mode = current_mouse_mode
	current_mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	
	current_main_scene.get_tree().paused = true
	Engine.time_scale = 0.0
	
	if current_main_scene.pause_instance == null:
		current_main_scene.pause_instance = current_main_scene.pause_scene.instantiate()
		current_main_scene.get_node("menus/main").add_child(current_main_scene.pause_instance)

static func unpause() -> void:
	
	secure_current_main_scene_existence()
	
	current_main_scene.get_tree().paused = false
	Engine.time_scale = 1.0
	
	if current_main_scene.pause_instance != null:
		current_main_scene.pause_instance.queue_free()
		current_main_scene.pause_instance = null
	
	close_settings()
