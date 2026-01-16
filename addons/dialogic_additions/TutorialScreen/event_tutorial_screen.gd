@tool
extends DialogicEvent
class_name DialogicTutorialScreenEvent

## The scene to use.
var scene := ""

func _execute() -> void:
	if scene.ends_with(".tscn") || scene.ends_with(".scn"):
		var subsystem : TutorialScreenSubsystem = dialogic.get_subsystem("Tutorial")
		subsystem.show_tutorial_screen(scene)
		
		await subsystem.finished
	
	finish() # called to continue with the next event


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Tutorial Screen"
	set_default_color('Color8')
	event_category = "Custom"



#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "tutorial_screen"

func get_shortcode_parameters() -> Dictionary:
	return {
		#param_name 		: property_info
		#"my_parameter"		: {"property": "property", "default": "Default"},
		"scene" 			: {"property": "scene", 			"default": ""},
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_edit("scene", ValueType.FILE,
			{'file_filter':'*.tscn, *.scn; Scene Files',
			'placeholder': "Custom scene",
			'editor_icon': ["PackedScene", "EditorIcons"],
			})

#endregion
