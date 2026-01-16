class_name StageSelectButton extends CustomTextureButton

@export var chapter : Chapter
@export var start_label : String
@export var dialogic_flag_name : String


func _ready() -> void:
	super._ready()
	pressed.connect(_on_pressed)

	Dialogic.VAR.variable_changed.connect(_on_variable_changed)
	Dialogic.VAR.variable_was_set.connect(_on_variable_changed)
	
	if dialogic_flag_name.is_empty(): return
	
	var flag : bool = Dialogic.VAR.get_variable(dialogic_flag_name)
	
	disabled = !flag
	
	
func _on_pressed() -> void:
	if chapter == null: return
	Game.Story.start_chapter(chapter)
	
	
func _on_variable_changed(info : Dictionary) -> void:
	var var_name : String = info["variable"]
	var unlocked : Variant = info["new_value"]
	
	if var_name == dialogic_flag_name:
		disabled = !unlocked
