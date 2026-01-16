class_name WinScreen extends Control

@export var blur_screen : ColorRect
@export var text_tweener : UIControl
@export var button_tweener : UIControl
@export var button : CustomTextureButton


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	button.disabled = true
	blur_screen.hide()
	text_tweener.hide()
	button_tweener.hide()
	(blur_screen.material as ShaderMaterial).set_shader_parameter("amount", 0)
	

func _select() -> void:
	button.pressed.connect(_on_continue_pressed, CONNECT_ONE_SHOT)
	mouse_filter = MOUSE_FILTER_STOP
	Game.Puzzle.stop_execution()

	blur_screen.show()
	var tween := create_tween()
	tween.tween_method(set_blur_amount, 0.0, 3.5, 0.5)
	tween.play()
	text_tweener.show_ui()
	
	await text_tweener.transition_finished

	button_tweener.show_ui()
	
	await button_tweener.transition_finished

	button.disabled = false


func set_blur_amount(value : float) -> void:
	(blur_screen.material as ShaderMaterial).set_shader_parameter("amount", value)
	

func _on_continue_pressed() -> void:
	button.disabled = true
	Game.Puzzle.continue_story()
