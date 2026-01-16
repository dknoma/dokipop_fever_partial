@tool
class_name TutorialScreenLayer extends DialogicLayoutLayer

signal closed()

@onready var canvas_layer : CanvasLayer = $CanvasLayer

var tutorial_window : TutorialWindow


func set_tutorial_screen(scn : PackedScene) -> void:
	if tutorial_window:
		tutorial_window.queue_free()
	
	var scene := scn.instantiate()
	if scene is TutorialWindow:
		tutorial_window = scene
		tutorial_window.closed.connect(closed.emit, CONNECT_ONE_SHOT)
		tutorial_window.hide()
		canvas_layer.add_child(tutorial_window)
		tutorial_window.show_ui()
