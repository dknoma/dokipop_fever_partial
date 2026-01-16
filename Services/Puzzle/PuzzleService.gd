class_name PuzzleService extends Service

signal match_started()
signal match_finished(won : bool)

# Emitted when opponents SP gauge fills up all the way
signal opponent_skill_ready()

var current_match : MatchData
var current_player : CharacterData
var opponent : CharacterData

# updates player HP and opponent SP bar. Eventually can support different kinds of timers for other encounters
var player_hp_update_timer : StatUpdateTimer
var opponent_sp_update_timer : StatUpdateTimer

@onready var dragoon_keyhole : Texture2D = preload("res://assets/transition_art/dragoonkeyhole.png")
@onready var puzzle_game_scene_file := preload("res://scenes/puzzle_game_scene.tscn")
var puzzle_scene : PuzzleGameScene

var started : bool

func _ready() -> void:
	super._ready()


func _initialize(info : Dictionary) -> void:
	var path : String = info["path"]
	var match_data : MatchData = load(path)
	if !match_data: return

	if player_hp_update_timer: player_hp_update_timer.queue_free()
	if opponent_sp_update_timer: opponent_sp_update_timer.queue_free()
	
	current_match = match_data
	opponent = match_data.opponent # get opponent from MatchData
	current_player = Game.current_player

	current_player._on_match_start()
	opponent._on_match_start()

	current_player.hp.updated.connect(on_player_hp_changed)
	opponent.hp.updated.connect(on_opponent_hp_changed)

	player_hp_update_timer = StatUpdateTimer.new(current_player.hp, -1, current_player.stat_update_time)
	add_child(player_hp_update_timer)

	opponent_sp_update_timer = StatUpdateTimer.new(opponent.sp, 1, opponent.stat_update_time)
	add_child(opponent_sp_update_timer)

	opponent_sp_update_timer.value_maxed.connect(opponent_skill_ready.emit)
	

func _execute() -> void:
	start_match(current_match)
	

func _finish() -> void:
	puzzle_scene.finish_match()
	

# clean up timers and signal connections
func stop_execution() -> void:
	player_hp_update_timer.stop()
	opponent_sp_update_timer.stop()

	current_player.hp.updated.disconnect(on_player_hp_changed)
	opponent.hp.updated.disconnect(on_opponent_hp_changed)

	
func start_match(data : MatchData) -> void:
	ScreenTransitionController.transition(ScreenTransitions.Transition.FadeToBlack, 1.25, false, Tween.EASE_OUT, Tween.TRANS_LINEAR, 1)

	await get_tree().create_timer(0.05).timeout
	
	get_tree().change_scene_to_packed(puzzle_game_scene_file)
	
	await get_tree().create_timer(0.01).timeout
	
	await ScreenTransitionController.transition_finished
	
	current_match = data
	opponent = data.opponent
	started = true
	puzzle_scene = get_tree().get_current_scene()
	puzzle_scene.start_match(current_match)
	match_started.emit()
	
	
func pre_match(info : Dictionary) -> void:
	_initialize(info)

	ScreenTransitionController.keyhole_transition(dragoon_keyhole, 1, true, Tween.EASE_OUT, Tween.TRANS_LINEAR, Color.BLACK, 0)
	
	await ScreenTransitionController.transition_finished
	
	ScreenTransitionController.transition(ScreenTransitions.Transition.FadeToBlack, 1, false, Tween.EASE_OUT, Tween.TRANS_LINEAR, 0)

	
func start_match_manually(data : MatchData) -> void:
	get_tree().change_scene_to_packed(puzzle_game_scene_file)

	await get_tree().create_timer(0.01).timeout

	current_match = data
	opponent = data.opponent
	started = true
	puzzle_scene = get_tree().get_current_scene()
	puzzle_scene.start_match(current_match, current_match.volume)
	match_started.emit()


func _get_name() -> String:
	return "Puzzle"


func on_player_hp_changed(value : int) -> void:
	if value > 0:
		return
		
	Console.log("PLAYER DIED")
	match_finished.emit(false)


func on_opponent_hp_changed(value : int) -> void:
	if value > 0:
		return
		
	match_finished.emit(true)


## To be called when choosing an option after winning/losing
	
func continue_story() -> void:
	ScreenTransitionController.transition_finished.connect(func () -> void: puzzle_scene.finish_match(), CONNECT_ONE_SHOT)
	print(current_match.win_chapter)
	print(current_match.win_label)
	Game.Story.start_at(current_match.win_chapter, current_match.win_label)
	
	
func retry_match() -> void:
	ScreenTransitionController.transition(ScreenTransitions.Transition.FadeToBlack, 1, true, Tween.EASE_OUT, Tween.TRANS_LINEAR, 1)
	
	await ScreenTransitionController.transition_finished

	puzzle_scene.finish_match()
	started = false
	current_player.hp.updated.disconnect(on_player_hp_changed)
	opponent.hp.updated.disconnect(on_opponent_hp_changed)
	
	current_player._on_match_start()
	opponent._on_match_start()

	current_player.hp.updated.connect(on_player_hp_changed)
	opponent.hp.updated.connect(on_opponent_hp_changed)
	
	_execute()
