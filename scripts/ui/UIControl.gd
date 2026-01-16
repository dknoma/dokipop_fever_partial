#@tool
class_name UIControl extends Control

# TODO: support FadeAndSlide - fades in & slides into position
enum TransitionStyle {
	None,
	Fade,
	Slide,
	ChangeSize,
	Modulate
}

enum State {
	None,
	Transitioning
}

# Which direction to slide TO - Left means slide from right to left
enum Direction {
	Up,
	Down,
	Left,
	Right
}

signal transition_finished()

@export var transition_style := TransitionStyle.None
@export var ease_type : Tween.EaseType = Tween.EaseType.EASE_IN
@export var transition_type : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var duration := 1.0
@export var direction := Direction.Up

@export var in_delay := 0.0
@export var out_delay := 0.0
@export var start_offset := Vector2.ZERO
@export var grow_size_multiplier := 1.50

@export var properties := {}


#@export_tool_button("Show") var show_button : Callable = show_ui
#@export_tool_button("Hide") var hide_button : Callable = hide_ui

var tween : Tween
var state : State = State.None
var original_position : Vector2

var fully_shown := false


func _ready() -> void:
	fully_shown = false
	original_position = position
	

func from_props(props : Dictionary) -> void:
	if props.has("duration"):
		duration = props["duration"]
	if props.has("transition_type"):
		transition_type = props["transition_type"]
	if props.has("ease_type"):
		ease_type = props["ease_type"]
	if props.has("in_delay"):
		in_delay = props["in_delay"]
	if props.has("out_delay"):
		out_delay = props["out_delay"]
	if props.has("start_offset"):
		start_offset = props["start_offset"]


func show_ui(props := {}) -> void:
	fully_shown = false
	from_props(props)
	if visible or state == State.Transitioning: return
	if in_delay > 0:
		await get_tree().create_timer(in_delay).timeout
#	print("show_ui['%s']" % [name])
	state = State.Transitioning
	match transition_style:
		TransitionStyle.Fade:
			modulate.a = 0
			show()
			var color := modulate
			color.a = 1
			tween = get_tree().create_tween()
			tween.finished.connect(reset_state, CONNECT_ONE_SHOT)
			tween.set_trans(transition_type)
			tween.set_ease(ease_type)
			tween.tween_property(self, "modulate", color, duration)
			tween.play()
		TransitionStyle.Slide:
			var rect := get_viewport_rect()
			var target_pos := position
			
			position.x = (position.x + rect.size.x if direction == Direction.Left else \
						 position.x - rect.size.x if direction == Direction.Right else \
						 position.x) + start_offset.x
			position.y = (position.y + rect.size.y if direction == Direction.Up else \
						 position.y - rect.size.y if direction == Direction.Down else \
						 position.y) + start_offset.y
			
			show()
			tween = get_tree().create_tween()
			tween.finished.connect(reset_state, CONNECT_ONE_SHOT)
			tween.set_trans(transition_type)
			tween.set_ease(ease_type)
			tween.tween_property(self, "position", target_pos, duration)
			tween.play()
		TransitionStyle.ChangeSize:
			var original_size := scale
			scale *= grow_size_multiplier
			show()
			tween = get_tree().create_tween()
			tween.finished.connect(reset_state, CONNECT_ONE_SHOT)
			tween.set_trans(transition_type)
			tween.set_ease(ease_type)
			tween.tween_property(self, "scale", original_size, duration)
			tween.play()
		TransitionStyle.Modulate:
			var from : Color = properties["from_color"]
			var to : Color = properties["to_color"]
			modulate = from
			show()
			tween = get_tree().create_tween()
			tween.finished.connect(reset_state, CONNECT_ONE_SHOT)
			tween.set_trans(transition_type)
			tween.set_ease(ease_type)
			tween.tween_property(self, "modulate", to, duration)
			tween.play()
		_:
			state = State.None
			show()
			transition_finished.emit()
		
	_show_ui()


func hide_ui(force_visible := false, props := {}) -> void:
	fully_shown = false
	from_props(props)
	if state == State.Transitioning: return
	if !force_visible and !visible : return
	show()
	if out_delay > 0:
		await get_tree().create_timer(out_delay).timeout
#	print("hide_ui['%s']" % [name])
	state = State.Transitioning
	match transition_style:
		TransitionStyle.Fade:
			if !visible: return
			modulate.a = 1
			var color := modulate
			color.a = 0
			tween = get_tree().create_tween()
			tween.finished.connect(hide_and_reset, CONNECT_ONE_SHOT)
			tween.set_trans(transition_type)
			tween.set_ease(ease_type)
			tween.tween_property(self, "modulate", color, duration)
			tween.play()
		TransitionStyle.Slide:
			var rect := get_viewport_rect()
			var target_pos := position
			
			target_pos.x = position.x + rect.size.x if direction == Direction.Left else \
						   position.x - rect.size.x if direction == Direction.Right else \
						   position.x
			target_pos.y = position.y + rect.size.y if direction == Direction.Up else \
						   position.y - rect.size.y if direction == Direction.Down else \
						   position.y
			
			tween = get_tree().create_tween()
			tween.finished.connect(hide_and_reset, CONNECT_ONE_SHOT)
			tween.set_trans(transition_type)
			tween.set_ease(ease_type)
			tween.tween_property(self, "position", target_pos, duration)
			tween.play()
		TransitionStyle.ChangeSize:
			var original_size := scale
			scale *= grow_size_multiplier
			show()
			tween = get_tree().create_tween()
			tween.finished.connect(reset_state, CONNECT_ONE_SHOT)
			tween.set_trans(transition_type)
			tween.set_ease(ease_type)
			tween.tween_property(self, "scale", Vector2.ZERO, duration)
			tween.play()
		TransitionStyle.Modulate:
			var from : Color = properties["from_color"]
			var to : Color = properties["to_color"]
			modulate = to
			show()
			tween = get_tree().create_tween()
			tween.finished.connect(reset_state, CONNECT_ONE_SHOT)
			tween.set_trans(transition_type)
			tween.set_ease(ease_type)
			tween.tween_property(self, "modulate", from, duration)
			tween.play()
		_:
			state = State.None
			hide()
			transition_finished.emit()
	_hide_ui()


func reset_state() -> void:
	state = State.None
	transition_finished.emit()
	fully_shown = true


func hide_and_reset() -> void:
	hide()
	position = original_position
	reset_state()


func _show_ui() -> void:
	pass


func _hide_ui() -> void:
	pass
