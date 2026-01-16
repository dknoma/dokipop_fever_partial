class_name InputCapture extends Control

signal clicked_on()


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	
	
func _on_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("MouseLeftClick") and !event.is_echo():
		hide()
		get_viewport().set_input_as_handled()
		clicked_on.emit()