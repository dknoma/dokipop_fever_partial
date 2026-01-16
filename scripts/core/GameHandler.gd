extends Node

enum State {
	None,
	Transitioning
}

@onready var main_menu_scn : PackedScene = preload("res://scenes/main_menu.tscn")
@onready var credit_scn : PackedScene = preload("res://scenes/credit_screen.tscn")

var Story := preload("res://Services/Story/StoryService.gd").new():
	get: return get_service("Story")
var Puzzle := preload("res://Services/Puzzle/PuzzleService.gd").new():
	get: return get_service("Puzzle")
var Settings := preload("res://Services/Settings/SettingsService.gd").new():
	get: return get_service("Settings")
var Save := preload("res://Services/Save/SaveService.gd").new():
	get: return get_service("Save")
	

var state : State = State.None
var current_player : CharacterData


func _ready() -> void:
	find_services()
	current_player = load("res://resources/character_data/dokibird.tres") # FIXME: debug default; should depend on current stories Player
	
	await get_tree().create_timer(0.01).timeout
	
	Settings.load_settings()


func get_service(service_name : String) -> Service:
	return get_node(service_name)
	
	
func find_services() -> void:
	Console.log_rich("[rainbow]Finding services...[/rainbow]")
	find_services_at_path("res://Services")
	Console.log_rich("[color=pink]Services - %s[/color]" % [get_children()])
	
	
func find_services_at_path(path : String) -> void:
	var dir := DirAccess.open(path)
	dir.list_dir_begin()
	
	var files := dir.get_files()
	var dirs := dir.get_directories()
#	Console.log("path='%s', files=%s, dirs=%s" % [path, dir.get_files(), dir.get_directories()])
	
	for file in files:
		find_script(path, file)

	for d in dirs:
#		Console.log("\tdirs - path='%s', d='%s'" % [path, d])
		find_services_at_path(path + "/" + d)
	

func find_script(path : String, file_name : String) -> void:
	file_name = file_name.trim_suffix(".remap")
#	Console.log("\tnew=%s" % [file_name])
	if !file_name.ends_with(".gd"):
		return
	var script : GDScript = load(path + "/" + file_name)
#	Console.log("\tscript?=%s" % [path + "/" + file_name])
	if !script or script.new() is not Service:
		return

#	Console.log("\tscript!=%s" % [script])
	var service : Service = script.new()
	service.name = service.Name
	add_child(service)
	

func swap_scene(
	scn : PackedScene, 
	transition := ScreenTransitions.Transition.FadeToBlack,
	duration := 1.25,
	transition_in := true,
	ease : Tween.EaseType = Tween.EASE_OUT,
	trans : Tween.TransitionType = Tween.TRANS_LINEAR,
	delay := 0
) -> void:
	ScreenTransitionController.transition(transition, duration, transition_in, ease, trans, delay)

	await ScreenTransitionController.transition_finished
	
	if Dialogic.current_timeline:
		Dialogic.paused = false
		Dialogic.end_timeline()

	get_tree().change_scene_to_packed(scn)


func go_to_main_menu() -> void:
	swap_scene(main_menu_scn, ScreenTransitions.Transition.FadeToBlack, 1.25, true, Tween.EASE_OUT, Tween.TRANS_LINEAR, 1)


func credit_screen() -> void:
	swap_scene(credit_scn)
	
