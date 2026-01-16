## 
class_name UIController extends Control

signal transition_finished()
signal show_finished()
signal hide_finished()

var ui_controls : Dictionary[String, UIControl] = {}


func _ready() -> void:
	ui_controls.clear()
	find_ui_controls(self, ui_controls)
#	Console.log("ui_controls=%s" % [ui_controls])


static func find_ui_controls(parent : Node, control_dict : Dictionary[String, UIControl]) -> void:
	var queue := parent.get_children()
	for child : Node in parent.get_children():
		if child is UIControl:
			control_dict[child.name] = child as UIControl
	
	while queue.size() > 0:
		var next : Node = queue.pop_front()
		find_ui_controls(next, control_dict)


func show_ui(ui_name : String, props := {}) -> void:
	var control := ui_controls[ui_name]
	if control:
		control.transition_finished.connect(transition_finished.emit, CONNECT_ONE_SHOT)
		control.transition_finished.connect(show_finished.emit, CONNECT_ONE_SHOT)
		control.show_ui(props)


func hide_ui(ui_name : String, props := {}) -> void:
	var control := ui_controls[ui_name]
	if control:
		control.transition_finished.connect(transition_finished.emit, CONNECT_ONE_SHOT)
		control.transition_finished.connect(hide_finished.emit, CONNECT_ONE_SHOT)
		control.hide_ui(props["force_visible"] if props.has("force_visible") else false, props)
