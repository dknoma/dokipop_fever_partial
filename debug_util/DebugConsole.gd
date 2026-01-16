extends Control

@export var window : Window
@export var output : RichTextLabel

var opened : bool = false


func _ready() -> void:
	window.hide()


# print to console & print to debug window
func log(value : Variant) -> void:
	print(value)
	output.text += "\n%s" % [value]


func log_rich(value : Variant) -> void:
	print_rich(value)
	output.text += "\n%s" % [value]

	
func logf(v : Variant, values : Array) -> void:
	print(v, values)
	output.text += "\n%s" % [v % [values]]
	
	
func log_info(text : String, identifier : String) -> void:
	print(text)
	output.text += "\n%s: %s" % [identifier, text]


func log_warn(text : String) -> void:
	print(text)
	output.text += "\n[color=orange]%s[/color]" % [text]


func log_error(text : String) -> void:
	print(text)
	output.text += "\n[color=red]%s[/color]" % [text]


func _input(event : InputEvent) -> void:
	if event is not InputEventKey:
		return
	
	#if event.is_pressed() and !event.is_echo(): 
		#if event.keycode == KEY_F1:
			#open_close()


func open_close() -> void:
	if window.visible:
		window.hide()
	else:
		window.show()
