class_name CustomTextureButton extends TextureButton

@export var pressed_sfx : AudioStream = preload("res://assets/audio/DokiFrenzy_Sounds/yes.wav")
@export_range(0.05, 1) var pressed_volume := 0.3
@export var hover_sfx : AudioStream = preload("res://assets/audio/ui/ui_button_simple_click_03.wav")
@export_range(0.05, 1) var hover_volume := 0.3


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed_sfx)

	
func _on_pressed_sfx() -> void:
	if !pressed_sfx: return # don't play sfx if null
	AudioManager.play_sfx(pressed_sfx, pressed_volume)


func _on_mouse_entered() -> void:
	if disabled || Game.state == Game.State.Transitioning: return # no sfx if transitioning
	if !hover_sfx: return # don't play sfx if null
	AudioManager.play_sfx(hover_sfx, hover_volume)
