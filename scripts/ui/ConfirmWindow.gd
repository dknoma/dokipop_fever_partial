class_name ConfirmWindow extends UIControl

signal canceled()

@export var confirm_button : CustomTextureButton
@export var deny_button : CustomTextureButton


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ExitMenu", false):
		_on_exit_pressed()
		

func _on_exit_pressed() -> void:
	confirm_button.disabled = true
	deny_button.disabled = true
	hide_ui()
	
	await transition_finished
	
	canceled.emit()
