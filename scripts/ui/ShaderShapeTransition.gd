class_name ShaderShapeTransition extends UIControl

@export var shader : Shader
@export var shape_texture : Texture2D

## The base texture that the shaders uses for the keyhole transition
var base_texture : Control

var transitioned := false
var delay_timer : Timer

func _ready() -> void:
	super._ready()
	base_texture = $Texture
	delay_timer = Timer.new()
	add_child(delay_timer)
	
	transitioned = false
	(base_texture.material as ShaderMaterial).set_shader_parameter("mask", shape_texture)

	
func transition(
	texture : Texture2D,
	duration : float,
	transition_in : bool,
	ease_type : Tween.EaseType,
	transition_type : Tween.TransitionType,
	color : Color,
	wait := 0.0
) -> void:
	(base_texture.material as ShaderMaterial).set_shader_parameter("mask", texture)
	self.duration = duration
	self.ease_type = ease_type
	self.transition_type = transition_type
	base_texture.modulate = color
	
	if transition_in:
		Console.log("showing shader shape")
		show_ui({ "in_delay": wait})
	else:
		# force to be visible
		Console.log("hiding shader shape")
		hide_ui(true, { "out_delay": wait})
	


func show_ui(props := {}) -> void:
	from_props(props)
	if visible or state == State.Transitioning:
		Console.log_warn("Already transitioning...")
		reset_state()
		return
		
	#delay_timer.timeout.connect(func () -> void: Console.log("THIS TIMER HAS TIMED OUT!!!"), CONNECT_ONE_SHOT)
	if out_delay > 0:
		delay_timer.start(out_delay)
		await delay_timer.timeout
#	await get_tree().create_timer(in_delay).timeout
	Console.log("show_ui['%s']" % [name])
	state = State.Transitioning
	base_texture.material.set_shader_parameter("scale", 0.0)
	show()
	tween = create_tween()
	Console.log("tween['%s']" % [tween])
	tween.finished.connect(reset_state, CONNECT_ONE_SHOT)
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	tween.tween_method(set_shader_scale, 0.0, 1.0, duration)
	tween.play()

	transitioned = true
	_show_ui()


func hide_ui(force_visible := false, props := {}) -> void:
	from_props(props)
	if state == State.Transitioning:
		Console.log_warn("Already transitioning...")
		reset_state()
		return
	if !force_visible and !visible:
		Console.log_warn("not visible and not forced to show...")
		reset_state()
		return

	state = State.Transitioning
	base_texture.material.set_shader_parameter("scale", 1.0)
	show()

	if out_delay > 0:
		delay_timer.start(out_delay)
		await delay_timer.timeout

	Console.log("hide_ui['%s']" % [name])
	tween = create_tween()
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	tween.tween_method(set_shader_scale, 1.0, 0.0, duration)
	tween.play()

	transitioned = false
	_hide_ui()
	
	await tween.finished
	
	hide_and_reset()	


func set_shader_scale(value : float) -> void:
	base_texture.material.set_shader_parameter("scale", value)


func reset_state() -> void:
	Console.log("Shader shape transition finished")
	state = State.None
	transition_finished.emit()
	

func hide_and_reset() -> void:
	Console.log("hiding and reset")
	hide()
	position = original_position
	reset_state()
