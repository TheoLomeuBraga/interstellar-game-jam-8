extends Node
class_name MainScene

static var main_scene_pack : PackedScene = preload("res://main_scene.tscn")
static var current_main_scene : MainScene

@export var open_main_menu_on_ready : bool = true

static func secure_current_main_scene_existence() -> void:
	if current_main_scene == null:
		current_main_scene = main_scene_pack.instantiate()
		current_main_scene.open_main_menu_on_ready = false
		var tree : SceneTree = Engine.get_main_loop()
		tree.get_root().add_child(current_main_scene)


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
	
	AudioServer.set_bus_volume_db(0,linear_to_db(get_settings_data("volume") / 100))

static func close_settings() -> void:
	
	secure_current_main_scene_existence()
	
	if current_main_scene.settings_instance != null:
		current_main_scene.settings_instance.queue_free()
		current_main_scene.settings_instance = null
	


static func new_game() -> void:
	pass

static func continue_game() -> void:
	pass


@export var pause_scene : PackedScene
var pause_instance : Node

static var pre_pause_mouse_mode : Input.MouseMode

static func pause() -> void:
	
	pre_pause_mouse_mode = Input.mouse_mode
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	secure_current_main_scene_existence()
	
	current_main_scene.get_tree().paused = true
	
	if current_main_scene.pause_instance == null:
		current_main_scene.pause_instance = current_main_scene.pause_scene.instantiate()
		current_main_scene.get_node("menus/main").add_child(current_main_scene.pause_instance)

static func unpause() -> void:
	
	Input.mouse_mode = pre_pause_mouse_mode
	
	secure_current_main_scene_existence()
	
	current_main_scene.get_tree().paused = false
	
	if current_main_scene.pause_instance != null:
		current_main_scene.pause_instance.queue_free()
		current_main_scene.pause_instance = null
	
	close_settings()
