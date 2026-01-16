@tool
class_name ShowImageLayer extends DialogicLayoutLayer

signal finished()

@onready var texture_rect : TextureRect = $InputCapture/show_image_control/TextureRect
@onready var show_image_control : UIControl = $InputCapture/show_image_control
@onready var input_capture : InputCapture = $InputCapture


func _ready() -> void:
	super._ready()
	input_capture.hide()
	input_capture.clicked_on.connect(_on_input_captured)
	input_capture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	

func show_image(collectible: Collectible) -> void:
	texture_rect.texture = collectible.texture
	input_capture.show()
	show_image_control.show_ui()
	
	await show_image_control.transition_finished

	input_capture.mouse_filter = Control.MOUSE_FILTER_STOP

	
func _on_input_captured() -> void:
	input_capture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	show_image_control.hide_ui()
	finished.emit()
