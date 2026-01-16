class_name ConsoleWindow extends Window


func _input(event : InputEvent) -> void:
	if event is not InputEventKey: return
		
	if event.is_pressed() and !event.is_echo(): 
		if event.keycode == KEY_F1:
			hide()
