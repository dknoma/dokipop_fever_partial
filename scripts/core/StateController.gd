extends Node


#const MENU_SELECT := "MenuSelect"
#const STORY_MODE := "StoryMode"
#const ENDLESS_MODE := "EndlessMode"
#const PUZZLE_GAME := "PuzzleGame"

#@export var menu_select : MenuSelect
#@export var story_mode : StoryMode
#@export var puzzle_game : PuzzleGame


#var states : Dictionary[String, GameState] = {}
#var current_state : GameState
#var current_player : CharacterData
#
#
#func _ready() -> void:
#	for child : Node in get_children():
#		if child is GameState:
#			states[child.name] = child
#			
#	current_state = states.values()[0]
#	current_state._init()	
			
		
#func start_state() -> void:
#	current_state.start()
#	
#	
#func swap_state(state : String) -> void:
#	current_state.finish()
#	
#	await current_state.finished
#	
#	var next := states[state]
#	next.start()
	
	
#func start_puzzle(info : Dictionary) -> void:
#	current_state.finish(info)
#
#	await current_state.finished
#	puzzle_game.start(info)
