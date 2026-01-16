class_name PuzzleHUD extends UIControl

@export var settings_menu : SettingsMenu
@export var settings_button : CustomTextureButton

@export var player : CharacterData
@export var opponent : CharacterData

@export var portrait_left : TextureRect
@export var portrait_bg_left : TextureRect
@export var portrait_right : TextureRect
@export var portrait_bg_right: TextureRect

@export var tutorial_canvas : CanvasLayer
@export var opponent_skill_tutorial_button : CustomTextureButton
@export var blur_rect : ColorRect

@export_group("Match Info")
@export var combo_label : RichTextLabel

@export_group("Resource Bars")
@export var player_hp_bar : TextureProgressBar
@export var player_sp_bar : TextureProgressBar
@export var player_hp_percent : StatLabel
@export var player_sp_value : StatLabel

@export var opponent_hp_bar : TextureProgressBar
@export var opponent_sp_bar : TextureProgressBar
@export var opponent_hp_percent : StatLabel
@export var opponent_sp_value : StatLabel

@export var player_name : RichTextLabel
@export var opponent_name : RichTextLabel

@export var fill_time := 0.75

@export_group("Player UIControl")
@export var player_portrait_control : UIControl
@export var player_name_control : UIControl
@export var player_hp_bar_control : UIControl
@export var player_sp_bar_control : UIControl
@export var player_hp_percent_control : UIControl
@export var player_sp_value_control : UIControl
@export var sp_bar_glow : Sprite2D

@export_group("Opponent UIControl")
@export var opponent_portrait_control : UIControl
@export var opponent_name_control : UIControl
@export var opponent_hp_bar_control : UIControl
@export var opponent_sp_bar_control : UIControl
@export var opponent_hp_percent_control : UIControl
@export var opponent_sp_value_control : UIControl

var initialized := false
var ui_controls : Dictionary[String, UIControl] = {}

var current_match : MatchData

var finished_count := 0

# rainbow overlay properties
# used to change overlay properties using move_toward()
var overlay_target_opacity:float = 0.2
var overlay_target_opacity_max:float = 1.2
var red_overlay_target_opacity:float = 0

var tutorial_window : TutorialWindow


func _ready() -> void:
	sp_bar_glow.hide()
	settings_button.pressed.connect(_on_settings_pressed)
	settings_menu.canceled.connect(_on_settings_closed)
	settings_menu.visibility_changed.connect(func () -> void:
		BubbleManager.pause_bubbles(settings_menu.visible)
	)
	opponent_skill_tutorial_button.pressed.connect(_on_show_opponent_tutorial)
	opponent_skill_tutorial_button.disabled = true
	player.hp_updated.connect(_on_player_hp_updated)
	ChainHandler.update_chain.connect(on_chain_members_updated)
	
	UIController.find_ui_controls(self, ui_controls)
	
	for control : UIControl in ui_controls.values():
		control.hide()
	
	hide()


func _on_settings_pressed() -> void:
	settings_menu._show()
	BubbleManager.pause_bubbles(true)


func _on_settings_closed() -> void:
	BubbleManager.pause_bubbles(false)


func _physics_process(delta: float) -> void:
	# makes it red when player is dying
	if player.current_hp < player.hp.max_value/2:
		red_overlay_target_opacity = 1 - player.current_hp / (player.hp.max_value / 2)
	if $rainbow_overlay:
		$rainbow_overlay.set_opacity(overlay_target_opacity)
	if $red_overlay:
		$red_overlay.set_opacity(move_toward($red_overlay.get_opacity(), red_overlay_target_opacity, 2 * delta))
	overlay_target_opacity = move_toward(overlay_target_opacity, 0.35, delta)


func _on_player_hp_updated(new_current_value, value):
	if overlay_target_opacity + value/2 >= overlay_target_opacity_max:
		overlay_target_opacity = overlay_target_opacity_max
	else:
		overlay_target_opacity += value/2
	print(value)


func _show_ui() -> void:
	for control : UIControl in ui_controls.values():
		control.transition_finished.connect(_on_child_finished_ani, CONNECT_ONE_SHOT)
		control.show_ui()


func _on_child_finished_ani() -> void:
	finished_count += 1
	if finished_count == ui_controls.size():
		transition_finished.emit()

		
func set_match_data(match_data: MatchData) -> void:
	current_match = match_data
	player = Game.current_player
	opponent = current_match.opponent


func set_tutorial(match_data : MatchData) -> void:
	var scn = match_data.tutorial_scn.instantiate()
	if scn is TutorialWindow:
		if tutorial_window:
			tutorial_window.queue_free()
		tutorial_window = scn
		tutorial_window.hide()
		tutorial_canvas.add_child(tutorial_window)
		tutorial_window.visibility_changed.connect(func () -> void:
			blur_rect.visible = tutorial_window.visible
			BubbleManager.pause_bubbles(tutorial_window.visible )
		)


func _on_show_opponent_tutorial() -> void:
	if tutorial_window:
		tutorial_window.show_ui()


func on_match_started() -> void:
	if initialized:
		Console.log("match already started")
		return
	
	if !player_name or !opponent:
		Console.log_error("player['%s'] or opponent['%s'] not found" % [player, opponent])
		return

	settings_menu.can_show = false
	initialized = true

	current_match = Game.Puzzle.current_match
	player = Game.current_player
	opponent = current_match.opponent
	
#	player._on_match_start()
#	opponent._on_match_start()

	sp_bar_glow.hide()
	portrait_bg_left.self_modulate = player.dialogue_data.color
	portrait_left.texture = player.portrait
	player_name.text = "[color=%s]%s[/color]" % [player.dialogue_data.color, player.name]

	portrait_bg_right.self_modulate = opponent.dialogue_data.color
	portrait_right.texture = opponent.portrait
	opponent_name.text = "[color=%s]%s[/color]" % [opponent.dialogue_data.color, opponent.name]
	
	player_hp_bar.max_value = player.hp.max_value
	player_sp_bar.max_value = player.sp.max_value
	player_hp_bar.value = player.hp.base_value
	player_sp_bar.value = player.sp.value
	# this is done to match the text values to the tweening values of the ProgressBars
	player_hp_bar.value_changed.connect(func (value : float) -> void: update_stat_label(value, player_hp_bar, player_hp_percent))
	player_sp_bar.value_changed.connect(func (value : float) -> void:
		update_stat_label(value, player_sp_bar, player_sp_value)
		if value == player.sp.max_value:
			sp_bar_glow.show()
		else:
			sp_bar_glow.hide()
	)
	player.hp.subscribe(func (value : float) -> void: on_value_changed(value, player_hp_bar))
	player.sp.subscribe(func (value : float) -> void: on_value_changed(value, player_sp_bar))
	update_stat_label(player.hp.value, player_hp_bar, player_hp_percent)
	update_stat_label(player.sp.value, player_sp_bar, player_sp_value)

	opponent_hp_bar.max_value = opponent.hp.max_value
	opponent_sp_bar.max_value = opponent.sp.max_value
	opponent_hp_bar.value = opponent.hp.base_value
	opponent_sp_bar.value = opponent.sp.value
	opponent_hp_bar.value_changed.connect(func (value : float) -> void: update_stat_label(value, opponent_hp_bar, opponent_hp_percent))
	opponent_sp_bar.value_changed.connect(func (value : float) -> void: update_stat_label(value, opponent_sp_bar, opponent_sp_value))
	opponent.hp.subscribe(func (value : float) -> void: on_value_changed(value, opponent_hp_bar))
	opponent.sp.subscribe(func (value : float) -> void: on_value_changed(value, opponent_sp_bar))
	update_stat_label(opponent.hp.value, opponent_hp_bar, opponent_hp_percent)
	update_stat_label(opponent.sp.value, opponent_sp_bar, opponent_sp_value)

	show_ui()
	
	await transition_finished
	
	opponent_skill_tutorial_button.disabled = false
	

func on_match_ended() -> void:
	if !initialized:
		Console.log("no ongoing match")
		return
		
	initialized = false

	for control : UIControl in ui_controls.values():
		control.hide()
	hide()
	

func on_value_changed(value : float, progress_bar : TextureProgressBar) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(progress_bar, "value", value, 0.125)
	tween.play()


func update_stat_label(value : float, progress_bar : TextureProgressBar, label : StatLabel) -> void:
	label.update_text("%d" % [ceili(value)])
	

func on_chain_members_updated(count : int) -> void:
	if count == 0:
		combo_label.text = ""
		combo_label.hide()
		return
	else:
		combo_label.show()
	
	var old_size := combo_label.size
	#combo_label.size = combo_label.size * 3
	combo_label.text = "[rainbow]%d size[/rainbow]" % [count]
	var tween := get_tree().create_tween()
	tween.tween_property(combo_label, "size", old_size, 0.125)
	tween.play()
