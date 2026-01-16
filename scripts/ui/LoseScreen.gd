class_name LoseScreen extends Control

@export var text_tweener : UIControl
@export var dimmer : UIControl
@export var blur_screen : ColorRect
@export var button_tweener : UIControl
@export var retry_button : CustomTextureButton
@export var exit_button : CustomTextureButton

@export var lose_jingle : AudioStream


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	retry_button.disabled = true
	exit_button.disabled = true
	blur_screen.hide()
	text_tweener.hide()
	dimmer.hide()
	button_tweener.hide()
	(blur_screen.material as ShaderMaterial).set_shader_parameter("amount", 0)
	

func _select() -> void:
	AudioManager.play_sfx(lose_jingle, 0.3)
	retry_button.pressed.connect(_on_retry_pressed, CONNECT_ONE_SHOT)
	exit_button.pressed.connect(_on_exit_pressed, CONNECT_ONE_SHOT)
	mouse_filter = MOUSE_FILTER_STOP
	Game.Puzzle.stop_execution()

	blur_screen.show()
	var tween := create_tween()
	tween.tween_method(set_blur_amount, 0.0, 3.5, 0.5)
	tween.play()

	dimmer.show_ui()
	text_tweener.show_ui()
	
	await text_tweener.transition_finished

	button_tweener.show_ui()
	
	await button_tweener.transition_finished

	retry_button.disabled = false
	exit_button.disabled = false

	
func set_blur_amount(value : float) -> void:
	(blur_screen.material as ShaderMaterial).set_shader_parameter("amount", value)


func _on_retry_pressed() -> void:
	retry_button.disabled = true
	exit_button.disabled = true
	Game.Puzzle.retry_match()

	
func _on_exit_pressed() -> void:
	retry_button.disabled = true
	exit_button.disabled = true
	Game.Puzzle.stop_execution()
	Game.go_to_main_menu()
