@tool
extends DialogicEvent
class_name DialogicPuzzleGameEvent


var match_data : MatchData
var file_path := "":
	set(value):
		if file_path != value:
			file_path = value
			ui_update_needed.emit()

# Define properties of the event here

func _execute() -> void:
#	Game.Puzzle.win_continue.connect(_on_won, CONNECT_ONE_SHOT)
#	Game.Puzzle.lose_continue.connect(_on_lose, CONNECT_ONE_SHOT)
#	var subsystem : SubsystemPuzzleGame = dialogic.get_subsystem("PuzzleGame")
#	subsystem.start_match(file_path)
	var dict := { 'path': file_path }
	dialogic.current_state_info['match_file_path'] = file_path
	#dialogic.VAR.set_variable("force_disable", true)
	dialogic.Styles.get_layout_node().hide() # hides all the dialogue layout nodes
	#	Game.Story.hide_story_scene()
	Game.Puzzle._initialize(dict)
	Game.Puzzle._execute()
	finish()
	

#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Start Puzzle Game"
	set_default_color('Color8')
	event_category = "Custom"



#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "puzzle_game"

	
func get_shortcode_parameters() -> Dictionary:
	return {
		#param_name 		: property_info
		#"my_parameter"		: {"property": "property", "default": "Default"},
		"path"		: {"property": "file_path", 	"default": ""},
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_edit('file_path', ValueType.FILE,
		{'left_text'	: 'Start Match',
			'file_filter' 	: '*.tres; Resource Files',
			'placeholder' 	: "Select file",
			'editor_icon' 	: ["TripleBar", "EditorIcons"]})
#endregion
