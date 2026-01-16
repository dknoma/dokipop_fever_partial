@tool
extends DialogicEvent
class_name DialogicShowImageEvent

# Define properties of the event here
var file_path := ""


func _execute() -> void:
	var subsystem : ShowImageSubsystem = dialogic.get_subsystem("ShowImage")
	subsystem.set_image(file_path)
	subsystem.finished.connect(finish, CONNECT_ONE_SHOT)


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Show Image"
	set_default_color('Color8')
	event_category = "Custom"



#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "show_image"

func get_shortcode_parameters() -> Dictionary:
	return {
		#param_name 		: property_info
		#"my_parameter"		: {"property": "property", "default": "Default"},
		"file_path" 		:  {"property": "file_path", 	"default": ''},
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_edit('file_path', ValueType.FILE,
		{'left_text'	: 'Collectible file',
			'file_filter' 	: '*.tres; Collectible Files',
			'placeholder' 	: "Select collectible",
			'editor_icon' 	: ["Image", "EditorIcons"]})

#endregion
