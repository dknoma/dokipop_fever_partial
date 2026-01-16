class_name PuzzleGameScene extends CanvasLayer

@export var audio : AudioStream

@export_group("UI")
@export var hud : PuzzleHUD
@export var screen_cover : ColorRect
@export var bubble_generator : BubbleGenerator

@export var start_match_ui : UIControl
@export var countdown_ctr : Control
@export var countdown_text : RichTextLabel # -1032.0, -732.0, -384.0, -36, 272

@export_group("Match Over Screens")
@export var win_screen : WinScreen
@export var lose_screen : LoseScreen

@export_group("Skip")
@export var skip_match_button : CustomTextButton
@export var skip_control : UIControl
@export var confirm_window : UIControl
@export var confirm_button : CustomTextureButton
@export var deny_button : CustomTextureButton

var current_match : MatchData
var countdown_tween : Tween
var start_text_tween : Tween

var match_ongoing := false


func _ready() -> void:
	confirm_window.hide()
	skip_control.hide()
	skip_match_button.disabled = true
	confirm_window.visibility_changed.connect(func () -> void:
		BubbleManager.pause_bubbles(confirm_window.visible)
	)
	
	BubbleManager.pause.connect(_on_paused)
	Game.Puzzle.match_finished.connect(_on_match_finished)
	skip_match_button.pressed.connect(_on_skip_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)
	deny_button.pressed.connect(_on_deny_pressed)


func start_match(match_data: MatchData, volume := 0.2) -> void:
#	screen_cover.hide()
	current_match = match_data
	hud.set_tutorial(current_match)
	hud.on_match_started()
	AudioManager.play_song(match_data.bgm if match_data.bgm != null else audio, volume)

	countdown_text.position = Vector2(0, -1032)
	countdown_ctr.show()
	
	countdown_tween = create_tween()
	
	countdown_tween.set_ease(Tween.EASE_IN_OUT)
	countdown_tween.set_trans(Tween.TRANS_ELASTIC)
	countdown_tween.tween_property(countdown_text, "position", Vector2(countdown_text.position.x, -732), 1)
	
	countdown_tween.set_ease(Tween.EASE_IN_OUT)
	countdown_tween.set_trans(Tween.TRANS_ELASTIC)
	countdown_tween.tween_property(countdown_text, "position", Vector2(countdown_text.position.x, -384), 1)
	
	countdown_tween.set_ease(Tween.EASE_IN_OUT)
	countdown_tween.set_trans(Tween.TRANS_ELASTIC)
	countdown_tween.tween_property(countdown_text, "position", Vector2(countdown_text.position.x, -36), 1)
	
	countdown_tween.set_ease(Tween.EASE_IN_OUT)
	countdown_tween.set_trans(Tween.TRANS_ELASTIC)
	countdown_tween.tween_property(countdown_text, "position", Vector2(countdown_text.position.x, 272), 0.5)
	
	countdown_tween.play()
	await countdown_tween.finished
	countdown_tween.stop()

	countdown_ctr.hide()
	start_match_ui.show_ui()
	
	await get_tree().create_timer(0.5).timeout
	
	var color := Color.WHITE
	color.a = 0
	
	start_text_tween = create_tween()
	start_text_tween.finished.connect(start_match_ui.hide, CONNECT_ONE_SHOT)
	start_text_tween.tween_property(start_match_ui, "modulate", color, 1)
	start_text_tween.play()
	await get_tree().create_timer(0.5).timeout
	
	Game.Puzzle.player_hp_update_timer.start()
	Game.Puzzle.opponent_sp_update_timer.start()
	
	bubble_generator.start_game()
	match_ongoing = true
	hud.settings_menu.can_show = true
	skip_control.show_ui()
	await skip_control.transition_finished
	skip_match_button.disabled = false


func _on_paused(paused : bool) -> void:
	if paused:
		if !match_ongoing:
			if countdown_tween && countdown_tween.is_running():
				countdown_tween.pause()
			if start_text_tween && start_text_tween.is_running():
				start_text_tween.pause()
	else:
		if !match_ongoing:
			if countdown_tween && !countdown_tween.is_running():
				countdown_tween.play()
			if start_text_tween && !start_text_tween.is_running():
				start_text_tween.play()


func finish_match() -> void:
	AudioManager.stop_song()
	hud.on_match_ended()
	hide()


func win_match() -> void:
	Game.Puzzle.on_opponent_hp_changed(0)

	
func lose_match() -> void:
	Game.Puzzle.on_player_hp_changed(0)

	
func _on_match_finished(won : bool) -> void:
	match_ongoing = false
	AudioManager.stop_song()
	if won:
		win_screen._select()
	else:
		if current_match.scripted_loss:
			skip_match()
		else:
			lose_screen._select()


func _on_skip_pressed() -> void:
	#Dialogic.paused = true
	confirm_button.disabled = true
	deny_button.disabled = true
	confirm_window.show_ui()
	
	await confirm_window.transition_finished
	
	confirm_button.disabled = false
	deny_button.disabled = false


func _on_deny_pressed() -> void:
	confirm_button.disabled = true
	deny_button.disabled = true
	confirm_window.hide_ui()


func _on_confirm_pressed() -> void:
	confirm_button.disabled = true
	deny_button.disabled = true
	confirm_window.hide_ui()
	
	await confirm_window.transition_finished
	
	skip_match()


func skip_match() -> void:
	Game.Puzzle.stop_execution()
	Game.Puzzle.continue_story()
