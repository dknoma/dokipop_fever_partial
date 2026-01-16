class_name Menu extends UIControl


var ui_controls : Dictionary[String, UIControl] = {}


func _ready() -> void:
	UIController.find_ui_controls(self, ui_controls)
	for control : UIControl in ui_controls.values():
		control.hide()


func show_ui(props := {}) -> void:
	from_props(props)
	show()
	await get_tree().create_timer(in_delay).timeout
	var to_wait := 0.0
	var ui := ui_controls.values()
	for control : UIControl in ui:
		to_wait = max(control.duration, to_wait)
	for control : UIControl in ui:
		control.show_ui()
		
	await get_tree().create_timer(to_wait).timeout
	transition_finished.emit()
		
		
func hide_ui(force_visible := false, props := {}) -> void:
	from_props(props)
	if state == State.Transitioning: return
	if !force_visible and !visible : return
	
	var to_wait := 0.0
	await get_tree().create_timer(out_delay).timeout
	var ui := ui_controls.values()
	for control : UIControl in ui:
		to_wait = max(control.duration, to_wait)
	for control : UIControl in ui:
		control.hide_ui()
		
	await get_tree().create_timer(to_wait).timeout
	
	hide()
	transition_finished.emit()
	
	
func hide_children_only(wait := 0.0) -> void:
	await get_tree().create_timer(wait).timeout
	var to_wait := 0.0
	var ui := ui_controls.values()
	for control : UIControl in ui:
		to_wait = max(control.duration, to_wait)
	for control : UIControl in ui:
		control.hide_ui()
		
	await get_tree().create_timer(to_wait).timeout
	transition_finished.emit()
